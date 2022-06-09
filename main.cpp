#ifdef PLATFORM_IS_WINDOWS
#include <windows.h>
#endif

#include "wx_app.hpp"

IMPLEMENT_APP_NO_MAIN(SerialTrayApp);
IMPLEMENT_WX_THEME_SUPPORT;

int main(int argc, char ** argv)
{
    wxEntryStart(argc, argv);
    wxTheApp->CallOnInit();
    return wxTheApp->OnRun();
}
