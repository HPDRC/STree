#include <windows.h>
#include <imagehlp.h>
#include <tlhelp32.h>
#include <vcl.h>
#pragma hdrstop
USERES("calldemo.res");
USEFORM("mainform.cpp", Form1);
USEUNIT("callstack.cpp");
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TForm1), &Form1);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
