// nvoc — overclock da GPU NVIDIA via NVML (funciona no Wayland, sem nvidia-settings).
//   nvoc                 mostra os offsets atuais e as faixas permitidas
//   nvoc <core> <mem>    define os offsets em MHz (precisa de root)
// Carrega a libnvidia-ml em tempo de execução: não precisa do CUDA/nvml.h para compilar.
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

typedef void *nvmlDevice_t;
typedef int (*fn_void)(void);
typedef int (*fn_handle)(unsigned, nvmlDevice_t *);
typedef int (*fn_get)(nvmlDevice_t, int *);
typedef int (*fn_range)(nvmlDevice_t, int *, int *);
typedef int (*fn_set)(nvmlDevice_t, int);

#define LOAD(type, name) type name = (type)dlsym(lib, #name); if (!name) return fail(#name)

static int fail(const char *what) {
    fprintf(stderr, "nvoc: %s indisponível\n", what);
    return 1;
}

int main(int argc, char **argv) {
    void *lib = dlopen("libnvidia-ml.so.1", RTLD_NOW);
    if (!lib) return fail("libnvidia-ml.so.1");

    LOAD(fn_void, nvmlInit_v2);
    LOAD(fn_handle, nvmlDeviceGetHandleByIndex_v2);
    LOAD(fn_get, nvmlDeviceGetGpcClkVfOffset);
    LOAD(fn_get, nvmlDeviceGetMemClkVfOffset);
    LOAD(fn_range, nvmlDeviceGetGpcClkMinMaxVfOffset);
    LOAD(fn_range, nvmlDeviceGetMemClkMinMaxVfOffset);
    LOAD(fn_set, nvmlDeviceSetGpcClkVfOffset);
    LOAD(fn_set, nvmlDeviceSetMemClkVfOffset);

    nvmlDevice_t dev;
    if (nvmlInit_v2() || nvmlDeviceGetHandleByIndex_v2(0, &dev)) return fail("GPU 0");

    if (argc == 3) {
        int rc = nvmlDeviceSetGpcClkVfOffset(dev, atoi(argv[1]));
        int rm = nvmlDeviceSetMemClkVfOffset(dev, atoi(argv[2]));
        if (rc || rm) {
            fprintf(stderr, "nvoc: erro NVML core=%d mem=%d (root?)\n", rc, rm);
            return 1;
        }
    } else if (argc != 1) {
        fprintf(stderr, "uso: nvoc [<core MHz> <mem MHz>]\n");
        return 2;
    }

    int core, mem, cmin, cmax, mmin, mmax;
    nvmlDeviceGetGpcClkVfOffset(dev, &core);
    nvmlDeviceGetMemClkVfOffset(dev, &mem);
    nvmlDeviceGetGpcClkMinMaxVfOffset(dev, &cmin, &cmax);
    nvmlDeviceGetMemClkMinMaxVfOffset(dev, &mmin, &mmax);
    printf("core %+d MHz (%d..%d) · mem %+d MHz (%d..%d)\n", core, cmin, cmax, mem, mmin, mmax);
    return 0;
}
