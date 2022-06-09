#include "wx_app.hpp"


bool SerialTrayApp::OnInit()
{
    if (!wxApp::OnInit())
        return false;

    return true;
}

SerialTrayApp::SerialTrayApp()
{
}

SerialTrayApp::~SerialTrayApp()
{
}
