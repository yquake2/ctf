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

# On Windows / MinGW $(CC) is undefined by default.
ifeq ($(OSTYPE),Windows)
CC := gcc
endif

# Detect the compiler
ifeq ($(shell $(CC) -v 2>&1 | grep -c "clang version"), 1)
COMPILER := clang
COMPILERVER := $(shell $(CC)  -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$$/&00/')
else ifeq ($(shell $(CC) -v 2>&1 | grep -c -E "(gcc version|gcc-Version)"), 1)
COMPILER := gcc
COMPILERVER := $(shell $(CC)  -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$$/&00/')
else
COMPILER := unknown
endif

# ----------

# Base CFLAGS. These may be overridden by the environment.
# Highest supported optimizations are -O2, higher levels
# will likely break things.
ifdef DEBUG
CFLAGS ?= -O0 -g -Wall -pipe
else
CFLAGS ?= -O2 -Wall -pipe -fomit-frame-pointer
endif

# Always needed are:
#  -fno-strict-aliasing since the source doesn't comply
#   with strict aliasing rules and it's next to impossible
#   to get it there...
#  -fwrapv for defined integer wrapping. MSVC6 did this
#   and the game code requires it.
CFLAGS += -fno-strict-aliasing -fwrapv

# -MMD to generate header dependencies. Unsupported by
#  the Clang shipped with OS X.
ifneq ($(OSTYPE), Darwin)
CFLAGS += -MMD
endif

ifeq ($(OSTYPE), Darwin)
CFLAGS += -arch x86_64
endif

# ----------

# Switch of some annoying warnings.
ifeq ($(COMPILER), clang)
	# -Wno-missing-braces because otherwise clang complains
	#  about totally valid 'vec3_t bla = {0}' constructs.
	CFLAGS += -Wno-missing-braces
else ifeq ($(COMPILER), gcc)
	# GCC 8.0 or higher.
	ifeq ($(shell test $(COMPILERVER) -ge 80000; echo $$?),0)
	    # -Wno-format-truncation and -Wno-format-overflow
		# because GCC spams about 50 false positives.
    	CFLAGS += -Wno-format-truncation -Wno-format-overflow
	endif
endif

# ----------

# Base LDFLAGS, none by default.
LDFLAGS ?=

# Required LDFLAGS to build a game module.
ifeq ($(OSTYPE), Darwin)
LDFLAGS += -shared -arch x86_64
else ifeq ($(OSTYPE), Windows)
LDFLAGS += -shared -static-libgcc
else
LDFLAGS += -shared -lm
endif

# ----------

# https://reproducible-builds.org/specs/source-date-epoch/
ifdef SOURCE_DATE_EPOCH
CFLAGS += -DBUILD_DATE=\"$(shell date --utc --date="@${SOURCE_DATE_EPOCH}" +"%b %_d %Y" | sed -e 's/ /\\ /g')\"
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
else ifeq ($(OSTYPE), Darwin)
ctf:
	@echo "===> Building game.dylib"
	${Q}mkdir -p release
	$(MAKE) release/game.dylib
else
ctf:
	@echo "===> Building game.so"
	$(Q)mkdir -p release
	$(MAKE) release/game.so

release/game.so : CFLAGS += -fPIC
endif
 
build/%.o: %.c
	@echo "===> CC $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) -c $(CFLAGS) -o $@ $<

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
	$(Q)$(CC) -o $@ $(CTF_OBJS) $(LDFLAGS)
else ifeq ($(OSTYPE), Darwin)
release/game.dylib : $(CTF_OBJS)
	@echo "===> LD $@"
	${Q}$(CC) -o $@ $(CTF_OBJS) $(LDFLAGS)
else
release/game.so : $(CTF_OBJS)
	@echo "===> LD $@"
	$(Q)$(CC) -o $@ $(CTF_OBJS) $(LDFLAGS)
endif
 
# ----------
