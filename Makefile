# ----------------------------------------------------- #
# Makefile for the CTF game module for Quake II         #
#                                                       #
# Just type "make" to compile the                       #
#  - CTF Game (game.so)                                 #
#                                                       #
# Dependencies:                                         #
# - None, but you need a Quake II to play.              #
#   While in theorie every one should work              #
#   Yamagi Quake II ist recommended.                    #
#                                                       #
# Platforms:                                            #
# - Linux                                               #
# - FreeBSD                                             #
# ----------------------------------------------------- #

# Check the OS type
OSTYPE := $(shell uname -s)

# Some plattforms call it "amd64" and some "x86_64"
ARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/amd64/x86_64/)

# Refuse all other plattforms as a firewall against PEBKAC
# (You'll need some #ifdef for your unsupported  plattform!)
ifneq ($(ARCH),i386)
ifneq ($(ARCH),x86_64)
$(error arch $(ARCH) is currently not supported)
endif
endif

# ----------

# The compiler
CC := gcc

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
CFLAGS := -O2 -fno-strict-aliasing -fomit-frame-pointer \
		  -fPIC -Wall -pipe -g -MMD

# ----------

# Base LDFLAGS.
LDFLAGS := -shared

# ----------

# Builds everything
all: ctf

# ----------

# Cleanup
clean:
	@echo "===> CLEAN"
	@rm -Rf build release

# ----------

# The ctf game
ctf:
	@echo '===> Building game.so'
	@mkdir -p release/
	$(MAKE) release/game.so

build/%.o: %.c
	@echo '===> CC $<'
	@mkdir -p $(@D)
	@$(CC) -c $(CFLAGS) -o $@ $<

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
	src/m_move.o \
	src/p_client.o \
	src/p_hud.o \
	src/p_menu.o \
	src/p_trail.o \
	src/p_view.o \
	src/p_weapon.o \
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

release/game.so : $(CTF_OBJS)
	@echo '===> LD $@'
	@$(CC) $(LDFLAGS) -o $@ $(CTF_OBJS)

# ----------
