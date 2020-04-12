#include "windows.h"
LPCTSTR windowClassName = L"popupshadow";
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow)
{
    for (;;){
        HWND h = FindWindowEx(NULL, NULL, windowClassName, NULL);
        if (h != NULL) {
            ShowWindow(h, SW_HIDE);
        }
        Sleep(3000);
    }
    return 0;
}