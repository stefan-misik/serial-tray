define TEMPLATE_ICONS_INC_01

#include <cstddef>
#include <utility>

namespace boottool
{
namespace icons
{


endef

define TEMPLATE_ICONS_INC_02

}  // namespace icons


namespace
{

const std::pair<const unsigned char *, std::size_t> icon_list[] =
{
endef

define TEMPLATE_ICONS_INC_03
};

}  // namespace
}  // namespace boottool
endef

COMMA =,#

icons.inc: icons.inc.mk Makefile
	$(file >  $@,$(TEMPLATE_ICONS_INC_01))
	$(foreach PNG,$(PNG),$(file >> $@,// File $(PNG))$(file >> $@,$(shell $(XXD) -i $(PNG))))
	$(file >> $@,$(TEMPLATE_ICONS_INC_02))
	$(foreach PNG,$(PNG),$(file >> $@,    {icons::png_$(call png_to_id,$(PNG))_png, icons::png_$(call png_to_id,$(PNG))_png_len}$(COMMA)))
	$(file >> $@,$(TEMPLATE_ICONS_INC_03))