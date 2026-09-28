# Ferramentas em C das dots.  make && make install
CFLAGS  ?= -O2 -march=native -pipe
CFLAGS  += -std=gnu11 -Wall -Wextra
BINDIR  ?= $(HOME)/.local/bin
SBINDIR ?= /usr/local/bin

all: ash-tray nvoc mouse-hz

ash-tray: ash-tray.c
	$(CC) $(CFLAGS) -o $@ $< $(shell pkg-config --cflags --libs libsystemd)

nvoc: nvoc.c
	$(CC) $(CFLAGS) -o $@ $< -ldl

mouse-hz: mouse-hz.c
	$(CC) $(CFLAGS) -o $@ $<

# ash-tray e mouse-hz no usuário; nvoc no sistema (usado pelo ash-turbo como root)
install: all
	install -Dm755 ash-tray mouse-hz -t $(BINDIR)
	sudo install -Dm755 nvoc -t $(SBINDIR)

clean:
	rm -f ash-tray nvoc mouse-hz

.PHONY: all install clean
