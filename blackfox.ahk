;Environment Controls
;///////////////////////////////////////////////////////////////////////////////////////////
#Requires AutoHotkey v2.0
#SingleInstance Force
#Include Lib\WebViewToo.ahk
Gui.ProtoType.AddWebViewCtrl := WebViewCtrl
;///////////////////////////////////////////////////////////////////////////////////////////

;Main Script - Configuración de Archivos
;///////////////////////////////////////////////////////////////////////////////////////////
if !DirExist(A_ScriptDir "\webData")
    DirCreate(A_ScriptDir "\webData")

DllName := "WebView2Loader.dll"
DllPath := FileExist(A_ScriptDir "\" DllName) ? A_ScriptDir "\" DllName 
         : "Lib\" (A_PtrSize * 8) "bit\" DllName

if !FileExist(DllPath) {
    MsgBox("Falta el archivo: " DllName "`n`nPor favor, coloca la DLL junto al ejecutable.", "Error", 16)
    ExitApp()
}

WebViewSettings := {
    DataDir: A_ScriptDir "\webData", 
    DllPath: DllPath
}

; Creación de la Interfaz
;///////////////////////////////////////////////////////////////////////////////////////////
MyGui := Gui("-Caption +Resize")
DllCall("dwmapi\DwmSetWindowAttribute", "ptr", MyGui.Hwnd, "uint", 33, "int*", 1, "uint", 4)

MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.OnEvent("Size", (g, m, w, h) => GuiSize(g, m, w, h))

MyGui.MarginX := 3 

; --- CONTROLES SUPERIORES ---
MyGui.SetFont("s9 cGray", "Segoe UI")
MyGui.AddText("xm ym+3 vLabelUrl", "Url:")
MyGui.SetFont("s9 cDefault", "Segoe UI")
MyGui.AddEdit("x+5 yp-3 w645 vUrlEdit", "https://obsesseddesigns.com")
MyGui.AddButton("x+5 vNavigateButton Default", "Go").OnEvent("Click", (*) => NavToUrl())

; WebView
WV := MyGui.AddWebViewCtrl("xm w1280 h720 vWVToo", WebViewSettings)

; --- LABELS E ICONOS INFERIORES ---
MyGui.SetFont("s9 cGray", "Segoe UI") 
OnTopBtn   := MyGui.AddText("vOnTopBtn", "on Top")
OnTopBtn.OnEvent("Click", ToggleOnTop)

HideBarBtn := MyGui.AddText("x+15 vHideBarBtn", "Hide address bar")
HideBarBtn.OnEvent("Click", ToggleAddressBar)

; Grupo de Iconos (Derecha)
MyGui.SetFont("s10 cGray", "Segoe Fluent Icons") 
RestoreBtn := MyGui.AddText("vRestoreBtn", Chr(0xE923)) 
RestoreBtn.OnEvent("Click", (*) => MyGui.Restore())

MaxBtn     := MyGui.AddText("vMaxBtn", Chr(0xE739)) 
MaxBtn.OnEvent("Click", (*) => MyGui.Maximize())

CloseBtn   := MyGui.AddText("vCloseBtn", Chr(0xE8BB)) ; Icono X (Cerrar)
CloseBtn.OnEvent("Click", (*) => ExitApp())

MyGui.Show()
WV.Navigate("https://obsesseddesigns.com")

; --- FUNCIONES ---

ToggleOnTop(GuiCtrlObj, *) {
    if (GuiCtrlObj.Text = "on Top") {
        MyGui.Opt("+AlwaysOnTop"), GuiCtrlObj.Text := "off Top"
    } else {
        MyGui.Opt("-AlwaysOnTop"), GuiCtrlObj.Text := "on Top"
    }
}

ToggleAddressBar(GuiCtrlObj, *) {
    IsVisible := MyGui["UrlEdit"].Visible
    MyGui["LabelUrl"].Visible := !IsVisible
    MyGui["UrlEdit"].Visible := !IsVisible
    MyGui["NavigateButton"].Visible := !IsVisible
    GuiCtrlObj.Text := IsVisible ? "Show address bar" : "Hide address bar"
    
    MyGui.GetClientPos(,, &W, &H)
    GuiSize(MyGui, 0, W, H)
}

GuiSize(GuiObj, WindowState, Width, Height) {
    if (WindowState = -1)
        return
        
    OffsetTop := GuiObj["UrlEdit"].Visible ? 40 : 2
    NuevoAncho := Width - 6
    NuevoAlto := Height - OffsetTop - 25 
    
    try {
        if GuiObj["UrlEdit"].Visible {
            GuiObj["UrlEdit"].Move(,, Width - 100)
            GuiObj["NavigateButton"].Move(Width - 45)
        }
        GuiObj["WVToo"].Move(3, OffsetTop, NuevoAncho, NuevoAlto)
        
        ; Posicionar Labels Inferiores
        YPos := Height - 20
        GuiObj["OnTopBtn"].Move(10, YPos)
        GuiObj["HideBarBtn"].Move(65, YPos)
        
        ; Posicionar Iconos a la derecha (Orden: Restaurar, Max, Cerrar)
        GuiObj["CloseBtn"].Move(Width - 25, YPos)
        GuiObj["MaxBtn"].Move(Width - 55, YPos)
        GuiObj["RestoreBtn"].Move(Width - 85, YPos)
    }
}

NavToUrl(Suffix := "") {
    DestUrl := MyGui["UrlEdit"].Value Suffix
    if !(DestUrl ~= "^(?i)https?://") 
        DestUrl := "https://" . DestUrl
    MyGui["WVToo"].Navigate(DestUrl)
    MyGui["UrlEdit"].Value := DestUrl
}

; --- GESTIÓN DE RATÓN ---

OnMessage(0x0200, WM_MOUSEMOVE)
OnMessage(0x0201, WM_LBUTTONDOWN)

WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
    static HoveredCtrl := 0
    currCtrl := GuiCtrlFromHwnd(hwnd)
    
    btnNames := "OnTopBtn,MaxBtn,RestoreBtn,HideBarBtn,CloseBtn"
    
    if (currCtrl && InStr(btnNames, currCtrl.Name)) {
        if (HoveredCtrl != currCtrl) {
            if (HoveredCtrl)
                HoveredCtrl.SetFont("cGray")
            currCtrl.SetFont("cBlack")
            HoveredCtrl := currCtrl
        }
        return
    }
    
    if (HoveredCtrl) {
        HoveredCtrl.SetFont("cGray")
        HoveredCtrl := 0
    }
}

WM_LBUTTONDOWN(*) {
    if (WinGetMinMax(MyGui.Hwnd) != 1)
        PostMessage(0xA1, 2,,, "A")
}

; --- HOTKEYS ---
#HotIf WinActive(MyGui.Hwnd) && (MyGui.FocusedCtrl = MyGui["UrlEdit"])
Enter::NavToUrl()
^Enter::NavToUrl(".com")
!Enter::NavToUrl(".net")
#HotIf