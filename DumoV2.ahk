#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir

; Path to your settings file
settingsFile := "settings.txt"

; ----------------------------
; Functions to manage settings
; ----------------------------

loadSettings(file) {
    global
    if !FileExist(file) {
        MsgBox "Settings file not found: " file, "Error", 16
        ExitApp
    }

    Loop Read, file
    {
        line := A_LoopReadLine
        if InStr(line, "=")
        {
            parts := StrSplit(line, "=")
            key := Trim(parts[1])
            val := Trim(parts[2])
            %key% := val
        }
    }
}

saveSetting(key, val, file) {
    newContent := ""
    found := false

    Loop Read, file
    {
        thisLine := A_LoopReadLine
        if (InStr(thisLine, key . "=") = 1) {
            newContent .= key . "=" . val . "`n"
            found := true
        } else {
            newContent .= thisLine . "`n"
        }
    }

    ; If key was not found, append it
    if (!found) {
        newContent .= key . "=" . val . "`n"
    }

    FileDelete file
    FileAppend newContent, file
}

; Load all settings into memory
loadSettings(settingsFile)

;======================================================================================
; Submenu for the menu and tray menu
;======================================================================================
mediakey4allchoose := Menu()
mediakey4allchoose.Add("Media_Key (default)", mk4acDefault)
mediakey4allchoose.Add("Media_Key (PotPlayer)", mk4acPotPlayer)
mediakey4allchoose.Add("Media_Key (Opera)", mk4acOpera)

if ((mdkystate == 0) && (ChoosePlayer == 00)){
    mediakey4allchoose.Check("Media_Key (default)")
    mediakey4allchoose.Uncheck("Media_Key (PotPlayer)")
    mediakey4allchoose.Uncheck("Media_Key (Opera)")
} else if ((mdkystate == 0) && (ChoosePlayer == 10)){
    mediakey4allchoose.Uncheck("Media_Key (default)")
    mediakey4allchoose.Check("Media_Key (PotPlayer)")
    mediakey4allchoose.Uncheck("Media_Key (Opera)")
} else if ((mdkystate == 0) && (ChoosePlayer == 11)){
    mediakey4allchoose.Uncheck("Media_Key (default)")
    mediakey4allchoose.Uncheck("Media_Key (PotPlayer)")
    mediakey4allchoose.Check("Media_Key (Opera)")
}

;---------------------------------------------------------------------------------------
sharexshotstate := Menu()
sharexshotstate.Add("ScrnShot - 1 || ReptShot - 2", Screenshot1orScreenshot2State1)
sharexshotstate.Add("ScrnShot - 2 || ReptShot - 1", Screenshot1orScreenshot2State0)
if (scrstate == 0){
    sharexshotstate.Uncheck("ScrnShot - 1 || ReptShot - 2")
    sharexshotstate.Check("ScrnShot - 2 || ReptShot - 1")
} else if(scrstate == 1) {
    sharexshotstate.Check("ScrnShot - 1 || ReptShot - 2")
    sharexshotstate.Uncheck("ScrnShot - 2 || ReptShot - 1")
}

;---------------------------------------------------------------------------------------
speedunrestate := Menu()
speedunrestate.Add("SpeedUp || SpeedDown", SpeedUpDownor_State)
speedunrestate.Add("Redo || Undo", UndoRedo_State)
if (spustate == 0){
    speedunrestate.Check("SpeedUp || SpeedDown")
    speedunrestate.Uncheck("Redo || Undo")
} else if (spustate == 1) {
    speedunrestate.Uncheck("SpeedUp || SpeedDown")
    speedunrestate.Check("Redo || Undo")
}

;---------------------------------------------------------------------------------------
copycutstate := Menu()
copycutstate.Add("Copy || Cut", copycutchoose)
copycutstate.Add("CopyLinkOneNote || Copy || Cut", copylinkcopycutchoose)
if (cpcstate == 0){
    copycutstate.Check("Copy || Cut")
    copycutstate.Uncheck("CopyLinkOneNote || Copy || Cut")
} else if (cpcstate == 1) {
    copycutstate.Uncheck("Copy || Cut")
    copycutstate.Check("CopyLinkOneNote || Copy || Cut")
}

;---------------------------------------------------------------------------------------
pastestate := Menu()
pastestate.Add("Paste", pasteon1press)
pastestate.Add("1. Paste || 2. Paste Plain OneNote", pasteon1presspasteplain2press)
if (pstpstplnste == 0){
    pastestate.Check("Paste")
    pastestate.Uncheck("1. Paste || 2. Paste Plain OneNote")
} else if (pstpstplnste == 1){
    pastestate.Uncheck("Paste")
    pastestate.Check("1. Paste || 2. Paste Plain OneNote")
}

;---------------------------------------------------------------------------------------
playpausestate := Menu()
playpausestate.Add("Play Pause 4 All", MediaPlay4AllorMediaPlay4NoxState0)
playpausestate.Add("Play Pause 4 BlueStacks", MediaPlay4AllorMediaPlay4NoxState1)
if (mdastate == 0){
    playpausestate.Check("Play Pause 4 All")
    playpausestate.Uncheck("Play Pause 4 BlueStacks")
} else if (mdastate == 1){
    playpausestate.Uncheck("Play Pause 4 All")
    playpausestate.Check("Play Pause 4 BlueStacks")
}

;---------------------------------------------------------------------------------------
mkeyonestate := Menu()
mkeyonestate.Add("Media_Key 4 All", mediakey4allchoose)
mkeyonestate.Add("Media_Key 4 OneNote", mediakey4onenotechoose)
if (mdkystate == 1){
    mkeyonestate.Uncheck("Media_Key 4 All")
    mkeyonestate.Check("Media_Key 4 OneNote")
} else if (mdkystate == 0){
    mkeyonestate.Check("Media_Key 4 All")
    mkeyonestate.Uncheck("Media_Key 4 OneNote")
}

;---------------------------------------------------------------------------------------
fnkeystate := Menu()
fnkeystate.Add("Enable", fnkeysenable)
fnkeystate.Add("Disable", fnkeysdisable)
if (fnstate == 0){
    fnkeystate.Check("Disable")
    fnkeystate.Uncheck("Enable")
} else if (fnstate == 1){
    fnkeystate.Uncheck("Disable")
    fnkeystate.Check("Enable")
}

;---------------------------------------------------------------------------------------
numpadkeystate := Menu()
numpadkeystate.Add("Enable", numpadkeysenable)
numpadkeystate.Add("Disable", numpadkeysdisable)
if (numpadkeytoggle == 1){
    numpadkeystate.Check("Disable")
    numpadkeystate.Uncheck("Enable")
} else if (numpadkeytoggle == 0){
    numpadkeystate.Uncheck("Disable")
    numpadkeystate.Check("Enable")
}

;----------------------------------------------------------------------------------------
spclnavigationbuttonmode := Menu()
spclnavigationbuttonmode.Add("ON", spclnavigationbuttonon)
spclnavigationbuttonmode.Add("OFF", spclnavigationbuttonoff)
if (spclnavbutm = 01){
    spclnavigationbuttonmode.Check("ON")
    spclnavigationbuttonmode.Uncheck("OFF")
} else if (spclnavbutm = 00){
    spclnavigationbuttonmode.Uncheck("ON")
    spclnavigationbuttonmode.Check("OFF")
}

;---------------------------------------------------------------------------------------
scrolledstate := Menu()
scrolledstate.Add("WheelUP - ScrollUp || WheelDown - ScrollDown", wheelscrollupdownchoose)
scrolledstate.Add("WheelUp - RightArrow || WheelDown - LeftArrow", wheelrightleftarrowchoose)
if (whelscrlfn == 0){
    scrolledstate.Check("WheelUP - ScrollUp || WheelDown - ScrollDown")
    scrolledstate.Uncheck("WheelUp - RightArrow || WheelDown - LeftArrow")
} else if (whelscrlfn == 1){
    scrolledstate.Uncheck("WheelUP - ScrollUp || WheelDown - ScrollDown")
    scrolledstate.Check("WheelUp - RightArrow || WheelDown - LeftArrow")
}

;----------------------------------------------------------------------------------------
mousemdlbtnstate := Menu()
mousemdlbtnstate.Add("Enable", mousemdlbtnstatedisable)
mousemdlbtnstate.Add("Disable", mousemdlbtnstateenable)
if (mbtnstate == 0){
    mousemdlbtnstate.Uncheck("Enable")
    mousemdlbtnstate.Check("Disable")
} else if (mbtnstate == 1){
    mousemdlbtnstate.Check("Enable")
    mousemdlbtnstate.Uncheck("Disable")
}

;----------------------------------------------------------------------------------------
mousextrbtnstate := Menu()
mousextrbtnstate.Add("XBttn1 - LeftArrow || XBttn2 - RightArrow", xtrbttnlrarw)
mousextrbtnstate.Add()
mousextrbtnstate.Add("XBttn1 - BackWard5s || XBttn2 - Forward5s", xtrbttnfb5s)
mousextrbtnstate.Add()
mousextrbtnstate.Add("XBttn1 - WheelRight || XBttn2 - WheelLeft", xtrbttnwrwl)
if (xbuttonstate == 01){
    mousextrbtnstate.Check("XBttn1 - LeftArrow || XBttn2 - RightArrow")
    mousextrbtnstate.Uncheck("XBttn1 - BackWard5s || XBttn2 - Forward5s")
    mousextrbtnstate.Uncheck("XBttn1 - WheelRight || XBttn2 - WheelLeft")
} else if (xbuttonstate == 10){
    mousextrbtnstate.Uncheck("XBttn1 - LeftArrow || XBttn2 - RightArrow")
    mousextrbtnstate.Check("XBttn1 - BackWard5s || XBttn2 - Forward5s")
    mousextrbtnstate.Uncheck("XBttn1 - WheelRight || XBttn2 - WheelLeft")
} else if (xbuttonstate == 11){
    mousextrbtnstate.Uncheck("XBttn1 - LeftArrow || XBttn2 - RightArrow")
    mousextrbtnstate.Uncheck("XBttn1 - BackWard5s || XBttn2 - Forward5s")
    mousextrbtnstate.Check("XBttn1 - WheelRight || XBttn2 - WheelLeft")
}

;----------------------------------------------------------------------------------------
clippingtoolselect := Menu()
clippingtoolselect.Add("Snipaste Screen Clipper", ahkscrnclipselect)
clippingtoolselect.Add("Sharex Screen Clipper", sharexscrnclipselect)

;----------------------------------------------------------------------------------------
ahkbtnselector := Menu()
ahkbtnselector.Add("Snipaste_ScrnClip - MButton", ahkscnclipmdlbtnselect)
ahkbtnselector.Add("Snipaste_ScrnClip - RButton", ahkscncliprghtbtnselect)
if (screenclipstate == 10){
    ahkbtnselector.Uncheck("Snipaste_ScrnClip - MButton")
    ahkbtnselector.Check("Snipaste_ScrnClip - RButton")
} else if (screenclipstate == 01){
    ahkbtnselector.Check("Snipaste_ScrnClip - MButton")
    ahkbtnselector.Uncheck("Snipaste_ScrnClip - RButton")
}

;----------------------------------------------------------------------------------------
sharexbtnselector := Menu()
sharexbtnselector.Add("Sharex_ScrnClip - MButton", sharexclipmdlbtnselect)
sharexbtnselector.Add("Sharex_ScrnClip - RButton", sharexcliprghtbtnselect)
if (sharexclipstate == 00){
    sharexbtnselector.Uncheck("Sharex_ScrnClip - MButton")
    sharexbtnselector.Check("Sharex_ScrnClip - RButton")
} else if (sharexclipstate == 11){
    sharexbtnselector.Check("Sharex_ScrnClip - MButton")
    sharexbtnselector.Uncheck("Sharex_ScrnClip - RButton")
}

;----------------------------------------------------------------------------------------
tklksfmodeselector := Menu()
tklksfmodeselector.Add("ON", tklksfmodeon)
tklksfmodeselector.Add("OFF", tklksfmodeoff)
if (tklmode == 01){
    tklksfmodeselector.Check("ON")
    tklksfmodeselector.Uncheck("OFF")
} else if (tklmode == 00){
    tklksfmodeselector.Uncheck("ON")
    tklksfmodeselector.Check("OFF")
}

;======================================================================================
; Tray Menu
;======================================================================================
A_TrayMenu.Delete()
A_TrayMenu.SetIcon(A_ScriptDir "\bin\icons\fnenableone_all.ico")
A_TrayMenu.Add("Screenshot State", sharexshotstate)
A_TrayMenu.Add("SpeedUpDown_UnRe State", speedunrestate)
A_TrayMenu.Add()
A_TrayMenu.Add("CopyCut/CopylinkCopyCut State", copycutstate)
A_TrayMenu.Add("Paste/PastePastePlain State", pastestate)
A_TrayMenu.Add()
A_TrayMenu.Add("Play Pause State", playpausestate)
A_TrayMenu.Add("Media Key State", mkeyonestate)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Fn AHK Keys State", fnkeystate)
A_TrayMenu.Add()
A_TrayMenu.Add("Numpad AHK Kyes State", numpadkeystate)
A_TrayMenu.Add()
A_TrayMenu.Add("Keyboard Nav_Btn to Media_Control", spclnavigationbuttonmode)
A_TrayMenu.Add()
A_TrayMenu.Add("ScrollWheel - State", scrolledstate)
A_TrayMenu.Add("Mouse_Middle_Button State", mousemdlbtnstate)
A_TrayMenu.Add("Mouse_Xtra_Buttons State", mousextrbtnstate)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Clipping Tool", clippingtoolselect)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Snipaste Clip Activate Button", ahkbtnselector)
A_TrayMenu.Check("Snipaste Clip Activate Button")
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Sharex Clip Activate Button", sharexbtnselector)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("TKL Keyboard ijkl => ULDR", tklksfmodeselector)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Lecture Recordings", lectruerecordingopen)
A_TrayMenu.Add("Explore E_D", exploreedopen)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("OneNote", OneNoterunner)
A_TrayMenu.Add("Calculator", calculatorrunneropen)
A_TrayMenu.Add("Notepad", notepadrunneropen)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Edit App Script", editscript)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Reload App", appreloader)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Suspend App", appsuspender)
A_TrayMenu.Add()
A_TrayMenu.Add()
A_TrayMenu.Add("Exit App", exiterapp)

;=============================================================================================
; Context menu
;=============================================================================================
MNFunctions := Menu()
MNFunctions.Add("Screenshot State", sharexshotstate)
MNFunctions.Add("SpeedUpDown_UnRe State", speedunrestate)
MNFunctions.Add()
MNFunctions.Add("CopyCut/CopylinkCopyCut State", copycutstate)
MNFunctions.Add("Paste/PastePastePlain State", pastestate)
MNFunctions.Add()
MNFunctions.Add("Play Pause State", playpausestate)
MNFunctions.Add("Media Key State", mkeyonestate)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Fn Keys State", fnkeystate)
MNFunctions.Add()
MNFunctions.Add("Numpad AHK Kyes State", numpadkeystate)
MNFunctions.Add()
MNFunctions.Add("Keyboard Nav_Btn to Media_Control", spclnavigationbuttonmode)
MNFunctions.Add()
MNFunctions.Add("ScrollWheel - State", scrolledstate)
MNFunctions.Add("Mouse_Middle_Button State", mousemdlbtnstate)
MNFunctions.Add("Mouse_Xtra_Buttons State", mousextrbtnstate)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Clipping Tool", clippingtoolselect)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Snipaste Clip Activate Button", ahkbtnselector)
MNFunctions.Check("Snipaste Clip Activate Button")
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Sharex Clip Activate Button", sharexbtnselector)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("TKL Keyboard ijkl => ULDR", tklksfmodeselector)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Lecture Recordings", lectruerecordingopen)
MNFunctions.Add("Explore E_D", exploreedopen)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("OneNote", OneNoterunner)
MNFunctions.Add("Calculator", calculatorrunneropen)
MNFunctions.Add("Notepad", notepadrunneropen)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Edit App Script", editscript)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Reload App", appreloader)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Suspend App", appsuspender)
MNFunctions.Add()
MNFunctions.Add()
MNFunctions.Add("Exit App", exiterapp)

;----------------------------------------------------------------------------------------
; Universal clipper tool menu select function
if (clipperchoose == 0){
    clippingtoolselect.Check("Snipaste Screen Clipper")
    clippingtoolselect.Uncheck("Sharex Screen Clipper")
    A_TrayMenu.Check("Snipaste Clip Activate Button")
    MNFunctions.Check("Snipaste Clip Activate Button")
    A_TrayMenu.Uncheck("Sharex Clip Activate Button")
    MNFunctions.Uncheck("Sharex Clip Activate Button")
} else if (clipperchoose == 1){
    clippingtoolselect.Uncheck("Snipaste Screen Clipper")
    clippingtoolselect.Check("Sharex Screen Clipper")
    A_TrayMenu.Uncheck("Snipaste Clip Activate Button")
    MNFunctions.Uncheck("Snipaste Clip Activate Button")
    A_TrayMenu.Check("Sharex Clip Activate Button")
    MNFunctions.Check("Sharex Clip Activate Button")
}

;====================================================================================================================
; Hotkey for middle mouse button (Snipaste)
;====================================================================================================================
#HotIf (mbtnstate=0 AND screenclipstate=01 AND clipperchoose=0)

; Variables
global LongPressThreshold := 300
global MiddleMouseDown := false
global MiddleMouseDownTime := 0
global ClickCount := 0

MButton::
{
    global MiddleMouseDown, MiddleMouseDownTime
    if (!MiddleMouseDown) {
        MiddleMouseDown := true
        MiddleMouseDownTime := A_TickCount
        SetTimer CheckMiddleMouseLongPress, 10
    }
}

MButton Up::
{
    global MiddleMouseDown, MiddleMouseDownTime, ClickCount, LongPressThreshold
    SetTimer CheckMiddleMouseLongPress, 0
    if (MiddleMouseDown) {
        MiddleMouseDown := false
        if ((A_TickCount - MiddleMouseDownTime) < LongPressThreshold) {
            ClickCount := (ClickCount ? ClickCount + 1 : 1)
            if (ClickCount < 3)
                ToolTip ClickCount
            SetTimer mbclickmonitor4left, 300
        }
    }
}

CheckMiddleMouseLongPress()
{
    global MiddleMouseDown, MiddleMouseDownTime, LongPressThreshold
    if (MiddleMouseDown && (A_TickCount - MiddleMouseDownTime >= LongPressThreshold)) {
        SendInput "^!/"
        MiddleMouseDown := false
        SetTimer CheckMiddleMouseLongPress, 0
    }
}

~WheelUp::
{
    winClass := WinGetClass("A")
    winExe := WinGetProcessName("A")

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            Send "{Ctrl down}{c down}"
            Sleep 5
            Send "{c up}{Ctrl up}"
            Sleep 5
            SendInput "{Escape}"
        }
    }
}

~WheelDown::
{
    winClass := WinGetClass("A")
    winExe := WinGetProcessName("A")

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            Send "{Escape down}{Escape up}"
            SendInput "^+{PrintScreen}"
        }
    }
}

~RButton::
{
    winClass := WinGetClass("A")
    winExe := WinGetProcessName("A")

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if GetKeyState("LButton", "P")
        {
            Send "{Shift down}"
            MouseClick "Middle"
            Send "{Shift up}"
        }
    }
}

#HotIf

;====================================================================================================================
; Hotkey for right mouse button (Snipaste)
;====================================================================================================================
#HotIf (mbtnstate=0 AND screenclipstate=10 AND clipperchoose=0)

global holdThreshold := 300
global isHolding := false

RButton::
{
    global isHolding, holdThreshold
    isHolding := false
    SetTimer CheckHold, -holdThreshold
}

CheckHold()
{
    global isHolding
    if (GetKeyState("RButton", "P")) {
        isHolding := true
        SendInput "^!/"
        SetTimer CheckHold, 0
    }
}

RButton up::
{
    global isHolding
    SetTimer CheckHold, 0
    if (!isHolding) {
        Click "Right"
    }
}

MButton::
{
    global ClickCount
    If (ClickCount > 0)
        ClickCount += 1
    else
        ClickCount := 1
    If (ClickCount < 3)
        ToolTip ClickCount
    SetTimer mbclickmonitor4left, 300
}

~WheelUp::
{
    winClass := WinGetClass("A")
    winExe := WinGetProcessName("A")

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            Send "{Ctrl down}{c down}"
            Sleep 5
            Send "{c up}{Ctrl up}"
            Sleep 5
            SendInput "{Escape}"
        }
    }
}

~WheelDown::
{
    winClass := WinGetClass("A")
    winExe := WinGetProcessName("A")

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            Send "{Escape down}{Escape up}"
            SendInput "^+{PrintScreen}"
        }
    }
}

#HotIf

;====================================================================================================================
; Hotkey for middle mouse button (Sharex)
;====================================================================================================================
#HotIf (mbtnstate=0 AND sharexclipstate=11 AND clipperchoose=1)

global MiddleMouseDownTime := 0

MButton::
{
    global MiddleMouseDownTime
    MiddleMouseDownTime := A_TickCount
    SetTimer CheckLongPress, 300
}

CheckLongPress()
{
    global MiddleMouseDownTime
    if (GetKeyState("MButton", "P")) {
        SendInput "^+/"
    }
    MiddleMouseDownTime := 0
    SetTimer CheckLongPress, 0
}

MButton up::
{
    global MiddleMouseDownTime, ClickCount
    Duration := A_TickCount - MiddleMouseDownTime
    if (Duration < 300) {
        If (ClickCount > 0)
            ClickCount += 1
        else
            ClickCount := 1
        If (ClickCount < 3)
            ToolTip ClickCount
        SetTimer mbclickmonitor, 300
    }
}

#HotIf

;====================================================================================================================
; Hotkey for right mouse button (Sharex)
;====================================================================================================================
#HotIf (mbtnstate=0 AND sharexclipstate=00 AND clipperchoose=1)

global holdThresholdli := 300
global isHoldingki := false

RButton::
{
    global isHoldingki, holdThresholdli
    isHoldingki := false
    SetTimer CheckHoldpi, -holdThresholdli
}

CheckHoldpi()
{
    global isHoldingki
    if (GetKeyState("RButton", "P")) {
        isHoldingki := true
        SendInput "^+/"
        SetTimer CheckHoldpi, 0
    }
}

RButton up::
{
    global isHoldingki
    SetTimer CheckHoldpi, 0
    if (!isHoldingki) {
        Click "Right"
    }
}

MButton::
{
    global ClickCount
    If (ClickCount > 0)
        ClickCount += 1
    else
        ClickCount := 1
    If (ClickCount < 3)
        ToolTip ClickCount
    SetTimer mbclickmonitor, 300
    Click "Middle"
}

#HotIf

;====================================================================================================================
; Mouse wheel function
;====================================================================================================================
#HotIf (whelscrlfn=1)
WheelUp::Right
WheelDown::Left
#HotIf

;====================================================================================================================
; Mouse extra buttons function
;====================================================================================================================
#HotIf (xbuttonstate = 11)
XButton1::WheelRight
XButton2::WheelLeft
#HotIf

#HotIf (xbuttonstate = 01)
XButton1::Left
XButton2::Right
#HotIf

#HotIf (xbuttonstate = 10)
XButton1::backwardbysec
XButton2::forwardbysec
#HotIf

;====================================================================================================================
; Timer functions
;====================================================================================================================
mbclickmonitor()
{
    global ClickCount, mdastate, mdkystate, ChoosePlayer
    If (ClickCount = 1) 
    {
        if (mdastate=0) and (mdkystate=1)
        {
            SendInput "^+6"
        }
        else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=10)
        {
            SendInput "^!6"
        }
        else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=11)
        {
            SendInput "!+6"
        }
        else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
        {
            SendInput "{Media_Play_Pause}"
        }
        else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe")
        {
            WinActivate "BlueStacks App Player"
            SendInput "s"
        }
        else
        {
            SendInput "{Media_Play_Pause}"
        }
    } 
    else if (ClickCount > 1) 
    {
        MNFunctions.Show()
        SetTimer mbclickmonitor, 0
    }
    ClickCount := 0
    SetTimer mbclickmonitor, 0
    ToolTip
}

mbclickmonitor4left()
{
    global ClickCount
    If (ClickCount = 1) 
    {
        checkahkguisclipclosernmedia()
    } 
    else if (ClickCount > 1) 
    {
        MNFunctions.Show()
        SetTimer mbclickmonitor4left, 0
    }
    ClickCount := 0
    SetTimer mbclickmonitor4left, 0
    ToolTip
}

mbclickplaypressmonitor4left()
{
    global mdastate, mdkystate, ChoosePlayer
    if (mdastate=0) and (mdkystate=1)
    {
        SendInput "^+6"
    }
    else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=10)
    {
        SendInput "^!6"
    }
    else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=11)
    {
        SendInput "!+6"
    }
    else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
    {
        SendInput "{Media_Play_Pause}"
    }
    else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe")
    {
        WinActivate "BlueStacks App Player"
        SendInput "s"
    }
    else
    {
        SendInput "{Media_Play_Pause}"
    }
}

xKeyPressMonitor()
{
    global KeyPressCount, recstartv, recpausev, audiotext
    
    If (KeyPressCount = 1)
    {
        If (recstartv = 1)
        {
            recstartv := !recstartv
            recpausev := 0
            SendInput("^+{Space}")
            
            ; Get most recent MP3 file
            local FileList := ""  ; Explicitly declare as local
            Loop Files, "C:\DaTa\#5. Music\Lecture_Recordings\*.mp3"
            {
                FileList .= A_LoopFileTimeModified . "`t" . A_LoopFileLongPath . "`n"
            }
            FileList := Sort(FileList, "R")
            Loop Parse, FileList, "`n"
            {
                If (A_LoopField = "")
                    Continue
                FileItem := StrSplit(A_LoopField, "`t")
                ClipboardSetFiles(FileItem[2])
                Break
            }
            
            ShowSplash("Recording Finished", 1000)
            audiotext := "Recording Finished"
            SetTimer(FollowMouse, 0)  ; Pass function reference, not string
            ToolTip()
        }
        else 
        {
            recstartv := !recstartv
            recpausev := 0
            SendInput("^+{Space}")
            ShowSplash("Recording Started", 1000)
            audiotext := "Recording"
            SetTimer(FollowMouse, 10)  ; Pass function reference
        }
    }
    else if (KeyPressCount > 1)
    {
        If (recstartv = 1 AND recpausev = 1)
        {
            SendInput("^{Space}")
            recpausev := 0
            ShowSplash("Recording Continue", 1000)
            audiotext := "Recording Continue"
        }
        else If (recstartv = 1 AND recpausev = 0)
        {
            SendInput("^{Space}")
            recpausev := 1
            ShowSplash("Recording Paused", 1000)
            audiotext := "Recording Paused"
        }
        else If (recstartv = 0)
        {
            ToolTip()
            ShowSplash("Recording Not Started", 1000)
            ToolTip("Recording Not Started")
            Sleep(1000)
            ToolTip()
        }
        else 
        {
            ShowSplash("Recording Not Started", 1000)
            ToolTip("Recording Not Started")
            Sleep(1000)
            ToolTip()
        }
    }
    KeyPressCount := 0
    SetTimer(xKeyPressMonitor, 0)
}

; Replace SplashTextOn/Off with GUI
ShowSplash(text, duration := 1000)
{
    static splashGui := ""
    
    if (splashGui)
        splashGui.Destroy()
    
    splashGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    splashGui.SetFont("s12")
    splashGui.Add("Text", "w300 h70 Center 0x200", text)
    splashGui.Show("NoActivate")
    
    SetTimer(() => splashGui.Destroy(), -duration)
}
;====================================================================================================================

ClipboardSetFiles(FilesToSet, DropEffect := "Copy") {
    Static TCS := 2
    Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect", "UInt")
    Static DropEffects := Map(1, 1, 2, 2, "Copy", 1, "Move", 2)
    
    TotalLength := 0
    FileArray := []
    Loop Parse, FilesToSet, "`n", "`r"
    {
        If (Length := StrLen(A_LoopField))
        {
            FileArray.Push({Path: A_LoopField, Len: Length + 1})
            TotalLength += Length
        }
    }
    FileCount := FileArray.Length
    If !(FileCount && TotalLength)
        Return False
    
    If DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) && DllCall("EmptyClipboard") {
        hDrop := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20 + (TotalLength + FileCount + 1) * TCS, "UPtr")
        pDrop := DllCall("GlobalLock", "Ptr", hDrop)
        Offset := 20
        NumPut "UInt", Offset, pDrop + 0
        NumPut "UInt", 1, pDrop + 16
        For Each, File in FileArray
            Offset += StrPut(File.Path, pDrop + Offset, File.Len) * TCS
        DllCall("GlobalUnlock", "Ptr", hDrop)
        DllCall("SetClipboardData", "UInt", 0x0F, "UPtr", hDrop)
        
        If (DropEffect := DropEffects[DropEffect]) {
            hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr")
            pMem := DllCall("GlobalLock", "Ptr", hMem)
            NumPut "UChar", DropEffect, pMem + 0
            DllCall("GlobalUnlock", "Ptr", hMem)
            DllCall("SetClipboardData", "UInt", PreferredDropEffect, "Ptr", hMem)
        }
        DllCall("CloseClipboard")
        Return True
    }
    Return False
}

;====================================================================================================================
; Label functions converted to functions
;====================================================================================================================
backwardbysec()
{
    global mdastate, ChoosePlayer
    if (mdastate=0 and ChoosePlayer=00)
    {
        SendInput "^+9"
    }
    else if (mdastate=0 and ChoosePlayer=10)
    {
        SendInput "^!9"
    }
    else if (mdastate=0 and ChoosePlayer=11)
    {
        SendInput "!+1"
    }
    else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe")
    {
        WinActivate "BlueStacks App Player"
        SendInput "a"
    }
    else
    {
        SendInput "^+9"
    }
}

playpausepress()
{
    global mdastate, mdkystate, ChoosePlayer
    if (mdastate=0) and (mdkystate=1)
    {
        SendInput "^+6"
    }
    else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=10)
    {
        SendInput "^!6"
    }
    else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=11)
    {
        SendInput "!+5"
    }
    else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
    {
        SendInput "^+6"
    }
    else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe")
    {
        WinActivate "BlueStacks App Player"
        SendInput "s"
    }
    else
    {
        SendInput "{Media_Play_Pause}"
    }
}

forwardbysec()
{
    global mdastate, ChoosePlayer
    if (mdastate=0 and ChoosePlayer=00)
    {
        SendInput "^+0"
    }
    else if (mdastate=0 and ChoosePlayer=10)
    {
        SendInput "^!0"
    }
    else if (mdastate=0 and ChoosePlayer=11)
    {
        SendInput "!+2"
    }
    else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe")
    {
        WinActivate "BlueStacks App Player"
        SendInput "d"
    }
    else
    {
        SendInput "^+0"
    }
}

decundo()
{
    global spustate, ChoosePlayer
    if (spustate = 0)
    {
        if (ChoosePlayer=11)
        {
            SendInput "!+3"
        }
        else if (ChoosePlayer=10)
        {
            SendInput "^!7"
        }
        else
        {
            SendInput "^+7"
        }
    }
    else if (spustate = 1)
    {
        SendInput "^z"
    }
}

incredo()
{
    global spustate, ChoosePlayer
    if (spustate = 0)
    {
        if (ChoosePlayer=11)
        {
            SendInput "!+4"
        }
        else if (ChoosePlayer=10)
        {
            SendInput "^!8"
        }
        else
        {
            SendInput "^+8"
        }
    }
    else if (spustate = 1)
    {
        SendInput "^y"
    }
}

;====================================================================================================================
; Menu handler functions
;====================================================================================================================
Screenshot1orScreenshot2State0(*)
{
    global scrstate, settingsFile
    scrstate := 0
    saveSetting("scrstate", scrstate, settingsFile)
    sharexshotstate.Uncheck("ScrnShot - 1 || ReptShot - 2")
    sharexshotstate.Check("ScrnShot - 2 || ReptShot - 1")
}

Screenshot1orScreenshot2State1(*)
{
    global scrstate, settingsFile
    scrstate := 1
    saveSetting("scrstate", scrstate, settingsFile)
    sharexshotstate.Check("ScrnShot - 1 || ReptShot - 2")
    sharexshotstate.Uncheck("ScrnShot - 2 || ReptShot - 1")
}

SpeedUpDownor_State(*)
{
    global spustate, settingsFile
    spustate := 0
    saveSetting("spustate", spustate, settingsFile)
    speedunrestate.Check("SpeedUp || SpeedDown")
    speedunrestate.Uncheck("Redo || Undo")
    MsgBox("^ - speed up`nv - speed down", "Speed up/down", 0x40000)
}

UndoRedo_State(*)
{
    global spustate, settingsFile
    spustate := 1
    saveSetting("spustate", spustate, settingsFile)
    speedunrestate.Uncheck("SpeedUp || SpeedDown")
    speedunrestate.Check("Redo || Undo")
    MsgBox("^ - redo`nv - undo", "undo/redo", 0x40000)
}

copycutchoose(*)
{
    global cpcstate, settingsFile
    cpcstate := 0
    saveSetting("cpcstate", cpcstate, settingsFile)
    copycutstate.Check("Copy || Cut")
    copycutstate.Uncheck("CopyLinkOneNote || Copy || Cut")
    MsgBox("copy - 1 press`ncut  - 1 press", "copy/cut", 0x40000)
}

copylinkcopycutchoose(*)
{
    global cpcstate, settingsFile
    cpcstate := 1
    saveSetting("cpcstate", cpcstate, settingsFile)
    copycutstate.Uncheck("Copy || Cut")
    copycutstate.Check("CopyLinkOneNote || Copy || Cut")
    MsgBox("copylink(onenote) - 1 press`ncopy - 2 press`ncut - 3 press", "copylink/copy/cut", 0x40000)
}

pasteon1press(*)
{
    global pstpstplnste, settingsFile
    pstpstplnste := 0
    saveSetting("pstpstplnste", pstpstplnste, settingsFile)
    pastestate.Check("Paste")
    pastestate.Uncheck("1. Paste || 2. Paste Plain OneNote")
    SplashTextOn 150, 40, "", "Paste"
    Sleep 600
    SplashTextOff
}

pasteon1presspasteplain2press(*)
{
    global pstpstplnste, settingsFile
    pstpstplnste := 1
    saveSetting("pstpstplnste", pstpstplnste, settingsFile)
    pastestate.Uncheck("Paste")
    pastestate.Check("1. Paste || 2. Paste Plain OneNote")
    SplashTextOn 300, 50, "", "1. Paste || 2. Paste Plain OneNote"
    Sleep 600
    SplashTextOff
}

MediaPlay4AllorMediaPlay4NoxState0(*)
{
    global mdastate, settingsFile
    mdastate := 0
    saveSetting("mdastate", mdastate, settingsFile)
    SoundBeep 300, 700
    playpausestate.Check("Play Pause 4 All")
    playpausestate.Uncheck("Play Pause 4 BlueStacks")
    iconchanger()
}

MediaPlay4AllorMediaPlay4NoxState1(*)
{
    global mdastate, settingsFile
    mdastate := 1
    saveSetting("mdastate", mdastate, settingsFile)
    SoundBeep 300, 700
    playpausestate.Uncheck("Play Pause 4 All")
    playpausestate.Check("Play Pause 4 BlueStacks")
    iconchanger()
}

Bluestackflscmxmmd(*)
{
    global bluestackmode, settingsFile
    bluestackmode := !bluestackmode
    saveSetting("bluestackmode", bluestackmode, settingsFile)
    if (bluestackmode=0)
    {
        MsgBox("Bluestacks Maximize", "Bluestacks Maximize", 0x40000)
    }
    else if (bluestackmode=1)
    {
        MsgBox("Bluestacks Fullscreen", "Bluestacks Fullscreen", 0x40000)
    }
}

mk4acDefault(*)
{
    global mdkystate, ChoosePlayer, settingsFile
    mdkystate := 0
    ChoosePlayer := 00
    saveSetting("mdkystate", mdkystate, settingsFile)
    saveSetting("ChoosePlayer", ChoosePlayer, settingsFile)
    mediakey4allchoose.Check("Media_Key (default)")
    mediakey4allchoose.Uncheck("Media_Key (PotPlayer)")
    mediakey4allchoose.Uncheck("Media_Key (Opera)")
    mkeyonestate.Check("Media_Key 4 All")
    mkeyonestate.Uncheck("Media_Key 4 OneNote")
    MsgBox("Play/Pause - Media_Play_Pause`nMediaKey -4- Default", "Media_Play_Pause", 0x40000)
}

mk4acPotPlayer(*)
{
    global mdkystate, ChoosePlayer, settingsFile
    mdkystate := 0
    ChoosePlayer := 10
    saveSetting("mdkystate", mdkystate, settingsFile)
    saveSetting("ChoosePlayer", ChoosePlayer, settingsFile)
    mediakey4allchoose.Uncheck("Media_Key (default)")
    mediakey4allchoose.Check("Media_Key (PotPlayer)")
    mediakey4allchoose.Uncheck("Media_Key (Opera)")
    mkeyonestate.Check("Media_Key 4 All")
    mkeyonestate.Uncheck("Media_Key 4 OneNote")
    MsgBox("Play/Pause - Media_Play_Pause`nMediaKey -4- PotPlayer", "Media_Play_Pause", 0x40000)
}

mk4acOpera(*)
{
    global mdkystate, ChoosePlayer, settingsFile
    mdkystate := 0
    ChoosePlayer := 11
    saveSetting("mdkystate", mdkystate, settingsFile)
    saveSetting("ChoosePlayer", ChoosePlayer, settingsFile)
    mediakey4allchoose.Uncheck("Media_Key (default)")
    mediakey4allchoose.Uncheck("Media_Key (PotPlayer)")
    mediakey4allchoose.Check("Media_Key (Opera)")
    mkeyonestate.Check("Media_Key 4 All")
    mkeyonestate.Uncheck("Media_Key 4 OneNote")
    MsgBox("Play/Pause - Media_Play_Pause`nMediaKey -4- Opera", "Media_Play_Pause", 0x40000)
}

mediakey4onenotechoose(*)
{
    global mdkystate, settingsFile
    mdkystate := 1
    saveSetting("mdkystate", mdkystate, settingsFile)
    mkeyonestate.Uncheck("Media_Key 4 All")
    mkeyonestate.Check("Media_Key 4 OneNote")
    MsgBox("Play/Pause - ctrl + shift + 6", "Media_Play_Pause", 0x40000)
}

fnkeysdisable(*)
{
    global fnstate, settingsFile
    fnstate := 0
    saveSetting("fnstate", fnstate, settingsFile)
    SoundBeep 900, 500
    fnkeystate.Check("Disable")
    fnkeystate.Uncheck("Enable")
    SplashTextOn 250, 40, "", "Fn AHK Keys Disable"
    Sleep 800
    SplashTextOff
    iconchanger()
}

fnkeysenable(*)
{
    global fnstate, settingsFile
    fnstate := 1
    saveSetting("fnstate", fnstate, settingsFile)
    SoundBeep 900, 500
    fnkeystate.Uncheck("Disable")
    fnkeystate.Check("Enable")
    SplashTextOn 250, 40, "", "Fn AHK Keys Enable"
    Sleep 800
    SplashTextOff
    iconchanger()
}

numpadkeysdisable(*)
{
    global numpadkeytoggle, settingsFile
    numpadkeytoggle := 1
    saveSetting("numpadkeytoggle", numpadkeytoggle, settingsFile)
    SoundBeep 700, 800
    numpadkeystate.Check("Disable")
    numpadkeystate.Uncheck("Enable")
    SplashTextOn 300, 40, "", "Numpad AHK Keys Disable"
    Sleep 800
    SplashTextOff
    iconchanger()
}

numpadkeysenable(*)
{
    global numpadkeytoggle, settingsFile
    numpadkeytoggle := 0
    saveSetting("numpadkeytoggle", numpadkeytoggle, settingsFile)
    SoundBeep 700, 800
    numpadkeystate.Uncheck("Disable")
    numpadkeystate.Check("Enable")
    SplashTextOn 350, 40, "", "Numpad AHK Keys Enable"
    Sleep 800
    SplashTextOff
    iconchanger()
}

spclnavigationbuttonon(*)
{
    global spclnavbutm, settingsFile
    spclnavbutm := 01
    saveSetting("spclnavbutm", spclnavbutm, settingsFile)
    SoundBeep 700, 800
    spclnavigationbuttonmode.Check("ON")
    spclnavigationbuttonmode.Uncheck("OFF")
    SplashTextOn 350, 40, "", "NavBtn changed to Media_Control"
    Sleep 800
    SplashTextOff
}

spclnavigationbuttonoff(*)
{
    global spclnavbutm, settingsFile
    spclnavbutm := 00
    saveSetting("spclnavbutm", spclnavbutm, settingsFile)
    SoundBeep 700, 800
    spclnavigationbuttonmode.Uncheck("ON")
    spclnavigationbuttonmode.Check("OFF")
    SplashTextOn 350, 40, "", "NavBtn changed to Default"
    Sleep 800
    SplashTextOff
}

wheelscrollupdownchoose(*)
{
    global whelscrlfn, settingsFile
    whelscrlfn := 0
    saveSetting("whelscrlfn", whelscrlfn, settingsFile)
    scrolledstate.Check("WheelUP - ScrollUp || WheelDown - ScrollDown")
    scrolledstate.Uncheck("WheelUp - RightArrow || WheelDown - LeftArrow")
}

wheelrightleftarrowchoose(*)
{
    global whelscrlfn, settingsFile
    whelscrlfn := 1
    saveSetting("whelscrlfn", whelscrlfn, settingsFile)
    scrolledstate.Uncheck("WheelUP - ScrollUp || WheelDown - ScrollDown")
    scrolledstate.Check("WheelUp - RightArrow || WheelDown - LeftArrow")
}

mousemdlbtnstateenable(*)
{
    global mbtnstate, settingsFile
    mbtnstate := 0
    saveSetting("mbtnstate", mbtnstate, settingsFile)
    mousemdlbtnstate.Uncheck("Enable")
    mousemdlbtnstate.Check("Disable")
    SplashTextOn 250, 50, "", "Mouse_Middle_Button Disable"
    Sleep 600
    SplashTextOff
}

mousemdlbtnstatedisable(*)
{
    global mbtnstate, settingsFile
    mbtnstate := 1
    saveSetting("mbtnstate", mbtnstate, settingsFile)
    mousemdlbtnstate.Check("Enable")
    mousemdlbtnstate.Uncheck("Disable")
    SplashTextOn 250, 50, "", "Mouse_Middle_Button Enable"
    Sleep 600
    SplashTextOff
}

xtrbttnlrarw(*)
{
    global xbuttonstate, settingsFile
    xbuttonstate := 01
    saveSetting("xbuttonstate", xbuttonstate, settingsFile)
    mousextrbtnstate.Check("XBttn1 - LeftArrow || XBttn2 - RightArrow")
    mousextrbtnstate.Uncheck("XBttn1 - BackWard5s || XBttn2 - Forward5s")
    mousextrbtnstate.Uncheck("XBttn1 - WheelRight || XBttn2 - WheelLeft")
}

xtrbttnfb5s(*)
{
    global xbuttonstate, settingsFile
    xbuttonstate := 10
    saveSetting("xbuttonstate", xbuttonstate, settingsFile)
    mousextrbtnstate.Uncheck("XBttn1 - LeftArrow || XBttn2 - RightArrow")
    mousextrbtnstate.Check("XBttn1 - BackWard5s || XBttn2 - Forward5s")
    mousextrbtnstate.Uncheck("XBttn1 - WheelRight || XBttn2 - WheelLeft")
}

xtrbttnwrwl(*)
{
    global xbuttonstate, settingsFile
    xbuttonstate := 11
    saveSetting("xbuttonstate", xbuttonstate, settingsFile)
    mousextrbtnstate.Uncheck("XBttn1 - LeftArrow || XBttn2 - RightArrow")
    mousextrbtnstate.Uncheck("XBttn1 - BackWard5s || XBttn2 - Forward5s")
    mousextrbtnstate.Check("XBttn1 - WheelRight || XBttn2 - WheelLeft")
}

ahkscrnclipselect(*)
{
    global clipperchoose, settingsFile
    clipperchoose := 0
    saveSetting("clipperchoose", clipperchoose, settingsFile)
    clippingtoolselect.Check("Snipaste Screen Clipper")
    clippingtoolselect.Uncheck("Sharex Screen Clipper")
    A_TrayMenu.Check("Snipaste Clip Activate Button")
    MNFunctions.Check("Snipaste Clip Activate Button")
    A_TrayMenu.Uncheck("Sharex Clip Activate Button")
    MNFunctions.Uncheck("Sharex Clip Activate Button")
}

sharexscrnclipselect(*)
{
    global clipperchoose, settingsFile
    clipperchoose := 1
    saveSetting("clipperchoose", clipperchoose, settingsFile)
    clippingtoolselect.Uncheck("Snipaste Screen Clipper")
    clippingtoolselect.Check("Sharex Screen Clipper")
    A_TrayMenu.Uncheck("Snipaste Clip Activate Button")
    MNFunctions.Uncheck("Snipaste Clip Activate Button")
    A_TrayMenu.Check("Sharex Clip Activate Button")
    MNFunctions.Check("Sharex Clip Activate Button")
}

ahkscncliprghtbtnselect(*)
{
    global screenclipstate, settingsFile
    screenclipstate := 10
    saveSetting("screenclipstate", screenclipstate, settingsFile)
    ahkbtnselector.Uncheck("Snipaste_ScrnClip - MButton")
    ahkbtnselector.Check("Snipaste_ScrnClip - RButton")
}

ahkscnclipmdlbtnselect(*)
{
    global screenclipstate, settingsFile
    screenclipstate := 01
    saveSetting("screenclipstate", screenclipstate, settingsFile)
    ahkbtnselector.Check("Snipaste_ScrnClip - MButton")
    ahkbtnselector.Uncheck("Snipaste_ScrnClip - RButton")
}

sharexcliprghtbtnselect(*)
{
    global sharexclipstate, settingsFile
    sharexclipstate := 00
    saveSetting("sharexclipstate", sharexclipstate, settingsFile)
    sharexbtnselector.Uncheck("Sharex_ScrnClip - MButton")
    sharexbtnselector.Check("Sharex_ScrnClip - RButton")
}

sharexclipmdlbtnselect(*)
{
    global sharexclipstate, settingsFile
    sharexclipstate := 11
    saveSetting("sharexclipstate", sharexclipstate, settingsFile)
    sharexbtnselector.Check("Sharex_ScrnClip - MButton")
    sharexbtnselector.Uncheck("Sharex_ScrnClip - RButton")
}

tklksfmodeon(*)
{
    global tklmode, settingsFile
    tklmode := 01
    saveSetting("tklmode", tklmode, settingsFile)
    tklksfmodeselector.Check("ON")
    tklksfmodeselector.Uncheck("OFF")
    text := "=> Keyboard with bad Arrow Keys design <=`n-> Special Functionality 4 Tkl Keyboard <-`n`n"
    text .= "i  = Up Arrow`nj  = Left Arrow`nk  = Down Arrow`nl  = Right Arrow`n`n"
    text .= "F1 = Shift`nF2 = Ctrl`nF3 = Alt`nF4 = Win"
    MsgBox(text, "Media_Play_Pause", 0x40000)
}

tklksfmodeoff(*)
{
    global tklmode, settingsFile
    tklmode := 00
    saveSetting("tklmode", tklmode, settingsFile)
    tklksfmodeselector.Uncheck("ON")
    tklksfmodeselector.Check("OFF")
    text := "=> Keyboard with proper Arrow Keys design <=`n-> Back to Normal Keyboard Functionality <-"
    MsgBox(text, "Media_Play_Pause", 0x40000)
}

lectruerecordingopen(*)
{
    Run "C:\DaTa\#5. Music\Lecture_Recordings"
}

exploreedopen(*)
{
    Run "C:\DaTa\E_D"
}

OneNoterunner(*)
{
    Run "ONENOTE"
}

calculatorrunneropen(*)
{
    Run "Calc"
}

notepadrunneropen(*)
{
    Run "Notepad"
}

editscript(*)
{
    SplashTextOn 150, 40, "", "Edit Script"
    Sleep 400
    SplashTextOff
    editwithvscode()
}

appreloader(*)
{
    SplashTextOn 150, 40, "", "Reload App"
    Sleep 400
    SplashTextOff
    Reload
}

appsuspender(*)
{
    Suspend -1
    SoundBeep 500, 500
    If (A_IsSuspended)
    {
        TraySetIcon A_ScriptDir "\bin\icons\suspended.ico"
    }
    Else
    {
        iconchanger()
    }
}

exiterapp(*)
{
    SplashTextOn 150, 40, "", "Exit Script"
    Sleep 400
    SplashTextOff
    ExitApp
}

iconchanger()
{
    global mdastate, fnstate, numpadkeytoggle
    if(mdastate = 0 and fnstate = 0 and numpadkeytoggle = 0)
    {
        TraySetIcon A_ScriptDir "\bin\icons\fndisableone_all.ico"
    }
    else if(mdastate = 0 and fnstate = 1 and numpadkeytoggle = 0)
    {
        TraySetIcon A_ScriptDir "\bin\icons\fnenableone_all.ico"
    }
    else if(mdastate = 1 and fnstate = 0 and numpadkeytoggle = 0)
    {
        TraySetIcon A_ScriptDir "\bin\icons\fndisableone_nox.ico"
    }
    else if(mdastate = 1 and fnstate = 1 and numpadkeytoggle = 0)
    {
        TraySetIcon A_ScriptDir "\bin\icons\fnenableone_nox.ico"
    }
    else if(mdastate = 0 and fnstate = 0 and numpadkeytoggle = 1)
    {
        TraySetIcon A_ScriptDir "\bin\icons\numdisable_fndisableone_all.ico"
    }
    else if(mdastate = 0 and fnstate = 1 and numpadkeytoggle = 1)
    {
        TraySetIcon A_ScriptDir "\bin\icons\numdisable_fnenableone_all.ico"
    }
    else if(mdastate = 1 and fnstate = 0 and numpadkeytoggle = 1)
    {
        TraySetIcon A_ScriptDir "\bin\icons\numdisable_fndisableone_nox.ico"
    }
    else if(mdastate = 1 and fnstate = 1 and numpadkeytoggle = 1)
    {
        TraySetIcon A_ScriptDir "\bin\icons\numdisable_fnenableone_nox.ico"
    }
}

fnnumpadahkkeystate()
{
    global KeyPressCount, fnstate, numpadkeytoggle, settingsFile
    If (KeyPressCount = 1)
    {
        fnstate := !fnstate
        saveSetting("fnstate", fnstate, settingsFile)
        if (fnstate = 1)
        {
            fnkeysenable()
        }
        else if (fnstate = 0)
        {
            fnkeysdisable()
        }
    }
    Else If (KeyPressCount > 1)
    {
        numpadkeytoggle := !numpadkeytoggle
        saveSetting("numpadkeytoggle", numpadkeytoggle, settingsFile)
        if (numpadkeytoggle=0)
        {
            numpadkeysenable()
        }
        else if (numpadkeytoggle=1)
        {
            numpadkeysdisable()
        }
    }
    KeyPressCount := 0
    SetTimer fnnumpadahkkeystate, 0
    ToolTip
}

editwithvscode()
{
    vscodePath := "C:\Users\" . A_UserName . "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    Run vscodePath ' "' A_ScriptFullPath '"'
}

checkahkguisclipclosernmedia()
{
    MouseGetPos ,, &hWnd
    className := WinGetClass("ahk_id " hWnd)
    processName := WinGetProcessName("ahk_id " hWnd)
    windowPID := WinGetPID("ahk_id " hWnd)
    
    if (className = "Qt624QWindowToolSaveBits" and processName = "Snipaste.exe")
    {
        activePID := WinGetPID("A")
        if (activePID = windowPID) {
            MouseClick "Middle"
        }
    }
    else
    {
        mbclickplaypressmonitor4left()
    }
}

;====================================================================================================================
; Special keys for vertical and horizontal scroll
;====================================================================================================================
^+!0::WheelRight
^+!9::WheelLeft

;====================================================================================================================
; Shortcut diversion for PotPlayer
;====================================================================================================================
#HotIf (ChoosePlayer=10)
^+9::Send "^!9"
^+0::Send "^!0"
#HotIf

;====================================================================================================================
; Numpad shortcuts
;====================================================================================================================
#HotIf (numpadkeytoggle=0)

Numpad3::
NumpadPgDn::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    If (KeyPressCount <7)
    {
        ToolTip KeyPressCount " `n1. ScreenshotState `n2. Speed/UnRe_state `n3. Copy/Cut_State `n4. Play/Pause_State `n5. MediaKey_State `n6. Exit"
    }
    SetTimer cKeyPressMonitor, 1000
}

cKeyPressMonitor()
{
    global KeyPressCount, scrstate, spustate, cpcstate, mdastate, mdkystate, ChoosePlayer, settingsFile
    If (KeyPressCount = 1)
    {
        scrstate := !scrstate
        if (scrstate=0)
        {
            Screenshot1orScreenshot2State0()
            MsgBox("Screenshot  - 2 press`nRepeat last - 1 press", "Screenshot Key Press", 0x40000)
        }
        else if (scrstate=1)
        {
            Screenshot1orScreenshot2State1()
            MsgBox("Screenshot  - 1 press`nRepeat last - 2 press", "Screenshot Key Press", 0x40000)
        }
    }
    else if (KeyPressCount = 2)
    {
        spustate := !spustate
        if (spustate=0)
        {
            SpeedUpDownor_State()
        }
        else if (spustate=1)
        {
            UndoRedo_State()
        }
    }
    else if (KeyPressCount = 3)
    {
        cpcstate := !cpcstate
        if (cpcstate=0)
        {
            copycutchoose()
        }
        else if (cpcstate=1)
        {
            copylinkcopycutchoose()
        }
    }
    else if (KeyPressCount = 4)
    {
        mdastate := !mdastate
        if (mdastate = 1)
        {
            SplashTextOn 250, 60, "", "Play/Pause for Bluestack"
            Sleep 400
            SplashTextOff
            MediaPlay4AllorMediaPlay4NoxState1()
        }
        else if (mdastate = 0)
        {
            SplashTextOn 250, 60, "", "Play/Pause for all"
            Sleep 400
            SplashTextOff
            MediaPlay4AllorMediaPlay4NoxState0()
        }
    }
    else if (KeyPressCount = 5)
    {
        mdkystate := !mdkystate
        if (mdkystate=0)
        {
            if(ChoosePlayer=00)
            {
                mk4acDefault()
            }
            else
            {
                mk4acPotPlayer()
            }
        }
        else if (mdkystate=1)
        {
            mediakey4onenotechoose()
        }
    }
    else if (KeyPressCount > 5)
    {
        SplashTextOn 150, 40, "", "Exit Script"
        Sleep 400
        SplashTextOff
        ExitApp
    }
    KeyPressCount := 0
    SetTimer cKeyPressMonitor, 0
    ToolTip
}

NumpadDiv::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount >2)
    {
        ToolTip KeyPressCount
    }
    SetTimer oKeyPressMonitor, 300
}

oKeyPressMonitor()
{
    global KeyPressCount, scrstate
    if (scrstate = 0)
    {
        If (KeyPressCount = 1)
        {
            SendInput "^{PrintScreen}"
        }
        else if (KeyPressCount > 1)
        {
            SendInput "^+/"
        }
    }
    else if (scrstate = 1)
    {
        If (KeyPressCount > 1)
        {
            SendInput "^{PrintScreen}"
        }
        else if (KeyPressCount = 1)
        {
            SendInput "^+/"
        }
    }
    KeyPressCount := 0
    SetTimer oKeyPressMonitor, 0
    ToolTip
}

NumpadMult::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <3)
    {
        ToolTip KeyPressCount
    }
    SetTimer twicepasteplainmonitor, 300
}

twicepasteplainmonitor()
{
    global KeyPressCount, pstpstplnste
    if (pstpstplnste=0)
    {
        SendInput "^v"
    }
    else if (pstpstplnste=1)
    {
        If (KeyPressCount = 1)
        {
            SendInput "^v"
            ToolTip "Paste"
            Sleep 400
        }
        else if (KeyPressCount > 1)
        {
            if WinExist("ahk_exe ONENOTE.EXE")
            {
                WinActivate
                Send "{AppsKey}t"
                ToolTip "Paste Plain(OneNote)"
                Sleep 400
            }
            else
            {
                SendInput "^v"
                ToolTip "Paste"
                Sleep 400
            }
        }
    }
    KeyPressCount := 0
    SetTimer twicepasteplainmonitor, 0
    ToolTip
}

NumpadSub::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <4)
    {
        ToolTip KeyPressCount
    }
    SetTimer vKeyPressMonitor, 550
}

vKeyPressMonitor()
{
    global KeyPressCount, cpcstate
    if (cpcstate = 0)
    {
        If (KeyPressCount = 1)
        {
            SendInput "^c"
            ToolTip "Copy"
            Sleep 400
        }
        else if (KeyPressCount > 1)
        {
            SendInput "^x"
            ToolTip "Cut"
            Sleep 400
        }
    }
    else if (cpcstate = 1)
    {
        If (KeyPressCount = 1)
        {
            if WinExist("ahk_exe ONENOTE.EXE")
            {
                WinActivate
                Send "{AppsKey}p"
                ToolTip "Copy Link to Paragraph(OneNote)"
                Sleep 400
            }
        }
        else if (KeyPressCount = 2)
        {
            SendInput "^c"
            ToolTip "Copy"
            Sleep 400
        }
        else if (KeyPressCount > 2)
        {
            SendInput "^x"
            ToolTip "Cut"
            Sleep 400
        }
    }
    KeyPressCount := 0
    SetTimer vKeyPressMonitor, 0
    ToolTip
}

NumpadAdd::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <3)
    {
        ToolTip KeyPressCount
    }
    SetTimer xKeyPressMonitor, 500
}

Numpad2::Volume_Down
NumpadDown::Volume_Down

Numpad4::backwardbysec
NumpadLeft::backwardbysec

Numpad5::playpausepress
NumpadClear::playpausepress

Numpad6::forwardbysec
NumpadRight::forwardbysec

Numpad1::decundo
NumpadEnd::decundo

Numpad7::incredo
NumpadHome::incredo

Numpad8::Volume_Up
NumpadUp::Volume_Up

Numpad9::
NumpadPgUp::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <3)
    {
        ToolTip KeyPressCount
    }
    SetTimer bKeyPressMonitor, 300
}

bKeyPressMonitor()
{
    global KeyPressCount
    If (KeyPressCount = 1)
    {
        SendInput "^!-"
        ToolTip "Aimp Play/Pause"
        Sleep 400
    }
    else if (KeyPressCount > 1)
    {
        SendInput "^!="
        ToolTip "AIMP Player"
        Sleep 400
    }
    KeyPressCount := 0
    SetTimer bKeyPressMonitor, 0
    ToolTip
}

Numpad0::
NumpadIns::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <5)
    {
        ToolTip KeyPressCount " `n1. Windows Clipboard `n2. Display Settings `n3. Recent Tasks `n4. Menu"
    }
    SetTimer fKeyPressMonitor, 700
}

fKeyPressMonitor()
{
    global KeyPressCount
    If (KeyPressCount = 1)
    {
        SendInput "#v"
        SplashTextOn 210, 40, "", "Windows Clipboard"
        Sleep 500
        SplashTextOff
    }
    else if (KeyPressCount = 2)
    {
        SendInput "^+d"
        SplashTextOn 210, 40, "", "Display Settings"
        Sleep 600
        SplashTextOff
    }
    else if (KeyPressCount = 3)
    {
        SendInput "#{tab}"
        SplashTextOn 210, 40, "", "Recent Tasks"
        Sleep 600
        SplashTextOff
    }
    else if (KeyPressCount > 3)
    {
        MNFunctions.Show()
        SetTimer fKeyPressMonitor, 0
    }
    KeyPressCount := 0
    SetTimer fKeyPressMonitor, 0
    ToolTip
}

NumpadDel::
NumpadDot::
{
    Suspend -1
    SoundBeep 500, 500
    If (A_IsSuspended)
    {
        TraySetIcon A_ScriptDir "\bin\icons\suspended.ico"
    }
    Else
    {
        iconchanger()
    }
}

#HotIf

;====================================================================================================================
; TKL Keyboard mode
;====================================================================================================================
#HotIf (tklmode=01)

` & F1::return
` & F2::return
` & F3::return
` & F4::return

` & h::
{
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P"))
        Send "+{Left}"
    else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P"))
        Send "^{Left}"
    else if (GetKeyState("Alt", "P") || GetKeyState("F3","P"))
        Send "!{Left}"
    else if GetKeyState("F4", "P")
        Send "#{Left}{Esc}"
    else
        Send "{Left}"
}

` & k::
{
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P"))
        Send "+{Up}"
    else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P"))
        Send "^{Up}"
    else if (GetKeyState("Alt", "P") || GetKeyState("F3","P"))
        Send "!{Up}"
    else if GetKeyState("F4", "P")
        Send "#{Up}{Esc}"
    else
        Send "{Up}"
}

` & j::
{
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P"))
        Send "+{Down}"
    else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P"))
        Send "^{Down}"
    else if (GetKeyState("Alt", "P") || GetKeyState("F3","P"))
        Send "!{Down}"
    else if GetKeyState("F4", "P")
        Send "#{Down}{Esc}"
    else
        Send "{Down}"
}

` & l::
{
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P"))
        Send "+{Right}"
    else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P"))
        Send "^{Right}"
    else if (GetKeyState("Alt", "P") || GetKeyState("F3","P"))
        Send "!{Right}"
    else if GetKeyState("F4", "P")
        Send "#{Right}{Esc}"
    else
        Send "{Right}"
}

+`::Send "{~}"
`::`

#HotIf

;====================================================================================================================
; Function keys
;====================================================================================================================
#HotIf (fnstate=1)

F12::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    If (KeyPressCount <7)
    {
        ToolTip KeyPressCount " `n1. ScreenshotState `n2. Speed/UnRe_state `n3. Copy/Cut_State `n4. Play/Pause_State `n5. MediaKey_State `n6. Exit"
    }
    SetTimer cKeyPressMonitor, 1000
}

F6::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <3)
    {
        ToolTip KeyPressCount
    }
    SetTimer oKeyPressMonitor, 300
}

F7::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <4)
    {
        if (pstpstplnste=0)
        {
            ToolTip KeyPressCount " `n1. Paste `n3. Windows Clipboard"
        }
        else if (pstpstplnste=1)
        {
            ToolTip KeyPressCount " `n1. Paste `n2. Paste Plain `n3. Windows Clipboard"
        }
    }
    SetTimer pastewmanager, 500
}

pastewmanager()
{
    global KeyPressCount, pstpstplnste
    If (KeyPressCount = 1)
    {
        SendInput "^v"
    }
    else if (KeyPressCount = 2)
    {
        if WinExist("ahk_exe ONENOTE.EXE") AND pstpstplnste=1
        {
            WinActivate
            Send "{AppsKey}t"
            ToolTip "Paste Plain(OneNote)"
            Sleep 400
        }
        else
        {
            SendInput "^v"
        }
    }
    else if (KeyPressCount > 2)
    {
        SendInput "#v"
        SplashTextOn 210, 40, "", "Windows Clipboard"
        Sleep 500
        SplashTextOff
    }
    KeyPressCount := 0
    SetTimer pastewmanager, 0
    ToolTip
}

F8::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <4)
    {
        ToolTip KeyPressCount
    }
    SetTimer vKeyPressMonitor, 550
}

F9::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <4)
    {
        ToolTip KeyPressCount
    }
    SetTimer xKeyPressMonitor, 500
}

F4::decundo
F5::incredo

F10::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <3)
    {
        ToolTip KeyPressCount
    }
    SetTimer bKeyPressMonitor, 300
}

F11::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <5)
    {
        ToolTip KeyPressCount " `n1. Recent Tasks `n2. F12 `n3. Escape `n4. Menu"
    }
    SetTimer spclonunfykm, 500
}

spclonunfykm()
{
    global KeyPressCount
    If (KeyPressCount = 1)
    {
        SendInput "#{tab}"
        SplashTextOn 210, 40, "", "Recent Tasks"
        Sleep 600
        SplashTextOff
    }
    else if (KeyPressCount = 2)
    {
        SendInput "{F12}"
        SplashTextOn 210, 40, "", "F12"
        Sleep 500
        SplashTextOff
    }
    else if (KeyPressCount = 3)
    {
        SendInput "{Esc}"
        SplashTextOn 150, 40, "", "Escape"
        Sleep 500
        SplashTextOff
    }
    else if (KeyPressCount > 3)
    {
        MNFunctions.Show()
        SetTimer spclonunfykm, 0
    }
    KeyPressCount := 0
    SetTimer spclonunfykm, 0
    ToolTip
}

F1::playpausepress
F2::backwardbysec
F3::forwardbysec

#HotIf

;====================================================================================================================
; Navigation keys to Media Control
;====================================================================================================================
#HotIf (spclnavbutm=01)

RAlt::playpausepress
Left::backwardbysec
Right::forwardbysec
Up::decundo
Down::incredo

#HotIf

;====================================================================================================================
; CapsLock, NumLock, ScrollLock indicators
;====================================================================================================================
~CapsLock::
{
    cste := GetKeyState("CapsLock", "T")
    if (cste=1)
    {
        SplashTextOn 200, 50, "", "CapsLock-On"
        Sleep 500
        SplashTextOff
    }
    else
    {
        SplashTextOn 200, 50, "", "CapsLock-Off"
        Sleep 500
        SplashTextOff
    }
}

~ScrollLock::
{
    sste := GetKeyState("ScrollLock", "T")
    if (sste=1)
    {
        SplashTextOn 200, 50, "", "ScrollLock-On"
        Sleep 500
        SplashTextOff
    }
    else
    {
        SplashTextOn 200, 50, "", "ScrollLock-Off"
        Sleep 500
        SplashTextOff
    }
}

;====================================================================================================================
; Ultimate state changer on pause/break key press
;====================================================================================================================
SC16C::
Pause::
{
    global KeyPressCount
    If (KeyPressCount > 0)
    {
        KeyPressCount +=1
    }
    else
    {
        KeyPressCount :=1
    }
    if (KeyPressCount <3)
    {
        ToolTip KeyPressCount " `n1. Fn AHK Key State `n2. Numpad AHK Key State"
    }
    SetTimer fnnumpadahkkeystate, 500
}

;====================================================================================================================
; Dedicated copilot key change to alt
;====================================================================================================================
*F23::
{
    Send "{Alt down}"
    KeyWait "F23"
    Send "{Alt up}"
}