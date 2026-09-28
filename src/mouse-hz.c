// mouse-hz — mede a taxa de polling real do mouse.
// Uso: sudo mouse-hz   (mexa o mouse em círculos rápidos por ~5s)
#include <dirent.h>
#include <fcntl.h>
#include <linux/input.h>
#include <sys/ioctl.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <time.h>
#include <unistd.h>

#define MAX_DEVS   32
#define MAX_EVENTS 200000
#define BITS(n)    ((n) / (8 * sizeof(long)) + 1)

struct dev {
    char name[128];
    double *stamps;
    int n, moved;
};

static int cmp(const void *a, const void *b) {
    double x = *(const double *)a, y = *(const double *)b;
    return (x > y) - (x < y);
}

static double now(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

int main(void) {
    struct pollfd fds[MAX_DEVS];
    struct dev devs[MAX_DEVS];
    int n = 0;

    DIR *d = opendir("/dev/input");
    for (struct dirent *e; d && (e = readdir(d)) && n < MAX_DEVS;) {
        if (strncmp(e->d_name, "event", 5)) continue;
        char path[300];
        snprintf(path, sizeof path, "/dev/input/%s", e->d_name);
        int fd = open(path, O_RDONLY | O_NONBLOCK);
        if (fd < 0) continue;

        unsigned long rel[BITS(REL_MAX)] = {0};
        char name[128] = "?";
        ioctl(fd, EVIOCGBIT(EV_REL, sizeof rel), rel);
        ioctl(fd, EVIOCGNAME(sizeof name), name);
        int has_xy = (rel[0] & (1UL << REL_X)) && (rel[0] & (1UL << REL_Y));
        if (!has_xy || strcasestr(name, "touchpad")) { close(fd); continue; }

        fds[n] = (struct pollfd){ .fd = fd, .events = POLLIN };
        devs[n] = (struct dev){ .stamps = malloc(MAX_EVENTS * sizeof(double)) };
        snprintf(devs[n].name, sizeof devs[n].name, "%s", name);
        n++;
    }
    if (d) closedir(d);
    if (!n) { fprintf(stderr, "nenhum mouse encontrado (rode com sudo)\n"); return 1; }

    puts("Mexa o mouse em círculos rápidos por ~5s...");
    for (double end = now() + 6; now() < end;) {
        if (poll(fds, n, 500) <= 0) continue;
        for (int i = 0; i < n; i++) {
            struct input_event ev[64];
            ssize_t r;
            while ((r = read(fds[i].fd, ev, sizeof ev)) > 0)
                for (size_t k = 0; k < r / sizeof *ev; k++) {
                    if (ev[k].type == EV_REL) devs[i].moved = 1;
                    else if (ev[k].type == EV_SYN && ev[k].code == SYN_REPORT && devs[i].moved) {
                        if (devs[i].n < MAX_EVENTS)
                            devs[i].stamps[devs[i].n++] = ev[k].input_event_sec + ev[k].input_event_usec / 1e6;
                        devs[i].moved = 0;
                    }
                }
        }
    }

    for (int i = 0; i < n; i++) {
        struct dev *v = &devs[i];
        if (v->n < 200) continue;
        int m = 0;
        for (int k = 1; k < v->n; k++) {  // ignora pausas (> 5 ms) entre movimentos
            double dt = v->stamps[k] - v->stamps[k - 1];
            if (dt > 0 && dt < 0.005) v->stamps[m++] = dt;
        }
        if (!m) continue;
        qsort(v->stamps, m, sizeof(double), cmp);
        printf("%s: mediana %.0f Hz | pico ~%.0f Hz (%d eventos)\n",
               v->name, 1 / v->stamps[m / 2], 1 / v->stamps[m / 10], v->n);
    }
    return 0;
}
