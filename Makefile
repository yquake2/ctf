# ----------------------------------------------------- #
# Makefile for the CTF game module for Quake II         #
#                                                       #
# Just type "make" to compile the                       #
#  - CTF Game (game.so / game.dll)                      #
#                                                       #
# Dependencies:                                         #
# - None, but you need a Quake II to play.              #
#   While in theorie every one should work              #
#   Yamagi Quake II ist recommended.                    #
#                                                       #
# Platforms:                                            #
# - FreeBSD                                             #
# - Linux                                               #
# - Mac OS X                                            #
# - OpenBSD                                             #
# - Windows                                             # 
# ----------------------------------------------------- #

# Detect the OS
ifdef SystemRoot
OSTYPE := Windows
else
OSTYPE := $(shell uname -s)
endif
 
# Special case for MinGW
ifneq (,$(findstring MINGW,$(OSTYPE)))
OSTYPE := Windows
endif

# ----------

# Base CFLAGS. 
#
# -O2 are enough optimizations.
# 
# -fno-strict-aliasing since the source doesn't comply
#  with strict aliasing rules and it's next to impossible
#  to get it there...
#
# -fomit-frame-pointer since the framepointer is mostly
#  useless for debugging Quake II and slows things down.
#
# -g to build allways with debug symbols. Please do not
#  change this, since it's our only chance to debug this
#  crap when random crashes happen!
#
# -fPIC for position independend code.
#
# -MMD to generate header dependencies.
ifeq ($(OSTYPE), Darwin)
CFLAGS := -O2 -fno-strict-aliasing -fomit-frame-pointer \
		  -Wall -pipe -g -fwrapv -arch i386 -arch x86_64
else
CFLAGS := -O2 -fno-strict-aliasing -fomit-frame-pointer \
		  -Wall -pipe -g -MMD -fwrapv
endif

# ----------

# Base LDFLAGS.
ifeq ($(OSTYPE), Darwin)
LDFLAGS := -shared -arch i386 -arch x86_64 
else
LDFLAGS := -shared
endif

# ----------

# Builds everything
all: ctf

# ----------
 
# When make is invoked by "make VERBOSE=1" print
# the compiler and linker commands.

ifdef VERBOSE
Q :=
else
Q := @
endif

# ----------

# Phony targets
.PHONY : all clean ctf

# ----------
 
# Cleanup
clean:
	@echo "===> CLEAN"
	${Q}rm -Rf build release
 
# ----------

# The ctf game
ifeq ($(OSTYPE), Windows)
ctf:
	@echo "===> Building game.dll"
	$(Q)mkdir -p release
	$(MAKE) release/game.dll

build/%.o: %.c
	@echo "===> CC $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) -c $(CFLAGS) -o $@ $<
else
ctf:
	@echo "===> Building game.so"
	$(Q)mkdir -p release
	$(MAKE) release/game.so

build/%.o: %.c
	@echo "===> CC $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) -c $(CFLAGS) -o $@ $<

release/game.so : CFLAGS += -fPIC
endif
 
# ----------

CTF_OBJS_ = \
	src/g_ai.o \
	src/g_chase.o \
	src/g_cmds.o \
	src/g_combat.o \
	src/g_ctf.o \
	src/g_func.o \
	src/g_items.o \
	src/g_main.o \
	src/g_misc.o \
	src/g_monster.o \
	src/g_phys.o \
	src/g_save.o \
	src/g_spawn.o \
	src/g_svcmds.o \
	src/g_target.o \
	src/g_trigger.o \
	src/g_utils.o \
	src/g_weapon.o \
	src/menu/menu.o \
	src/monster/move.o \
	src/player/client.o \
	src/player/hud.o \
	src/player/trail.o \
	src/player/view.o \
	src/player/weapon.o \
	src/shared/shared.o 

# ----------

# Rewrite pathes to our object directory
CTF_OBJS = $(patsubst %,build/%,$(CTF_OBJS_))

# ----------

# Generate header dependencies
CTF_DEPS= $(CTF_OBJS:.o=.d)

# ----------

# Suck header dependencies in
-include $(CTF_DEPS)

# ----------

ifeq ($(OSTYPE), Windows)
release/game.dll : $(CTF_OBJS)
	@echo "===> LD $@"
	$(Q)$(CC) $(LDFLAGS) -o $@ $(CTF_OBJS)
else
release/game.so : $(CTF_OBJS)
	@echo "===> LD $@"
	$(Q)$(CC) $(LDFLAGS) -o $@ $(CTF_OBJS)
endif
 
# ----------
