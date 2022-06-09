# ImageMagic convert command
CONVERT = convert
XXD = xxd


################################################################################
PNG ?=
ICO ?=
## Define icon and its individual resolutions
define deficon
$(eval PNG_$(basename $(1)) = $(addprefix png/,$(addsuffix .png,$(addprefix \
$(basename $(1)).,$(2)))))
$(eval PNG += $(PNG_$(basename $(1))))
$(eval ICO += $(addprefix ico/,$(1:.svg=.ico)))
endef

## Make ID from the PNG name
define png_to_id
$(subst .,_,$(basename $(notdir $(1))))
endef
################################################################################

SRC_DIR = src

$(call deficon,serial-tray.svg,16 24 32 48 64 96 128 256 512)


################################################################################
## Get the size from PNG name(s)
# $(1) List of PNGs whose size is to be obtained
define getsize
$(subst .,,$(suffix $(basename $(1))))
endef

## Get SVG name from PNG name(s)
# $(1) Listo of PNGs whose repective source SVGs are to be obtained
define getsvg
$(addprefix $(SRC_DIR)/,$(addsuffix .svg,$(basename $(basename $(1)))))
endef
################################################################################

ifeq (yes,$(strip $(WITH_GUI)))
all: $(PNG) $(ICO) icons.hpp icons.inc
else
all: $(PNG) $(ICO)
endif

.PHONY: all

# Enable second expansion
.SECONDEXPANSION:

ico/%.ico: $$(PNG_%)
	$(CONVERT) $^ $@
	
png/%.png: $$(call getsvg,%.png)
	$(CONVERT) -background transparent \
	-size $(call getsize, $@)x$(call getsize, $@) $< $@

clean:
	$(RM) $(ICO) $(PNG) icons.hpp icons.inc

.PHONY: clean

include icons.hpp.mk icons.inc.mk
