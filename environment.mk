# Embedded tools common build definitions
# Author: Stefan Misik (stefan.misik@tescan.com)

################################################################################
# Check the make features
################################################################################

define check_feature
$(if $(findstring $(1),$(.FEATURES)),,$(error Make feature '$(1)' is \
required. Please update your version of Make tool.))
endef
$(call check_feature,order-only)
$(call check_feature,second-expansion)
$(call check_feature,target-specific)

################################################################################
# Testing-internal variables
################################################################################

# Build Environment type
ifeq ($(OS),Windows_NT)
    ifeq ($(strip $(findstring Windows32,$(shell $(MAKE) -v)) \
            $(findstring msys,$(shell $(MAKE) -v))),)
        ifeq ($(shell uname -o),Cygwin)
            BUILDENV ?= cygwin
        else
            BUILDENV ?= unknown
        endif
    else
        BUILDENV ?= windows
    endif
else
    BUILDENV ?= unknown
endif

ifneq ($(findstring windows,$(BUILDENV)),)
CMD_PREFIX =
PATHSEP = \\
else
CMD_PREFIX = ./
PATHSEP = /
endif

ifneq ($(findstring windows,$(BUILDENV))$(findstring cygwin,$(BUILDENV)),)
OUT_EXT    = .exe
else
OUT_EXT    = .out
endif

# Name of the directory used as substitute inside build directory for '..'
PARENT_DIR = __

