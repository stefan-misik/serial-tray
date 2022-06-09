include environment.mk

WXCONF = wx-config-3.1

# Platform to build for (windows or posix)
PLATFORM ?= windows

SRC =  \
	wx_app.cpp  \
    main.cpp

ifeq (windows,$(strip $(PLATFORM)))
SRC += windows.rc
endif

CXXFLAGS = -std=c++17 -Wall
CFLAGS = -Wall
CPPFLAGS =
INCLUDE = .
DEFINE =
LDLIBS =

# Platform-specific configuration
ifeq ($(strip $(PLATFORM)),windows)
LDFLAGS += -static
WXCFLAGS += --static=yes
LDLIBS += -lws2_32 -lmswsock
TOOLCHAIN_PREFIX = x86_64-w64-mingw32
OUT_EXT = .exe
DEFINE += PLATFORM_IS_WINDOWS
else ifeq ($(strip $(PLATFORM)),macos)
WXCONF = wx-config
TOOLCHAIN_PREFIX =
OUT_EXT =
else
WXCONF = wx-config-gtk3
TOOLCHAIN_PREFIX =
OUT_EXT =
endif

# Debug configuration
ifeq ($(strip $(DBG)),yes)
CPPFLAGS += -D_DEBUG -DDEBUG
CXXFLAGS += -O0 -ggdb
CFLAGS += -O0 -ggdb
BUILDDIR = build/$(PLATFORM)/debug
else
CXXFLAGS += -O2
CFLAGS += -O2
BUILDDIR = build/$(PLATFORM)/release
endif

# Binary path
OUT = $(BUILDDIR)/serial-tray$(OUT_EXT)

# GUI definitions
include $(BUILDDIR)/wx.mk
CPPFLAGS += $(WX_CPPFLAGS)
CXXFLAGS += $(WX_CXXFLAGS)
LDLIBS   += $(WX_LIBS)
# Override the wxWidgwets settings to start in a console on Windows
ifeq ($(strip $(PLATFORM)),windows)
LDLIBS += -mconsole -Wl,--subsystem,console
endif

# Project-specific rules
all: pre-build $(OUT) post-build

clean:
	$(RM) -r build

.PHONY: all clean pre-build post-build

strip: $(OUT)
	$(STRIP) $<

.PHONY: strip

$(BUILDDIR)/wx.mk: | $(BUILDDIR)
	$(file > $@,WX_CPPFLAGS = $(shell $(WXCONF) $(WXCFLAGS) --cppflags))
	$(file >> $@,WX_CXXFLAGS = $(shell $(WXCONF) $(WXCFLAGS) --cxxflags))
	$(file >> $@,WX_LIBS = $(shell $(WXCONF) $(WXCFLAGS) --libs std))
	
pre-build: make_icons

make_icons:
	$(MAKE) -C icons WITH_GUI=$(WITH_GUI)

.PHONY: make_icons

include rules.mk

