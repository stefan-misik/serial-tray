define TEMPLATE_ICONS_HPP_01
#ifndef BOOTTOOL_ICONS_ICONS_HPP_
#define BOOTTOOL_ICONS_ICONS_HPP_

namespace boottool
{

enum class IconId
{
endef

# List of icons goes here

define TEMPLATE_ICONS_HPP_02
};

}  // namespace boottool

#endif  // BOOTTOOL_ICONS_ICONS_HPP_
endef

COMMA =,#

icons.hpp: icons.hpp.mk Makefile
	$(file >  $@,$(TEMPLATE_ICONS_HPP_01))
	$(foreach PNG,$(PNG),$(file >> $@,    $(call png_to_id,$(PNG))$(COMMA)))
	$(file >> $@,$(TEMPLATE_ICONS_HPP_02))