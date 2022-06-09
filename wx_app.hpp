#ifndef WX_APP_HPP_
#define WX_APP_HPP_

#include <wx/wxprec.h>
#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif


class SerialTrayApp: public wxApp
{
public:
    virtual bool OnInit();

    SerialTrayApp();
    ~SerialTrayApp();

private:
};

#endif  // WX_APP_HPP_

