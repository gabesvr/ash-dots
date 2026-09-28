// ash-tray — bandeja (StatusNotifierItem) para o yambar, em C + sd-bus.
//
// Registra o org.kde.StatusNotifierWatcher, acompanha os apps em segundo plano
// e emite para o yambar as tags trayN (glifo Nerd Font) e trayN_on (bool).
// O estado vai para $XDG_RUNTIME_DIR/ash-tray (TSV), lido pelo tray-click.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <systemd/sd-bus.h>

#define WATCHER    "org.kde.StatusNotifierWatcher"
#define ITEM_IFACE "org.kde.StatusNotifierItem"
#define MAX_ITEMS  16
#define SLOTS      8

struct item {
    char bus[128], path[256], menu[256], title[128];
    const char *glyph;
    int is_menu;
};

static struct item items[MAX_ITEMS];
static int n_items;
static sd_bus *bus;
static char state_path[512];

// Glifo por app: procura a chave no Id / IconName / Title (sem diferenciar maiúsculas)
static const struct { const char *key, *name, *glyph; } glyphs[] = {
    { "discord",   "Discord",   u8"\U000f066f" },
    { "steam",     "Steam",     u8"" },
    { "spotify",   "Spotify",   u8"" },
    { "telegram",  "Telegram",  u8"" },
    { "obs",       "OBS",       u8"\U000f0949" },
    { "nm-applet", "Rede",      u8"\U000f05a9" },
    { "blueman",   "Bluetooth", u8"\U000f00af" },
};
static const char *default_glyph = u8"\U000f003b";

static void get_str(const char *b, const char *p, const char *prop, char *out, size_t n) {
    char *v = NULL;
    out[0] = 0;
    if (sd_bus_get_property_string(bus, b, p, ITEM_IFACE, prop, NULL, &v) >= 0 && v)
        snprintf(out, n, "%s", v);
    free(v);
}

static void get_obj(const char *b, const char *p, const char *prop, char *out, size_t n) {
    sd_bus_message *reply = NULL;
    const char *v = NULL;
    out[0] = 0;
    if (sd_bus_get_property(bus, b, p, ITEM_IFACE, prop, NULL, &reply, "o") >= 0 &&
        sd_bus_message_read(reply, "o", &v) >= 0 && v)
        snprintf(out, n, "%s", v);
    sd_bus_message_unref(reply);
}

static void emit(void) {
    FILE *f = fopen(state_path, "w");
    for (int i = 0; f && i < n_items && i < SLOTS; i++)
        fprintf(f, "%s\t%s\t%s\t%d\t%s\t%s\n", items[i].bus, items[i].path,
                items[i].menu[0] ? items[i].menu : "/", items[i].is_menu, items[i].glyph, items[i].title);
    if (f) fclose(f);

    for (int i = 0; i < SLOTS; i++) {
        int on = i < n_items;
        printf("tray%d|string|%s\ntray%d_on|bool|%s\n", i + 1, on ? items[i].glyph : "",
               i + 1, on ? "true" : "false");
    }
    printf("\n");
    fflush(stdout);
}

static int find(const char *b, const char *p) {
    for (int i = 0; i < n_items; i++)
        if (!strcmp(items[i].bus, b) && (!p || !strcmp(items[i].path, p)))
            return i;
    return -1;
}

static void add_item(const char *b, const char *p) {
    char id[128], icon[128], title[128];
    get_str(b, p, "Id", id, sizeof id);
    get_str(b, p, "IconName", icon, sizeof icon);
    get_str(b, p, "Title", title, sizeof title);
    if (!id[0] && !icon[0] && !title[0])
        return;  // não respondeu: não é um item válido

    int i = find(b, p);
    if (i < 0) {
        if (n_items == MAX_ITEMS) return;
        i = n_items++;
    }
    struct item *it = &items[i];
    snprintf(it->bus, sizeof it->bus, "%s", b);
    snprintf(it->path, sizeof it->path, "%s", p);
    get_obj(b, p, "Menu", it->menu, sizeof it->menu);
    it->is_menu = 0;
    sd_bus_get_property_trivial(bus, b, p, ITEM_IFACE, "ItemIsMenu", NULL, 'b', &it->is_menu);

    char key[400];
    snprintf(key, sizeof key, "%s %s %s", id, icon, title);
    it->glyph = default_glyph;
    snprintf(it->title, sizeof it->title, "%s", title[0] ? title : id);
    for (size_t g = 0; g < sizeof glyphs / sizeof *glyphs; g++)
        if (strcasestr(key, glyphs[g].key)) {
            it->glyph = glyphs[g].glyph;
            if (!title[0]) snprintf(it->title, sizeof it->title, "%s", glyphs[g].name);
            break;
        }

    snprintf(key, sizeof key, "%.127s%.255s", b, p);
    sd_bus_emit_signal(bus, "/StatusNotifierWatcher", WATCHER, "StatusNotifierItemRegistered", "s", key);
    emit();
}

// ── Watcher (D-Bus) ─────────────────────────────────────────────────────────
static int register_item(sd_bus_message *m, void *u, sd_bus_error *e) {
    (void)u; (void)e;
    const char *arg;
    if (sd_bus_message_read(m, "s", &arg) < 0) return -EINVAL;
    const char *sender = sd_bus_message_get_sender(m);
    char b[128], p[256];
    if (arg[0] == '/') {  // Electron/ayatana: registra só o caminho
        snprintf(b, sizeof b, "%s", sender);
        snprintf(p, sizeof p, "%s", arg);
    } else {
        snprintf(b, sizeof b, "%s", arg);
        snprintf(p, sizeof p, "/StatusNotifierItem");
    }
    sd_bus_reply_method_return(m, "");  // responde antes de consultar o app
    add_item(b, p);
    return 1;
}

static int register_host(sd_bus_message *m, void *u, sd_bus_error *e) {
    (void)u; (void)e;
    return sd_bus_reply_method_return(m, "");
}

static int prop_items(sd_bus *b, const char *path, const char *iface, const char *prop,
                      sd_bus_message *reply, void *u, sd_bus_error *e) {
    (void)b; (void)path; (void)iface; (void)prop; (void)u; (void)e;
    char key[400];
    sd_bus_message_open_container(reply, 'a', "s");
    for (int i = 0; i < n_items; i++) {
        snprintf(key, sizeof key, "%.127s%.255s", items[i].bus, items[i].path);
        sd_bus_message_append(reply, "s", key);
    }
    return sd_bus_message_close_container(reply);
}

static int prop_true(sd_bus *b, const char *path, const char *iface, const char *prop,
                     sd_bus_message *reply, void *u, sd_bus_error *e) {
    (void)b; (void)path; (void)iface; (void)prop; (void)u; (void)e;
    return sd_bus_message_append(reply, "b", 1);
}

static int prop_version(sd_bus *b, const char *path, const char *iface, const char *prop,
                        sd_bus_message *reply, void *u, sd_bus_error *e) {
    (void)b; (void)path; (void)iface; (void)prop; (void)u; (void)e;
    return sd_bus_message_append(reply, "i", 0);
}

static const sd_bus_vtable watcher_vtable[] = {
    SD_BUS_VTABLE_START(0),
    SD_BUS_METHOD("RegisterStatusNotifierItem", "s", "", register_item, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_METHOD("RegisterStatusNotifierHost", "s", "", register_host, SD_BUS_VTABLE_UNPRIVILEGED),
    SD_BUS_PROPERTY("RegisteredStatusNotifierItems", "as", prop_items, 0, SD_BUS_VTABLE_PROPERTY_EMITS_CHANGE),
    SD_BUS_PROPERTY("IsStatusNotifierHostRegistered", "b", prop_true, 0, SD_BUS_VTABLE_PROPERTY_CONST),
    SD_BUS_PROPERTY("ProtocolVersion", "i", prop_version, 0, SD_BUS_VTABLE_PROPERTY_CONST),
    SD_BUS_SIGNAL("StatusNotifierItemRegistered", "s", 0),
    SD_BUS_SIGNAL("StatusNotifierItemUnregistered", "s", 0),
    SD_BUS_SIGNAL("StatusNotifierHostRegistered", "", 0),
    SD_BUS_VTABLE_END
};

// ── Sinais ──────────────────────────────────────────────────────────────────
static int on_owner_changed(sd_bus_message *m, void *u, sd_bus_error *e) {  // app fechou
    (void)u; (void)e;
    const char *name, *old, *new;
    if (sd_bus_message_read(m, "sss", &name, &old, &new) < 0 || new[0]) return 0;
    int removed = 0, i;
    while ((i = find(name, NULL)) >= 0) {
        char key[400];
        snprintf(key, sizeof key, "%.127s%.255s", items[i].bus, items[i].path);
        sd_bus_emit_signal(bus, "/StatusNotifierWatcher", WATCHER, "StatusNotifierItemUnregistered", "s", key);
        memmove(&items[i], &items[i + 1], (size_t)(n_items - i - 1) * sizeof *items);
        n_items--;
        removed = 1;
    }
    if (removed) emit();
    return 0;
}

static int on_item_signal(sd_bus_message *m, void *u, sd_bus_error *e) {  // ícone/título mudou
    (void)u; (void)e;
    const char *sender = sd_bus_message_get_sender(m), *path = sd_bus_message_get_path(m);
    if (sender && path && find(sender, path) >= 0) add_item(sender, path);
    return 0;
}

int main(void) {
    const char *rt = getenv("XDG_RUNTIME_DIR");
    snprintf(state_path, sizeof state_path, "%s/ash-tray", rt ? rt : "/tmp");

    if (sd_bus_open_user(&bus) < 0) { fprintf(stderr, "ash-tray: sem D-Bus de sessão\n"); return 1; }
    sd_bus_set_method_call_timeout(bus, 1000 * 1000);  // 1s: app travado não trava a barra

    sd_bus_add_object_vtable(bus, NULL, "/StatusNotifierWatcher", WATCHER, watcher_vtable, NULL);
    if (sd_bus_request_name(bus, WATCHER, SD_BUS_NAME_REPLACE_EXISTING | SD_BUS_NAME_ALLOW_REPLACEMENT) < 0) {
        fprintf(stderr, "ash-tray: não consegui registrar %s\n", WATCHER);
        return 1;
    }
    sd_bus_match_signal(bus, NULL, "org.freedesktop.DBus", "/org/freedesktop/DBus",
                        "org.freedesktop.DBus", "NameOwnerChanged", on_owner_changed, NULL);
    sd_bus_match_signal(bus, NULL, NULL, NULL, ITEM_IFACE, NULL, on_item_signal, NULL);
    sd_bus_emit_signal(bus, "/StatusNotifierWatcher", WATCHER, "StatusNotifierHostRegistered", "");
    emit();

    for (;;) {
        int r = sd_bus_process(bus, NULL);
        if (r < 0) break;
        if (r > 0) continue;
        if (sd_bus_wait(bus, UINT64_MAX) < 0) break;
    }
    sd_bus_unref(bus);
    return 0;
}
