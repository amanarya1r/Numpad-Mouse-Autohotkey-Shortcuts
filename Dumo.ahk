#SingleInstance, Force
#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%

; Path to your settings file
settingsFile := "settings.txt"
; ----------------------------
; Functions to manage settings
; ----------------------------

loadSettings(file) {
    global
    if !FileExist(file) {
        MsgBox, 16, Error, Settings file not found: %file%
        ExitApp
    }

    Loop, Read, %file%
    {
        line := A_LoopReadLine
        if line contains =
        {
            key := Trim(StrSplit(line, "=")[1])
            val := Trim(StrSplit(line, "=")[2])
            %key% := val
        }
    }
}

saveSetting(key, val, file) {
    newContent := ""
    found := false

    Loop, Read, %file%
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

    FileDelete, %file%
    FileAppend, %newContent%, %file%
}

; Load all settings into memory
loadSettings(settingsFile)

;======================================================================================
;the above script is tweaked and you can only copy to clipboard on scroll up and autocopy to clipbaord function is disabled
;to change it just change value of clip from 0 to 1 and also comment the line 679 ;this line is of function checkahkguisclip()
;to discard the image delete it by physical keyboard or right click menu
;======================================================================================
;submenu for the menu and tray menu
Menu, mediakey4allchoose, Add, Media_Key (default), mk4acDefault
Menu, mediakey4allchoose, Add, Media_Key (PotPlayer), mk4acPotPlayer
Menu, mediakey4allchoose, Add, Media_Key (Opera), mk4acOpera
if ((mdkystate == 0) && (ChoosePlayer == 00)){
	Menu, mediakey4allchoose, check, Media_Key (default)
    Menu, mediakey4allchoose, uncheck, Media_Key (PotPlayer)
	Menu, mediakey4allchoose, uncheck, Media_Key (Opera)
} else if ((mdkystate == 0) && (ChoosePlayer == 10)){
	Menu, mediakey4allchoose, uncheck, Media_Key (default)
    Menu, mediakey4allchoose, check, Media_Key (PotPlayer)
	Menu, mediakey4allchoose, uncheck, Media_Key (Opera)
} else if ((mdkystate == 0) && (ChoosePlayer == 11)){
	Menu, mediakey4allchoose, uncheck, Media_Key (default)
    Menu, mediakey4allchoose, uncheck, Media_Key (PotPlayer)
	Menu, mediakey4allchoose, check, Media_Key (Opera)
}
;---------------------------------------------------------------------------------------
Menu, sharexshotstate, Add, ScrnShot - 1 || ReptShot - 2, Screenshot1orScreenshot2State1
Menu, sharexshotstate, Add, ScrnShot - 2 || ReptShot - 1, Screenshot1orScreenshot2State0
if (scrstate == 0){
	Menu, sharexshotstate, uncheck, ScrnShot - 1 || ReptShot - 2
	Menu, sharexshotstate, check, ScrnShot - 2 || ReptShot - 1
} else if(scrstate == 1) {
	Menu, sharexshotstate, check, ScrnShot - 1 || ReptShot - 2
	Menu, sharexshotstate, uncheck, ScrnShot - 2 || ReptShot - 1
}
;---------------------------------------------------------------------------------------
Menu, speedunrestate, Add, SpeedUp || SpeedDown, SpeedUpDownor_State
Menu, speedunrestate, Add, Redo || Undo, UndoRedo_State
if (spustate == 0){
	Menu, speedunrestate, check, SpeedUp || SpeedDown
	Menu, speedunrestate, uncheck, Redo || Undo
} else if (spustate == 1) {
	Menu, speedunrestate, uncheck, SpeedUp || SpeedDown
	Menu, speedunrestate, check, Redo || Undo
}
;---------------------------------------------------------------------------------------; copycut, copylinkcopycut 4 onenote
Menu, copycutstate, Add, Copy || Cut, copycutchoose
Menu, copycutstate, Add, CopyLinkOneNote || Copy || Cut, copylinkcopycutchoose
if (cpcstate == 0){
	Menu, copycutstate, check, Copy || Cut
	Menu, copycutstate, uncheck, CopyLinkOneNote || Copy || Cut
} else if (cpcstate == 1) {
	Menu, copycutstate, uncheck, Copy || Cut
	Menu, copycutstate, check, CopyLinkOneNote || Copy || Cut
}
;---------------------------------------------------------------------------------------; paste, plain paste 4 onenote
Menu, pastestate, Add, Paste, pasteon1press 
Menu, pastestate, Add, 1. Paste || 2. Paste Plain OneNote, pasteon1presspasteplain2press
if (pstpstplnste == 0){
	Menu, pastestate, check, Paste
	Menu, pastestate, uncheck, 1. Paste || 2. Paste Plain OneNote
} else if (pstpstplnste == 1){
	Menu, pastestate, uncheck, Paste
	Menu, pastestate, check, 1. Paste || 2. Paste Plain OneNote
}
;---------------------------------------------------------------------------------------; media player for bluestack or otherwise
Menu, playpausestate, Add, Play Pause 4 All, MediaPlay4AllorMediaPlay4NoxState0
Menu, playpausestate, Add, Play Pause 4 BlueStacks, MediaPlay4AllorMediaPlay4NoxState1
if (mdastate == 0){
	Menu, playpausestate, check, Play Pause 4 All
	Menu, playpausestate, uncheck, Play Pause 4 BlueStacks
} else if (mdastate == 1){
	Menu, playpausestate, uncheck, Play Pause 4 All
	Menu, playpausestate, check, Play Pause 4 BlueStacks
}
;---------------------------------------------------------------------------------------; media key for onenote or all other application
Menu, mkeyonestate, Add, Media_Key 4 All, :mediakey4allchoose
Menu, mkeyonestate, Add, Media_Key 4 OneNote, mediakey4onenotechoose
if (mdkystate == 1){
	Menu, mkeyonestate, uncheck, Media_Key 4 All
	Menu, mkeyonestate, check, Media_Key 4 OneNote
} else if (mdkystate == 0){
	Menu, mkeyonestate, check, Media_Key 4 All
	Menu, mkeyonestate, uncheck, Media_Key 4 OneNote
}
;---------------------------------------------------------------------------------------;fn ahk key state
Menu, fnkeystate, Add, Enable, fnkeysenable
Menu, fnkeystate, Add, Disable, fnkeysdisable
if (fnstate == 0){
	Menu, fnkeystate, check, Disable
	Menu, fnkeystate, uncheck, Enable
} else if (fnstate == 1){
	Menu, fnkeystate, uncheck, Disable
	Menu, fnkeystate, check, Enable
}
;---------------------------------------------------------------------------------------;Numpad ahk key state
Menu, numpadkeystate, Add, Enable, numpadkeysenable
Menu, numpadkeystate, Add, Disable, numpadkeysdisable
if (numpadkeytoggle == 1){
	Menu, numpadkeystate, check, Disable
	Menu, numpadkeystate, uncheck, Enable
} else if (numpadkeytoggle == 0){
	Menu, numpadkeystate, uncheck, Disable
	Menu, numpadkeystate, check, Enable
}
;---------------------------------------------------------------------------------------:Mouse scroll wheel state changer
Menu, scrolledstate, Add, WheelUP - ScrollUp || WheelDown - ScrollDown, wheelscrollupdownchoose
Menu, scrolledstate, Add, WheelUp - RightArrow || WheelDown - LeftArrow, wheelrightleftarrowchoose
if (whelscrlfn == 0){
	Menu, scrolledstate, check, WheelUP - ScrollUp || WheelDown - ScrollDown
    Menu, scrolledstate, uncheck, WheelUp - RightArrow || WheelDown - LeftArrow
} else if (whelscrlfn == 1){
	Menu, scrolledstate, uncheck, WheelUP - ScrollUp || WheelDown - ScrollDown
    Menu, scrolledstate, check, WheelUp - RightArrow || WheelDown - LeftArrow
}
;----------------------------------------------------------------------------------------;Mouse middle button state changer
Menu, mousemdlbtnstate, Add, Enable, mousemdlbtnstatedisable
Menu, mousemdlbtnstate, Add, Disable, mousemdlbtnstateenable
if (mbtnstate == 0){
	Menu, mousemdlbtnstate, uncheck, Enable
	Menu, mousemdlbtnstate, check, Disable
} else if (mbtnstate == 1){
	Menu, mousemdlbtnstate, check, Enable
	Menu, mousemdlbtnstate, uncheck, Disable
}
;----------------------------------------------------------------------------------------;Mouse extra button state changer
Menu, mousextrbtnstate, Add, XBttn1 - LeftArrow || XBttn2 - RightArrow, xtrbttnlrarw
Menu, mousextrbtnstate, Add
Menu, mousextrbtnstate, Add, XBttn1 - BackWard5s || XBttn2 - Forward5s, xtrbttnfb5s
Menu, mousextrbtnstate, Add
Menu, mousextrbtnstate, Add, XBttn1 - WheelRight || XBttn2 - WheelLeft, xtrbttnwrwl
if (xbuttonstate == 01){
	Menu, mousextrbtnstate, check, XBttn1 - LeftArrow || XBttn2 - RightArrow
	Menu, mousextrbtnstate, uncheck, XBttn1 - BackWard5s || XBttn2 - Forward5s
	Menu, mousextrbtnstate, uncheck, XBttn1 - WheelRight || XBttn2 - WheelLeft
} else if (xbuttonstate == 10){
	Menu, mousextrbtnstate, uncheck, XBttn1 - LeftArrow || XBttn2 - RightArrow
	Menu, mousextrbtnstate, check, XBttn1 - BackWard5s || XBttn2 - Forward5s
	Menu, mousextrbtnstate, uncheck, XBttn1 - WheelRight || XBttn2 - WheelLeft
} else if (xbuttonstate == 11){
	Menu, mousextrbtnstate, uncheck, XBttn1 - LeftArrow || XBttn2 - RightArrow
	Menu, mousextrbtnstate, uncheck, XBttn1 - BackWard5s || XBttn2 - Forward5s
	Menu, mousextrbtnstate, check, XBttn1 - WheelRight || XBttn2 - WheelLeft
}
;----------------------------------------------------------------------------------------;Screen clipper tool selecter
Menu, clippingtoolselect, Add, AHK Screen Clipper, ahkscrnclipselect
Menu, clippingtoolselect, Add, Sharex Screen Clipper, sharexscrnclipselect
; condition statment is int bottom of Mnfunction
;----------------------------------------------------------------------------------------;ahk screen clipper activating button selector
Menu, ahkbtnselector, Add, AHK_ScrnClip - MButton, ahkscnclipmdlbtnselect
Menu, ahkbtnselector, Add, AHK_ScrnClip - RButton, ahkscncliprghtbtnselect
if (screenclipstate == 10){
	Menu, ahkbtnselector, uncheck, AHK_ScrnClip - MButton
    Menu, ahkbtnselector, check, AHK_ScrnClip - RButton
} else if (screenclipstate == 01){
	Menu, ahkbtnselector, check, AHK_ScrnClip - MButton
    Menu, ahkbtnselector, uncheck, AHK_ScrnClip - RButton
}
;----------------------------------------------------------------------------------------;sharex screen clipper activating button selector
Menu, sharexbtnselector, Add, Sharex_ScrnClip - MButton, sharexclipmdlbtnselect
Menu, sharexbtnselector, Add, Sharex_ScrnClip - RButton, sharexcliprghtbtnselect
if (sharexclipstate == 00){
	Menu, sharexbtnselector, uncheck, Sharex_ScrnClip - MButton
    Menu, sharexbtnselector, check, Sharex_ScrnClip - RButton
} else if (sharexclipstate == 11){
	Menu, sharexbtnselector, check, Sharex_ScrnClip - MButton
    Menu, sharexbtnselector, uncheck, Sharex_ScrnClip - RButton
}
;----------------------------------------------------------------------------------------;tkl keyboard special keyboard function on or off
Menu, tklksfmodeselector, Add, ON, tklksfmodeon
Menu, tklksfmodeselector, Add, OFF, tklksfmodeoff
if (tklmode == 01){
	Menu, tklksfmodeselector, check, ON
    Menu, tklksfmodeselector, uncheck, OFF
} else if (tklmode == 00){
	Menu, tklksfmodeselector, uncheck, ON
    Menu, tklksfmodeselector, check, OFF
}
;----------------------------------------------------------------------------------------

;======================================================================================
;Menu, Tray icons, menu and texts
Menu, Tray, NoStandard ;Pause reload and supsend will be removed 
Menu, Tray, Tip, Dumo - All Rounder
Menu, Tray, Icon, %A_ScriptDir%\bin\icons\fnenableone_all.ico
Menu, Tray, Add, Screenshot State, :sharexshotstate
Menu, Tray, Add, SpeedUpDown_UnRe State, :speedunrestate
Menu, Tray, Add
Menu, Tray, Add, CopyCut/CopylinkCopyCut State, :copycutstate
Menu, Tray, Add, Paste/PastePastePlain State, :pastestate
Menu, Tray, Add
Menu, Tray, Add, Play Pause State, :playpausestate
;Menu, Tray, Add, Bluestack Fullscreen/Maximize Mode, Bluestackflscmxmmd
Menu, Tray, Add, Media Key State, :mkeyonestate
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Fn AHK Keys State, :fnkeystate
Menu, Tray, Add
Menu, Tray, Add, Numpad AHK Kyes State, :numpadkeystate
Menu, Tray, Add
Menu, Tray, Add, ScrollWheel - State, :scrolledstate
Menu, Tray, Add, Mouse_Middle_Button State, :mousemdlbtnstate
Menu, Tray, Add, Mouse_Xtra_Buttons State, :mousextrbtnstate
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Clipping Tool, :clippingtoolselect
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, AHK Clip Activate Button, :ahkbtnselector
Menu, Tray, Check, AHK Clip Activate Button
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Sharex Clip Activate Button, :sharexbtnselector
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, TKL Keyboard ijkl => ULDR, :tklksfmodeselector
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Lecture Recordings, lectruerecordingopen
Menu, Tray, Add, Explore E_D, exploreedopen
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, OneNote, OneNoterunner
Menu, Tray, Add, Calculator, calculatorrunneropen
Menu, Tray, Add, Notepad, notepadrunneropen
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Edit App Script, editscript
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Reload App, appreloader
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Suspend App, appsuspender
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Exit App, exiterapp

;=============================================================================================
;context menu shower 
Menu, MNFunctions, Add, Screenshot State, :sharexshotstate
Menu, MNFunctions, Add, SpeedUpDown_UnRe State, :speedunrestate
Menu, MNFunctions, Add
Menu, MNFunctions, Add, CopyCut/CopylinkCopyCut State, :copycutstate
Menu, MNFunctions, Add, Paste/PastePastePlain State, :pastestate
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Play Pause State, :playpausestate
;Menu, MNFunctions, Add, Bluestack Fullscreen/Maximize Mode, Bluestackflscmxmmd
Menu, MNFunctions, Add, Media Key State, :mkeyonestate
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Fn Keys State, :fnkeystate
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Numpad AHK Kyes State, :numpadkeystate
Menu, MNFunctions, Add
Menu, MNFunctions, Add, ScrollWheel - State, :scrolledstate
Menu, MNFunctions, Add, Mouse_Middle_Button State, :mousemdlbtnstate
Menu, MNFunctions, Add, Mouse_Xtra_Buttons State, :mousextrbtnstate
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Clipping Tool, :clippingtoolselect
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, AHK Clip Activate Button, :ahkbtnselector
Menu, MNFunctions, Check, AHK Clip Activate Button
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Sharex Clip Activate Button, :sharexbtnselector
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, TKL Keyboard ijkl => ULDR, :tklksfmodeselector
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Lecture Recordings, lectruerecordingopen
Menu, MNFunctions, Add, Explore E_D, exploreedopen
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, OneNote, OneNoterunner
Menu, MNFunctions, Add, Calculator, calculatorrunneropen
Menu, MNFunctions, Add, Notepad, notepadrunneropen
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Edit App Script, editscript
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Reload App, appreloader
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Suspend App, appsuspender
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Exit App, exiterapp

;----------------------------------------------------------------------------------------
; universal clipper tool menu select function
if (clipperchoose == 0){
	Menu, clippingtoolselect, check, AHK Screen Clipper
	Menu, clippingtoolselect, uncheck, Sharex Screen Clipper
	Menu, Tray, check, AHK Clip Activate Button
	Menu, MNFunctions, check, AHK Clip Activate Button
	Menu, Tray, uncheck, Sharex Clip Activate Button
	Menu, MNFunctions, uncheck, Sharex Clip Activate Button
} else if (clipperchoose == 1){
	Menu, clippingtoolselect, uncheck, AHK Screen Clipper
	Menu, clippingtoolselect, check, Sharex Screen Clipper
	Menu, Tray, uncheck, AHK Clip Activate Button
	Menu, MNFunctions, uncheck, AHK Clip Activate Button
	Menu, Tray, check, Sharex Clip Activate Button
	Menu, MNFunctions, check, Sharex Clip Activate Button
}
;----------------------------------------------------------------------------------------
;=============================================================================================

SetBatchLines,-1
SetWinDelay,-1
;~ #Include Gdip.ahk
;~ #Include Tesseract.ahk

if((A_PtrSize=8&&A_IsCompiled="")||!A_IsUnicode){ ;32 bit=4  ;64 bit=8
    SplitPath,A_AhkPath,,dir
    if(!FileExist(correct:=dir "\AutoHotkeyU32.exe")){
	    MsgBox error
	    ExitApp
    }
    Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
    ExitApp
    return
}

OnMessage(0x0204, "WM_RBUTTONDOWN")
WM_RBUTTONDOWN()
{
 Menu, MyMenu, Add, Copy to Clipboard, MenuHandler
 Menu, MyMenu, Add, Open in Paint.net, MenuHandler
 Menu, MyMenu, Add, Open in PDF /does not work, MenuHandler
 Menu, MyMenu, Add, Send by Email /does not work, MenuHandler
 Menu, MyMenu, Add, OCR, MenuHandler
 Menu, MyMenu, Add, Save, MenuHandler
 Menu, MyMenu, Add, Close, MenuHandler
 Menu, MyMenu, Show
}

OnMessage(0x0203, "checkahkguisclipcloser")
;OnMessage(0x0203, "WM_LBUTTONDBLCLK") ;double click to downsize. Double click again to resize.
WM_LBUTTONDBLCLK() { 
    
   global
    
   WinGet, TempID, , A
   WinGetPos, , , Temp_Width, Temp_Height, A 
   
   If (Temp_Width = 75 && Temp_Height = 75) {
      WinMove, A, , , , % %TempID%_Width, % %TempID%_Height
   } else {
   %TempID%_Width := Temp_Width
   %TempID%_Height := Temp_Height
   WinMove, A, , , , 75, 75
   }      

}

;====================================================================================================================
;====================================================================================================================
;Hotkey to select area using middle mouse button for screen clipping and media play pause and on double click on it
;====================================================================================================================
#IF (mbtnstate=0 AND screenclipstate=01 AND clipperchoose=0)
; Variables
LongPressThreshold := 300  ; Adjust the threshold for long press (300 milliseconds)
MiddleMouseDown := false
MiddleMouseDownTime := 0
ClickCount := 0

; Middle mouse button down
MButton::
    if (!MiddleMouseDown) {
        MiddleMouseDown := true
        MiddleMouseDownTime := A_TickCount
        SetTimer, CheckMiddleMouseLongPress, 10
    }
return

; Middle mouse button up
MButton Up::
    SetTimer, CheckMiddleMouseLongPress, Off
    if (MiddleMouseDown) {
        MiddleMouseDown := false
        ; If the button was released before the long press threshold, treat it as a short press
        if ((A_TickCount - MiddleMouseDownTime) < LongPressThreshold) {
            ClickCount := (ClickCount ? ClickCount + 1 : 1)
            if (ClickCount < 3)
				{
					Tooltip, %ClickCount%
				}
            SetTimer, mbclickmonitor4left, 300
        }
    }
return

; Timer function to check for a long press
CheckMiddleMouseLongPress:
    if (MiddleMouseDown && (A_TickCount - MiddleMouseDownTime >= LongPressThreshold)) {
        ; Long press detected
        SCW_ScreenClip2Win(clip:=0) ; set to 1 to auto-copy to clipboard ;this function do copy but always with border even if you select without border so it's better not to select it set 0
        WinActivate, ScreenClippingWindow ahk_class AutoHotkeyGUI ;set clip:=0 bcz if you put 1 it will always fail 
        MiddleMouseDown := false  ; Reset the state to avoid multiple triggers
        SetTimer, CheckMiddleMouseLongPress, Off
    }
return

; Ensure the script doesn't terminate prematurely
#InstallKeybdHook
#InstallMouseHook

~WheelUp::checkahkguisclip()
~WheelDown::checkahkguisclipnocr() ;tesseract ocr

#IF 
;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

;====================================================================================================================
;====================================================================================================================
;Hotkey to select area using right mouse button and mouse middle button for play and pause when single pressed
;menu when doubled pressed
;====================================================================================================================

#IF (mbtnstate=0 AND screenclipstate=10 AND clipperchoose=0)

; Time threshold to distinguish between a hold and a click (in milliseconds)
holdThreshold := 300

; Variables to manage the state
isHolding := false

; Right mouse button down event
RButton::
    isHolding := false
    SetTimer, CheckHold, % -holdThreshold
    return

; Timer to check if the button is held
CheckHold:
    if (GetKeyState("RButton", "P")) {
        isHolding := true
        SCW_ScreenClip2Win(clip:=0) ; set to 1 to auto-copy to clipboard
        WinActivate, ScreenClippingWindow ahk_class AutoHotkeyGUI 
		SetTimer, CheckHold, off ;to avoid multiple instances
    }
    return

; Right mouse button up event
RButton up::
    SetTimer, CheckHold, Off
    if (!isHolding) {
        ; Send the normal right-click
        Click, Right
    }
    return

; Middle mouse button event
MButton::
    ; Middle mouse button event
    If (ClickCount > 0)
        ClickCount += 1
    else
        ClickCount := 1
    If (ClickCount < 3)
        Tooltip, %ClickCount%
    SetTimer, mbclickmonitor4left, 300
    ; Send the middle mouse button click
    ; Click, Middle
    return

; Monitor for middle mouse button click
~WheelUp::checkahkguisclip()
~WheelDown::checkahkguisclipnocr()

#IF
;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

;====================================================================================================================
;====================================================================================================================
;Hotkey for middle mouse button to activate sharex and double click on it to give menu and single click to play pause
;media
;====================================================================================================================
#IF (mbtnstate=0 AND sharexclipstate=11 AND clipperchoose=1)
;; Define a variable to track the time when the middle mouse button is pressed
global MiddleMouseDownTime := 0

; Define the hotkey for detecting the middle mouse button press
MButton::
    ; Record the time when the middle mouse button is pressed
    MiddleMouseDownTime := A_TickCount
    ; Set a timer to check for a long press
    SetTimer, CheckLongPress, 300
    return

; Define the subroutine to check for a long press
CheckLongPress:
    ; If the middle mouse button is still held down after 300ms
    if (GetKeyState("MButton", "P")) {
        ; Send the desired input for long press
        SendInput, ^+/
    }
    ; Reset the variable tracking the press time
    MiddleMouseDownTime := 0
    ; Turn off the timer
    SetTimer, CheckLongPress, Off
    return

; Define the hotkey for releasing the middle mouse button
MButton up::
    ; Calculate the duration the middle mouse button was held down
    Duration := A_TickCount - MiddleMouseDownTime
    ; If the duration is less than 300ms, it's a quick click
    if (Duration < 300) {
        ; SetTimer example, replace it with your own action
		    ; Middle mouse button event
			If (ClickCount > 0)
				ClickCount += 1
			else
				ClickCount := 1
			If (ClickCount < 3)
				Tooltip, %ClickCount%
        SetTimer, mbclickmonitor, 300
    }
    return

#IF
;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

;====================================================================================================================
;====================================================================================================================
;Hotkey for right mouse button to activate sharex on long press and double click mouse middle button to give menu 
;single click on louse middle button to play pause media 
;====================================================================================================================
#IF (mbtnstate=0 AND sharexclipstate=00 AND clipperchoose=1)

; Time threshold to distinguish between a hold and a click (in milliseconds)
holdThresholdli := 300

; Variables to manage the state
isHoldingki := false

; Right mouse button down event
RButton::
    isHoldingki := false
    SetTimer, CheckHoldpi, % -holdThresholdli
    return

; Timer to check if the button is held
CheckHoldpi:
    if (GetKeyState("RButton", "P")) {
        isHoldingki := true
        SendInput ^+/ ;sharex screenshot 
		SetTimer, CheckHoldpi, off ;this will avoid creating two instaces of sharex screenshot
    }
    return

; Right mouse button up event
RButton up::
    SetTimer, CheckHoldpi, Off
    if (!isHoldingki) {
        ; Send the normal right-click
        Click, Right
    }
    return

; Middle mouse button event
MButton::
    ; Middle mouse button event
    If (ClickCount > 0)
        ClickCount += 1
    else
        ClickCount := 1
    If (ClickCount < 3)
        Tooltip, %ClickCount%
    SetTimer, mbclickmonitor, 300
    ; Send the middle mouse button click
    Click, Middle
    return

#IF
;00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

;Mouse wheel function wheelup=right_arrow  wheeldown=left
#IF (whelscrlfn=1)
{
    WheelUp::Right
    WheelDown::Left
}
#IF

;Mouse extra buttons function depending on xbuttonstate
#IF (xbuttonstate = 11) ;wheel right and left for horizontal scroll
{
	XButton1::WheelRight
	XButton2::WheelLeft
}
#IF

#IF (xbuttonstate = 01) ;left and right arrow key in vim and bash editing
{
	XButton1::Left
	XButton2::Right
}
#IF

#IF (xbuttonstate = 10) ;backward and forward for mediaplayer specially for lectures
{
	XButton1::
	gosub, backwardbysec
	return

	XButton2::
	gosub, forwardbysec
	return
}
#IF
;============================================================================================================
;============================================================================================================
;current states of key always on top of script
; Timer function to monitor multiple clicks ||||| Most important gosub never delete
mbclickmonitor:
    If (ClickCount = 1) 
		{
        	;SendInput {Media_Play_Pause}
			;if winexist("ahk_exe ONENOTE.EXE") AND (mdkystate=1)
			if (mdastate=0) and (mdkystate=1)
				{
					;WinActivate
					SendInput, ^+6
				}
			else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=10)
				{
					SendInput, ^!6
				}
			else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=11)
				{
					SendInput, !+6
				}
			else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
				{
					SendInput, {Media_Play_Pause} 
				}
			else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe") 
				{
					WinActivate, BlueStacks App Player
					SendInput, s
				}
			else
				{
					SendInput, {Media_Play_Pause} 
				}
			return
    	} 
	else if (ClickCount > 1) 
		{
    	    Menu, MNFunctions, Show
			;MNFunctionmenu()
        	;Menu, MNFunctions, DeleteAll
			SetTimer, mbclickmonitor, Off
    	}
    ClickCount := 0
    SetTimer, mbclickmonitor, Off
    Tooltip,
return

mbclickmonitor4left:
    If (ClickCount = 1) 
		{
        	checkahkguisclipclosernmedia()
    	} 
	else if (ClickCount > 1) 
		{
    	    Menu, MNFunctions, Show
        	;Menu, MNFunctions, DeleteAll
			SetTimer, mbclickmonitor, Off
    	}
    ClickCount := 0
    SetTimer, mbclickmonitor4left, Off
    Tooltip,
return

mbclickplaypressmonitor4left:
;if winexist("ahk_exe ONENOTE.EXE") AND (mdkystate=1)
if (mdastate=0) and (mdkystate=1)
	{
		;WinActivate
		SendInput, ^+6
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=10)
	{
		SendInput, ^!6
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=11)
	{
		SendInput, !+6
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
	{
		SendInput, {Media_Play_Pause} 
	}
else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe") 
	{
		WinActivate, BlueStacks App Player
		SendInput, s
	}
else
	{
		SendInput, {Media_Play_Pause} 
	}
return

xKeyPressMonitor:
If (KeyPressCount = 1)
	{
		If (recstartv = 1)
            {
                recstartv := !recstartv
                recpausev := 0
                SendInput, ^+{Space}
				; Retrieve files in a certain directory sorted by modification date:
				FileList :=  "" ; Initialize to be blank
				; Create a list of those files consisting of the time the file was modified and the file path separated by tab
				Loop, C:\Users\amana\Music\Lecture Recordings\*.mp3*
					FileList .= A_LoopFileTimeModified . "`t" . A_LoopFileLongPath . "`n"
				Sort, FileList, R  ;   ; Sort by time modified in reverse order
				Loop, Parse, FileList, `n
					{
						If (A_LoopField = "") ; omit the last linefeed (blank item) at the end of the list.
							Continue
						StringSplit, FileItem, A_LoopField, %A_Tab%  ; Split into two parts at the tab char
						; FileItem1 is FileTimeModified und FileItem2 is FileName
							ClipBoardSetFiles(FileItem2)
							Break
					}

				ClipboardSetFiles(FilesToSet, DropEffect := "Copy") {
					; FilesToSet - list of fully qualified file pathes separated by "`n" or "`r`n"
					; DropEffect - preferred drop effect, either "Copy", "Move" or "" (empty string)
					Static TCS := A_IsUnicode ? 2 : 1 ; size of a TCHAR
					Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
					Static DropEffects := {1: 1, 2: 2, Copy: 1, Move: 2}
					; -------------------------------------------------------------------------------------------------------------------
					; Count files and total string length
					TotalLength := 0
					FileArray := []
					Loop, Parse, FilesToSet, `n, `r
					{
						If (Length := StrLen(A_LoopField))
							FileArray.Push({Path: A_LoopField, Len: Length + 1})
						TotalLength += Length
					}
					FileCount := FileArray.Length()
					If !(FileCount && TotalLength)
						Return False
					; -------------------------------------------------------------------------------------------------------------------
					; Add files to the clipboard
					If DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) && DllCall("EmptyClipboard") {
						; HDROP format ---------------------------------------------------------------------------------------------------
						; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
						hDrop := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20 + (TotalLength + FileCount + 1) * TCS, "UPtr")
						pDrop := DllCall("GlobalLock", "Ptr" , hDrop)
						Offset := 20
						NumPut(Offset, pDrop + 0, "UInt")         ; DROPFILES.pFiles = offset of file list
						NumPut(!!A_IsUnicode, pDrop + 16, "UInt") ; DROPFILES.fWide = 0 --> ANSI, fWide = 1 --> Unicode
						For Each, File In FileArray
							Offset += StrPut(File.Path, pDrop + Offset, File.Len) * TCS
						DllCall("GlobalUnlock", "Ptr", hDrop)
						DllCall("SetClipboardData","UInt", 0x0F, "UPtr", hDrop) ; 0x0F = CF_HDROP
						; Preferred DropEffect format ------------------------------------------------------------------------------------
						If (DropEffect := DropEffects[DropEffect]) {
							; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
							; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
							hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr")
							pMem := DllCall("GlobalLock", "Ptr", hMem)
							NumPut(DropEffect, pMem + 0, "UChar")
							DllCall("GlobalUnlock", "Ptr", hMem)
							DllCall("SetClipboardData", "UInt", PreferredDropEffect, "Ptr", hMem)
						}
						DllCall("CloseClipboard")
						Return True
					}
					Return False
				} 
                SplashTextOn,210,40,, Recording Finshed 
		        ;audiotext := "`n Recording Finished `n "
				audiotext := "Recording Finished"
				Sleep 1000 
                SplashTextOff  
				SetTimer, FollowMouse, Off
				ToolTip        
            }
        else 
            {
                recstartv := !recstartv
                recpausev := 0
                SendInput, ^+{Space}
				SplashTextOn,210,40,, Recording Started 
		        Sleep 1000
                SplashTextOff
				;ToolTip, % "`n Recording `n "
				;audiotext := "`n Recording `n "
				audiotext := "Recording"
				SetTimer, FollowMouse, 10
            }
	}
else if (KeyPressCount > 1)
    {
        If (recstartv = 1 AND recpausev = 1)
            {
                SendInput, ^{Space}
                recpausev := 0
                SplashTextOn,210,40,,Recording Continue
                Sleep 1000
                SplashTextOff
				;audiotext := "`n Recording Continue `n "
				audiotext := "Recording Continue"
				;SetTimer, FollowMouse, 10
            }
        else If (recstartv = 1 AND recpausev = 0)
            {
                SendInput, ^{Space}
                recpausev := 1
                SplashTextOn,210,40,,Recording Paused
                Sleep 1000
                SplashTextOff
				;audiotext := "`n Recording Pause `n "
				audiotext := "Recording Paused"
				;SetTimer, FollowMouse, 10
            }
        else If (recstartv = 0)
            {
                ToolTip 
				SplashTextOn,250,40,,Recording Not Started
                ;ToolTip, % "`n Recording Not Started `n "
				ToolTip,    Recording Not Started
                Sleep 1000
				ToolTip
                SplashTextOff
            }
        else 
            {
                SplashTextOn,250,40,,Recording Not Started
				;ToolTip, % "`n Recording Not Started `n "
				ToolTip,    Recording Not Started
                Sleep 1000
				ToolTip
                SplashTextOff
            }
    }
KeyPressCount := 0
SetTimer, xKeyPressMonitor, Off
;Tooltip,
return

FollowMouse:
    MouseGetPos, x, y
    ToolTip, % audiotext, x+20, y+20
return
;/////////////////////////////////////////////////////////////////////////////////////////////////;Backward, Forward, PlayPause

;---------------------------------------------------------
;special keys for vertical and horizontal scroll
;---------------------------------------------------------
^+!0::WheelRight
return
^+!9::WheelLeft
return
;---------------------------------------------------------

backwardbysec: ;numpad4, numpadleft, f1 :backward
if (mdastate=0 and ChoosePlayer=00)
	{
		SendInput, ^+9
	}
else if (mdastate=0 and ChoosePlayer=10)
	{
		SendInput, ^!9
	}
else if (mdastate=0 and ChoosePlayer=11)
	{
		SendInput, !+1
	}
else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe") 
	{
		WinActivate, BlueStacks App Player
		SendInput, a
	}
else
	{
		SendInput, ^+9
	}
return

playpausepress: ;numpad 5, numpadclear, f1 :play pause
;SendInput {Media_Play_Pause}
;if winexist("ahk_exe ONENOTE.EXE") AND (mdkystate=1)
if (mdastate=0) and (mdkystate=1)
	{
		;WinActivate
		SendInput, ^+6
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=10)
	{
		SendInput, ^!6
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=11)
	{
		SendInput, !+6
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
	{
		SendInput, {Media_Play_Pause} 
	}
else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe") 
	{
		WinActivate, BlueStacks App Player
		SendInput, s
	}
else
	{
		SendInput, {Media_Play_Pause} 
	}
return
; if (mdastate=0)
; 	{
; 		;if winexist("ahk_exe ONENOTE.EXE") AND (mdkystate=1)
; 		if(mdkystate=1)
; 			{
; 			  ;WinActivate
; 				SendInput, ^+6
; 			}
; 		else if (ChoosePlayer=10)
; 			{
; 				SendInput, ^!6
; 			}
; 		else if (ChoosePlayer=11)
; 			{
; 				SendInput, !+6
; 			}
; 		else
; 			{
; 				SendInput, {Media_Play_Pause} 
; 			}
; 	}
; else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe") 
; 	{
; 		WinActivate, BlueStacks App Player
; 		SendInput, s
; 	}
; else
; 	{
; 		SendInput, {Media_Play_Pause} 
; 	}
; return

forwardbysec: ;numpad6, numpadright, f2 :forward
if (mdastate=0 and ChoosePlayer=00)
	{
		SendInput, ^+0
	}
else if (mdastate=0 and ChoosePlayer=10)
	{
		SendInput, ^!0
	}
else if (mdastate=0 and ChoosePlayer=11)
	{
		SendInput, !+2
	}
else if (mdastate=1) and WinExist("ahk_exe HD-Player.exe") 
	{
		WinActivate, BlueStacks App Player
		SendInput, d
	}
else
	{
		SendInput, ^+0
	}
return
;/////////////////////////////////////////////////////////////////////////////////////////////////

Screenshot1orScreenshot2State0: ;create non-spaced labels for menu items
{
	scrstate:=0
	saveSetting("scrstate", scrstate, settingsFile)
	Menu, sharexshotstate, uncheck, ScrnShot - 1 || ReptShot - 2
	Menu, sharexshotstate, check, ScrnShot - 2 || ReptShot - 1
}
Return

Screenshot1orScreenshot2State1:
{
	scrstate:=1
	saveSetting("scrstate", scrstate, settingsFile)
	Menu, sharexshotstate, check, ScrnShot - 1 || ReptShot - 2
	Menu, sharexshotstate, uncheck, ScrnShot - 2 || ReptShot - 1
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

SpeedUpDownor_State:
{
	spustate := 0
	saveSetting("spustate", spustate, settingsFile)
	Menu, speedunrestate, check, SpeedUp || SpeedDown
	Menu, speedunrestate, uncheck, Redo || Undo
	MsgBox, 262144, Speed up/down,
	(
		^ - speed up
		`nv - speed down
	) 
}
Return
	
UndoRedo_State:
{
	spustate := 1
	saveSetting("spustate", spustate, settingsFile)
	Menu, speedunrestate, uncheck, SpeedUp || SpeedDown
	Menu, speedunrestate, check, Redo || Undo
	MsgBox, 262144, undo/redo,
	(
		^ - redo
		`nv - undo
	) 
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

copycutchoose:
{
	cpcstate:=0
	saveSetting("cpcstate", cpcstate, settingsFile)
	Menu, copycutstate, check, Copy || Cut
	Menu, copycutstate, uncheck, CopyLinkOneNote || Copy || Cut
	MsgBox, 262144, copy/cut,
	(
		copy - 1 press
		`ncut  - 1 press
	) 
}
Return

copylinkcopycutchoose:
{
	cpcstate:=1
	saveSetting("cpcstate", cpcstate, settingsFile)
	Menu, copycutstate, uncheck, Copy || Cut
	Menu, copycutstate, check, CopyLinkOneNote || Copy || Cut
	MsgBox, 262144, copylink/copy/cut,
	(
		copylink(onenote) - 1 press
					`ncopy - 2 press
				 	 `ncut - 3 press
	)  
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

pasteon1press:
{
	pstpstplnste:=0
	saveSetting("pstpstplnste", pstpstplnste, settingsFile)
	Menu, pastestate, check, Paste
	Menu, pastestate, uncheck, 1. Paste || 2. Paste Plain OneNote
	SplashTextOn,150,40,, Paste
    Sleep 600
    SplashTextOff
}
Return

pasteon1presspasteplain2press:
{
	pstpstplnste:=1
	saveSetting("pstpstplnste", pstpstplnste, settingsFile)
	Menu, pastestate, uncheck, Paste
	Menu, pastestate, check, 1. Paste || 2. Paste Plain OneNote
	SplashTextOn,300,50,, 1. Paste || 2. Paste Plain OneNote
    Sleep 600
    SplashTextOff
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

MediaPlay4AllorMediaPlay4NoxState0:
{
	mdastate:=0
	saveSetting("mdastate", mdastate, settingsFile)
	SoundBeep, 300, 700
	Menu, playpausestate, check, Play Pause 4 All
	Menu, playpausestate, uncheck, Play Pause 4 BlueStacks
	gosub, iconchanger
}
Return

MediaPlay4AllorMediaPlay4NoxState1:
{
	mdastate:=1
	saveSetting("mdastate", mdastate, settingsFile)
	SoundBeep, 300, 700
	Menu, playpausestate, uncheck, Play Pause 4 All
	Menu, playpausestate, check, Play Pause 4 BlueStacks
	gosub, iconchanger
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

Bluestackflscmxmmd:
{
	bluestackmode := !bluestackmode
	saveSetting("bluestackmode", bluestackmode, settingsFile)
	if (bluestackmode=0)
		{
			MsgBox, 262144, Bluestacks Maximize,
			(
				Bluestacks Maximize
			) 
		}
	else if (bluestackmode=1)
		{
			MsgBox, 262144, Bluestacks Fullscreen,
			(
				Bluestacks Fullscreen
			) 
		} 
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

mk4acDefault: 
{
	mdkystate:=0
	ChoosePlayer:=00
	saveSetting("mdkystate", mdkystate, settingsFile)
	saveSetting("ChoosePlayer", ChoosePlayer, settingsFile)
    Menu, mediakey4allchoose, check, Media_Key (default)
    Menu, mediakey4allchoose, uncheck, Media_Key (PotPlayer)
	Menu, mediakey4allchoose, uncheck, Media_Key (Opera)
    ;checking and unchecking mkeyonestate
    Menu, mkeyonestate, check, Media_Key 4 All
	Menu, mkeyonestate, uncheck, Media_Key 4 OneNote
	MsgBox, 262144, Media_Play_Pause,
	(
		Play/Pause - Media_Play_Pause
        `nMediaKey -4- Default 
	) 
} 
return

mk4acPotPlayer:
{
	mdkystate:=0
	ChoosePlayer:=10
	saveSetting("mdkystate", mdkystate, settingsFile)
	saveSetting("ChoosePlayer", ChoosePlayer, settingsFile)
    Menu, mediakey4allchoose, uncheck, Media_Key (default)
    Menu, mediakey4allchoose, check, Media_Key (PotPlayer)
	Menu, mediakey4allchoose, uncheck, Media_Key (Opera)
    ;checking and unchecking mkeyonestate
    Menu, mkeyonestate, check, Media_Key 4 All
	Menu, mkeyonestate, uncheck, Media_Key 4 OneNote
	MsgBox, 262144, Media_Play_Pause,
	(
		Play/Pause - Media_Play_Pause
        `nMediaKey -4- PotPlayer
	) 
} 
return

mk4acOpera:
{
	mdkystate:= 0
	ChoosePlayer:=11
	saveSetting("mdkystate", mdkystate, settingsFile)
	saveSetting("ChoosePlayer", ChoosePlayer, settingsFile)
	Menu, mediakey4allchoose, uncheck, Media_Key (default)
    Menu, mediakey4allchoose, uncheck, Media_Key (PotPlayer)
	Menu, mediakey4allchoose, check, Media_Key (Opera)
	;checking and unchecking mkeyonestate
    Menu, mkeyonestate, check, Media_Key 4 All
	Menu, mkeyonestate, uncheck, Media_Key 4 OneNote
	MsgBox, 262144, Media_Play_Pause,
	(
		Play/Pause - Media_Play_Pause
        `nMediaKey -4- Opera
	) 
}
Return

mediakey4onenotechoose:
{
	mdkystate:=1
	saveSetting("mdkystate", mdkystate, settingsFile)
	Menu, mkeyonestate, uncheck, Media_Key 4 All
	Menu, mkeyonestate, check, Media_Key 4 OneNote
	MsgBox, 262144, Media_Play_Pause,
	(
		Play/Pause - ctrl + shift + 6 
	)
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

fnkeysdisable: ;means fnkeys are disable 
{
	fnstate:=0
	saveSetting("fnstate", fnstate, settingsFile)
	SoundBeep, 900, 500
	Menu, fnkeystate, check, Disable
	Menu, fnkeystate, uncheck, Enable
	SplashTextOn,250,40,,Fn AHK Keys Disable
	Sleep 800
	SplashTextOff
	gosub, iconchanger
}
Return
	
fnkeysenable: ;mean fnkeys are enable
{
	fnstate:=1
	saveSetting("fnstate", fnstate, settingsFile)
	SoundBeep, 900, 500
	Menu, fnkeystate, uncheck, Disable
	Menu, fnkeystate, check, Enable
	SplashTextOn,250,40,,Fn AHK Keys Enable
	Sleep 800
	SplashTextOff
	gosub, iconchanger
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

numpadkeysdisable: ;means fnkeys are disable 
{
	numpadkeytoggle:=1
	saveSetting("numpadkeytoggle", numpadkeytoggle, settingsFile)
	SoundBeep, 700, 800
	Menu, numpadkeystate, check, Disable
	Menu, numpadkeystate, uncheck, Enable
	SplashTextOn,300,40,,Numpad AHK Keys Disable
	Sleep 800
	SplashTextOff
	gosub, iconchanger
}
Return
	
numpadkeysenable: ;mean fnkeys are enable
{
	numpadkeytoggle:=0
	saveSetting("numpadkeytoggle", numpadkeytoggle, settingsFile)
	SoundBeep, 700, 800
	Menu, numpadkeystate, uncheck, Disable
	Menu, numpadkeystate, check, Enable
	SplashTextOn,300,40,,Numpad AHK Keys Enable
	Sleep 800
	SplashTextOff
	gosub, iconchanger
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

wheelscrollupdownchoose:
{
    whelscrlfn:=0
	saveSetting("whelscrlfn", whelscrlfn, settingsFile)
	Menu, scrolledstate, check, WheelUP - ScrollUp || WheelDown - ScrollDown
    Menu, scrolledstate, uncheck, WheelUp - RightArrow || WheelDown - LeftArrow
}
Return

wheelrightleftarrowchoose:
{
	whelscrlfn:=1
	saveSetting("whelscrlfn", whelscrlfn, settingsFile)
	Menu, scrolledstate, uncheck, WheelUP - ScrollUp || WheelDown - ScrollDown
    Menu, scrolledstate, check, WheelUp - RightArrow || WheelDown - LeftArrow
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

mousemdlbtnstateenable:
{
    mbtnstate:=0
	saveSetting("mbtnstate", mbtnstate, settingsFile)
	Menu, mousemdlbtnstate, uncheck, Enable
	Menu, mousemdlbtnstate, check, Disable
	SplashTextOn,250,50,,Mouse_Middle_Button Disable
    Sleep 600
    SplashTextOff
}
Return

mousemdlbtnstatedisable:
{
    mbtnstate:=1
	saveSetting("mbtnstate", mbtnstate, settingsFile)
	Menu, mousemdlbtnstate, check, Enable
	Menu, mousemdlbtnstate, uncheck, Disable
	SplashTextOn,250,50,,Mouse_Middle_Button Enable
    Sleep 600
    SplashTextOff
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

xtrbttnlrarw:
{
    xbuttonstate:=01
	saveSetting("xbuttonstate", xbuttonstate, settingsFile)
	Menu, mousextrbtnstate, check, XBttn1 - LeftArrow || XBttn2 - RightArrow
	Menu, mousextrbtnstate, uncheck, XBttn1 - BackWard5s || XBttn2 - Forward5s
	Menu, mousextrbtnstate, uncheck, XBttn1 - WheelRight || XBttn2 - WheelLeft
}
Return

xtrbttnfb5s:
{
    xbuttonstate:=10
	saveSetting("xbuttonstate", xbuttonstate, settingsFile)
	Menu, mousextrbtnstate, uncheck, XBttn1 - LeftArrow || XBttn2 - RightArrow
	Menu, mousextrbtnstate, check, XBttn1 - BackWard5s || XBttn2 - Forward5s
	Menu, mousextrbtnstate, uncheck, XBttn1 - WheelRight || XBttn2 - WheelLeft
}
Return

xtrbttnwrwl:
{
	xbuttonstate:=11
	saveSetting("xbuttonstate", xbuttonstate, settingsFile)
	Menu, mousextrbtnstate, uncheck, XBttn1 - LeftArrow || XBttn2 - RightArrow
	Menu, mousextrbtnstate, uncheck, XBttn1 - BackWard5s || XBttn2 - Forward5s
	Menu, mousextrbtnstate, check, XBttn1 - WheelRight || XBttn2 - WheelLeft
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

ahkscrnclipselect:
{
	clipperchoose:=0
	saveSetting("clipperchoose", clipperchoose, settingsFile)
	Menu, clippingtoolselect, check, AHK Screen Clipper
	Menu, clippingtoolselect, uncheck, Sharex Screen Clipper
	Menu, Tray, check, AHK Clip Activate Button
	Menu, MNFunctions, check, AHK Clip Activate Button
	Menu, Tray, uncheck, Sharex Clip Activate Button
	Menu, MNFunctions, uncheck, Sharex Clip Activate Button
}
Return

sharexscrnclipselect:
{
	clipperchoose:=1
	saveSetting("clipperchoose", clipperchoose, settingsFile)
	Menu, clippingtoolselect, uncheck, AHK Screen Clipper
	Menu, clippingtoolselect, check, Sharex Screen Clipper
	Menu, Tray, uncheck, AHK Clip Activate Button
	Menu, MNFunctions, uncheck, AHK Clip Activate Button
	Menu, Tray, check, Sharex Clip Activate Button
	Menu, MNFunctions, check, Sharex Clip Activate Button
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

ahkscncliprghtbtnselect:
{
    screenclipstate := 10
	saveSetting("screenclipstate", screenclipstate, settingsFile)
	Menu, ahkbtnselector, uncheck, AHK_ScrnClip - MButton
    Menu, ahkbtnselector, check, AHK_ScrnClip - RButton
}
Return

ahkscnclipmdlbtnselect:
{
	screenclipstate := 01
	saveSetting("screenclipstate", screenclipstate, settingsFile)
	Menu, ahkbtnselector, check, AHK_ScrnClip - MButton
    Menu, ahkbtnselector, uncheck, AHK_ScrnClip - RButton
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

sharexcliprghtbtnselect:
{
    sharexclipstate := 00
	saveSetting("sharexclipstate", sharexclipstate, settingsFile)
	Menu, sharexbtnselector, uncheck, Sharex_ScrnClip - MButton
    Menu, sharexbtnselector, check, Sharex_ScrnClip - RButton
}
Return

sharexclipmdlbtnselect:
{
	sharexclipstate := 11
	saveSetting("sharexclipstate", sharexclipstate, settingsFile)
	Menu, sharexbtnselector, check, Sharex_ScrnClip - MButton
    Menu, sharexbtnselector, uncheck, Sharex_ScrnClip - RButton
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

tklksfmodeon:
{
    tklmode := 01
	saveSetting("tklmode", tklmode, settingsFile)
	Menu, tklksfmodeselector, check, ON
    Menu, tklksfmodeselector, uncheck, OFF
	text =
	(
	=> Keyboard with bad Arrow Keys design <=
-> Special Functionality 4 Tkl Keyboard <-

	i  = Up Arrow
	j  = Left Arrow
	k  = Down Arrow
	l  = Right Arrow

	F1 = Shift
	F2 = Ctrl
	F3 = Alt
	F4 = Win
	)
	MsgBox, 262144, Media_Play_Pause, %text%

	}
Return

tklksfmodeoff:
{
	tklmode := 00
	saveSetting("tklmode", tklmode, settingsFile)
	Menu, tklksfmodeselector, uncheck, ON
    Menu, tklksfmodeselector, check, OFF
	text = 
	(
	=> Kyeboard with proper Arrow Keys design <=
-> Back to Normal Keyboard Functionality <-
	)
	MsgBox, 262144, Media_Play_Pause, %text%
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

lectruerecordingopen:
run, C:\Users\amana\Music\Lecture Recordings
Return

exploreedopen:
run, C:\DaTa\E_D
Return

OneNoterunner:
run, ONENOTE
Return

calculatorrunneropen:
run, Calc
Return

notepadrunneropen:
run, Notepad
Return

editscript:
{
    SplashTextOn,150,40,,Edit Script
    Sleep 400
    SplashTextOff
    editwithvscode()
}
Return

appreloader:
{
    SplashTextOn,150,40,,Reload App
    Sleep 400
    SplashTextOff
    Reload
}
Return

appsuspender:
Suspend, Toggle
SoundBeep, 500, 500
If (A_IsSuspended)
{
	Menu, Tray, Icon, %A_ScriptDir%\bin\icons\suspended.ico,,1
}
Else
{
	gosub, iconchanger
}
Return

exiterapp:
{
    SplashTextOn,150,40,,Exit Script
    Sleep 400
    SplashTextOff
    ExitApp
}
Return

iconchanger:
{
	if(mdastate = 0 and fnstate = 0 and numpadkeytoggle = 0) ;media player 4 all, fn key disable
        {
			Menu, Tray, Icon, %A_ScriptDir%\bin\icons\fndisableone_all.ico
        }
    else if(mdastate = 0 and fnstate = 1 and numpadkeytoggle = 0) ;media player 4 all, fn key enable
        {
			Menu, Tray, Icon, %A_ScriptDir%\bin\icons\fnenableone_all.ico
        }
    else if(mdastate = 1 and fnstate = 0 and numpadkeytoggle = 0) ;media player 4 bluestack, fn key disable
        {
            Menu, Tray, Icon, %A_ScriptDir%\bin\icons\fndisableone_nox.ico
        }
    else if(mdastate = 1 and fnstate = 1 and numpadkeytoggle = 0) ;media player 4 bluestack, fn key enable
        {
            Menu, Tray, Icon, %A_ScriptDir%\bin\icons\fnenableone_nox.ico
        }
	;-----------------------------------------------------------------------------------------------------;when numpad ahk keys are disable
	else if(mdastate = 0 and fnstate = 0 and numpadkeytoggle = 1) ;media player 4 all, fn key disable
        {
			Menu, Tray, Icon, %A_ScriptDir%\bin\icons\numdisable_fndisableone_all.ico
        }
    else if(mdastate = 0 and fnstate = 1 and numpadkeytoggle = 1) ;media player 4 all, fn key enable
        {
			Menu, Tray, Icon, %A_ScriptDir%\bin\icons\numdisable_fnenableone_all.ico
        }
    else if(mdastate = 1 and fnstate = 0 and numpadkeytoggle = 1) ;media player 4 bluestack, fn key disable
        {
            Menu, Tray, Icon, %A_ScriptDir%\bin\icons\numdisable_fndisableone_nox.ico
        }
    else if(mdastate = 1 and fnstate = 1 and numpadkeytoggle = 1) ;media player 4 bluestack, fn key enable
        {
            Menu, Tray, Icon, %A_ScriptDir%\bin\icons\numdisable_fnenableone_nox.ico
        }
}
Return

fnnumpadahkkeystate:
If (KeyPressCount = 1)
{
	fnstate:=!fnstate
	saveSetting("fnstate", fnstate, settingsFile)	
	if (fnstate = 1)
		{
			gosub, fnkeysenable
		}
	else if (fnstate = 0)
		{
			gosub, fnkeysdisable
		}
}
Else If (KeyPressCount > 1)
{
	numpadkeytoggle:=!numpadkeytoggle
	saveSetting("numpadkeytoggle", numpadkeytoggle, settingsFile)
	if (numpadkeytoggle=0)
		{
			gosub, numpadkeysenable
		}
	else if (numpadkeytoggle=1)
		{
			gosub, numpadkeysdisable
		}
}
KeyPressCount := 0
SetTimer, fnnumpadahkkeystate, Off
Tooltip,
return

editwithvscode()
{
 ; Run the specified executable with the script full path as an argument
 ; Construct the full path to the executable and the script
 vscodePath := "C:\Users\" . A_UserName . "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
 ; Run the executable with the script's full path as an argument
 Run, %vscodePath% "%A_ScriptFullPath%"
}

;============================================================================================================
;============================================================================================================
;mouse function switcher

;scroll wheel up and down into arrow keys 


;Hotkeys to run on clippings
#IfWinActive, ScreenClippingWindow ahk_class AutoHotkeyGUI

^c::
SCW_Win2Clipboard(0) ;previous value 1 22/05/24   ; copy selected win to clipboard  Change to (1) if want border and (0) for no border
return 

^s::
SCW_Win2File(0)  ;save selected clipping on desktop as .png  ; this was submited by tervon; border not savd even if (1)
return

y::
GK_Win2OCR()  
return

t:: 
tessocront()
return 

Left::
WinGetPos, Pos_X, Pos_Y, , , A
Pos_X -= 30
WinMove, A, , Pos_X, Pos_Y
return

Right::
WinGetPos, Pos_X, Pos_Y, , , A
Pos_X += 30
WinMove, A, , Pos_X, Pos_Y
return

Up::
WinGetPos, Pos_X, Pos_Y, , , A
Pos_Y -= 30
WinMove, A, , Pos_X, Pos_Y
return

Down::
WinGetPos, Pos_X, Pos_Y, , , A
Pos_Y += 30
WinMove, A, , Pos_X, Pos_Y
return

Del:: winclose, A ;contributed by tervon
Backspace:: winclose, A

checkahkguisclip()   ;function: if gui active than only copy and close the gui otherwise just do nothing
{
    ; Get the handle of the window under the mouse cursor
    MouseGetPos,,, hWnd
    ; Get the class name of the window under the mouse cursor
    WinGetClass, className, ahk_id %hWnd%
    ; Get the process name of the window under the mouse cursor
    WinGet, processName, ProcessName, ahk_id %hWnd%
    ; Get the process ID of the window under the mouse cursor
    WinGet, windowPID, PID, ahk_id %hWnd%
    
    ; Check if the class name, process name, and process ID match the target window
    if (className = "AutoHotkeyGUI" and processName = "AutoHotkeyU32.exe")
        {
            ; Get the handle of the active window
            WinGet, activePID, PID, A
            ; Check if the active window and the window under the cursor are the same
            if (activePID = windowPID) {
				SCW_Win2Clipboardxi()
				WinClose, ahk_pid %activePID%
            }
        }
	Return
}
;Return

checkahkguisclipclosernmedia() ;it minimize the gui other wise plays the media
{
    ; Get the handle of the window under the mouse cursor
    MouseGetPos,,, hWnd
    ; Get the class name of the window under the mouse cursor
    WinGetClass, className, ahk_id %hWnd%
    ; Get the process name of the window under the mouse cursor
    WinGet, processName, ProcessName, ahk_id %hWnd%
    ; Get the process ID of the window under the mouse cursor
    WinGet, windowPID, PID, ahk_id %hWnd%
    
    ; Check if the class name, process name, and process ID match the target window
    if (className = "AutoHotkeyGUI" and processName = "AutoHotkeyU32.exe")
        {
            ; Get the handle of the active window
            WinGet, activePID, PID, A
            ; Check if the active window and the window under the cursor are the same
            if (activePID = windowPID) {
				;WinClose, ahk_pid %activePID%
				WM_LBUTTONDBLCLK()
            }
        }
	else
		{
			gosub, mbclickplaypressmonitor4left
		}
	Return
}
;Return ;you need not to put return in the ind of function

checkahkguisclipcloser() ;on double click it closes the gui
{
    ; Get the handle of the window under the mouse cursor
    MouseGetPos,,, hWnd
    ; Get the class name of the window under the mouse cursor
    WinGetClass, className, ahk_id %hWnd%
    ; Get the process name of the window under the mouse cursor
    WinGet, processName, ProcessName, ahk_id %hWnd%
    ; Get the process ID of the window under the mouse cursor
    WinGet, windowPID, PID, ahk_id %hWnd%
    
    ; Check if the class name, process name, and process ID match the target window
    if (className = "AutoHotkeyGUI" and processName = "AutoHotkeyU32.exe")
        {
            ; Get the handle of the active window
            WinGet, activePID, PID, A
            ; Check if the active window and the window under the cursor are the same
            if (activePID = windowPID) {
				WinClose, ahk_pid %activePID%
            }
        }
	Return
}
;Return

checkahkguisclipnocr() ;function: if ahk gui active than only use teseract ocr otherwise just ignore
{
    ; Get the handle of the window under the mouse cursor
    MouseGetPos,,, hWnd
    ; Get the class name of the window under the mouse cursor
    WinGetClass, className, ahk_id %hWnd%
    ; Get the process name of the window under the mouse cursor
    WinGet, processName, ProcessName, ahk_id %hWnd%
    ; Get the process ID of the window under the mouse cursor
    WinGet, windowPID, PID, ahk_id %hWnd%
    
    ; Check if the class name, process name, and process ID match the target window
    if (className = "AutoHotkeyGUI" and processName = "AutoHotkeyU32.exe")
        {
            ; Get the handle of the active window
            WinGet, activePID, PID, A
            ; Check if the active window and the window under the cursor are the same
            if (activePID = windowPID) {
				tessocront()
				;WinClose, ahk_pid %activePID%
            }
        }
	return
}
;Return

#IfWinActive

MenuHandler:
if (A_ThisMenuItemPos = 1)
 SCW_Win2Clipboard2() ; 0 for border, leave empty for no border ;previous value not changed

if (A_ThisMenuItemPos = 2) ;this thing does not work with
 {
SCW_Win2Clipboard2()
Winclose, A
Run, paintdotnet
WinWaitActive, Untitled - paint.net 5.0.13
 }

if (A_ThisMenuItemPos = 3) ;this is also not required
 {
 SCW_Win2Clipboard2() ; 0 for border in this function, leave empty for no border
 winclose, A
 Clipboard2Acrobat()
 }
 
if (A_ThisMenuItemPos = 4)
{
 FileToEmail := SCW_Win2File(0, 1, 1)
 winclose, A
 Email_AttachFile(FileToEmail)
}

if (A_ThisMenuItemPos = 5)
{
 SCW_Win2Clipboard2() ; 0 for border in this function, leave empty for no border
 pToken := Gdip_Startup()
 j++
 Tesseract%j%:=new Tesseract()
 pBitmap := Gdip_CreateBitmapFromClipboard() ;store pointer to image from clipboard
 text:=Tesseract%j%.OCR(pBitmap) ;process image
 Tesseract%j%:=""
 Gdip_Shutdown(pToken)
 MsgBox, 4096, Text Copied to Your Clipboard, % Clipboard:=Text
 ;~ Reload ;not required if j++ is present
 return
}

if (A_ThisMenuItemPos = 6) ;Carefully change the number over here
{
  SCW_Win2File(0, 0, 1)
}

if (A_ThisMenuItemPos = 7)
{
 WinClose, A
}

Return


; SCW Functions ==========================================================================
tessocront()
{
	SCW_Win2Clipboard2() ; 0 for border in this function, leave empty for no border
	pToken := Gdip_Startup()
	j++
	Tesseract%j%:=new Tesseract()
	pBitmap := Gdip_CreateBitmapFromClipboard() ;store pointer to image from clipboard
	text:=Tesseract%j%.OCR(pBitmap) ;process image
	Tesseract%j%:=""
	Gdip_Shutdown(pToken)
	ToolTip, % Clipboard:=Text
	Sleep 2000
	ToolTip
	;WinClose, A
	;~ Reload ;not required if j++ is present
	return
}

SCW_Version() {
   return 1.02
}

SCW_DestroyAllClipWins() {
   MaxGuis := SCW_Reg("MaxGuis"), StartAfter := SCW_Reg("StartAfter")
   Loop, %MaxGuis%
   {
      StartAfter++
      Gui %StartAfter%: Destroy
   }
}

SCW_SetUp(Options="") {
   if !(Options = "")
   {
      Loop, Parse, Options, %A_Space%
      {
         Field := A_LoopField
         DotPos := InStr(Field, ".")
         if (DotPos = 0)
         Continue
         var := SubStr(Field, 1, DotPos-1)
         val := SubStr(Field, DotPos+1)
         if var in StartAfter,MaxGuis,AutoMonitorWM_LBUTTONDOWN,DrawCloseButton,BorderAColor,BorderBColor,SelColor,SelTrans
         %var% := val
      }
   }

   SCW_Default(StartAfter,80), SCW_Default(MaxGuis,19) ;previously SCW_Default(MaxGuis,20) but now 20 is 19
   SCW_Default(AutoMonitorWM_LBUTTONDOWN,1), SCW_Default(DrawCloseButton,0)
   SCW_Default(BorderBColor,"FFFF0909") ; Set Border Color Here (hex8 with no #). The First Color vlaue sets the outline and the Second Color value sets the inner border. Black: for crimsion red FFFF0909, White: FFFFFFFF. For thin border style remove the first border altogether (i.e. 'SCW_Default(BorderAColor,"Colorcode")' ). For thicker border style add 'SCW_Default(BorderAColor,"FF181818"),' before BorderBColor
   
   SCW_Default(SelColor,"Yellow"), SCW_Default(SelTrans,80)

   SCW_Reg("MaxGuis", MaxGuis), SCW_Reg("StartAfter", StartAfter), SCW_Reg("DrawCloseButton", DrawCloseButton)
   SCW_Reg("BorderAColor", BorderAColor), SCW_Reg("BorderBColor", BorderBColor)
   SCW_Reg("SelColor", SelColor), SCW_Reg("SelTrans",SelTrans)
   SCW_Reg("WasSetUp", 1)
   if AutoMonitorWM_LBUTTONDOWN
   OnMessage(0x201, "SCW_LBUTTONDOWN")
}

SCW_ScreenClip2Win(clip=0) {
   static c
   if !(SCW_Reg("WasSetUp"))
   SCW_SetUp()

   StartAfter := SCW_Reg("StartAfter"), MaxGuis := SCW_Reg("MaxGuis"), SelColor := SCW_Reg("SelColor"), SelTrans := SCW_Reg("SelTrans")
   c++
   if (c > MaxGuis)
   c := 1

   GuiNum := StartAfter + c
   Area := SCW_SelectAreaMod("g" GuiNum " c" SelColor " t" SelTrans)
   StringSplit, v, Area, |
   if (v3 < 10 and v4 < 10)   ; too small area
   return

   pToken := Gdip_Startup()
   if pToken =
   {
      MsgBox, 64, GDI+ error, GDI+ failed to start. Please ensure you have GDI+ on your system.
      return
   }

   Sleep, 100
   ;~ MsgBox % Clipboard:=Area
   pBitmap := Gdip_BitmapFromScreen(Area)



;*******************************************************
   SCW_CreateLayeredWinMod(GuiNum,pBitmap,v1,v2, SCW_Reg("DrawCloseButton"))
   Gdip_Shutdown("pToken")
if (clip=1)
{
 ;********************** added to copy to clipboard by default*********************************
 	
	WinActivate, ScreenClippingWindow ahk_class AutoHotkeyGUI ;activates last clipped window ;22/05/24 this code only focus on gui ;changing WinActivate to WinActive
	SCW_Win2Clipboardxi()  ;copies to clipboard by default w/o border ; 0 for borderless 1 for with border
;~ MsgBox on clipboard   ;You can change the value over here 
;for some reason this above code does not work as intended 
;*******************************************************
}
}

SCW_SelectAreaMod(Options="") {
   CoordMode, Mouse, Screen
   MouseGetPos, MX, MY
      loop, parse, Options, %A_Space%
   {
      Field := A_LoopField
      FirstChar := SubStr(Field,1,1)
      if FirstChar contains c,t,g,m
      {
         StringTrimLeft, Field, Field, 1
         %FirstChar% := Field
      }
   }
   c := (c = "") ? "Blue" : c, t := (t = "") ? "50" : t, g := (g = "") ? "99" : g
   Gui %g%: Destroy
   Gui %g%: +AlwaysOnTop -caption +Border +ToolWindow +LastFound -DPIScale ;provided from rommmcek 10/23/16
   
   WinSet, Transparent, %t%
   Gui %g%: Color, %c%
   Hotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
   While, (GetKeyState(Hotkey, "p"))
   {
      Sleep, 10
      MouseGetPos, MXend, MYend
      w := abs(MX - MXend), h := abs(MY - MYend)
      X := (MX < MXend) ? MX : MXend
      Y := (MY < MYend) ? MY : MYend
      Gui %g%: Show, x%X% y%Y% w%w% h%h% NA
   }
   Try Gui %g%: Destroy
   MouseGetPos, MXend, MYend
   If ( MX > MXend )
   temp := MX, MX := MXend, MXend := temp
   If ( MY > MYend )
   temp := MY, MY := MYend, MYend := temp
   Return MX "|" MY "|" w "|" h
}



SCW_CreateLayeredWinMod(GuiNum,pBitmap,x,y,DrawCloseButton=0) {
   static CloseButton := 16
   BorderAColor := SCW_Reg("BorderAColor"), BorderBColor := SCW_Reg("BorderBColor")
 
   Gui %GuiNum%: -Caption +E0x80000 +LastFound +ToolWindow +AlwaysOnTop +OwnDialogs -DPIScale ;+Resize
   Gui %GuiNum%: Show, Na, ScreenClippingWindow
   hwnd := WinExist()

   Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
   hbm := CreateDIBSection(Width+6, Height+6), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
   G := Gdip_GraphicsFromHDC(hdc), Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 7)

   Gdip_DrawImage(G, pBitmap, 3, 3, Width, Height)
   Gdip_DisposeImage(pBitmap)

   pPen1 := Gdip_CreatePen("0x" BorderAColor, 3), pPen2 := Gdip_CreatePen("0x" BorderBColor, 1)
   if DrawCloseButton
   {
      Gdip_DrawRectangle(G, pPen1, 1+Width-CloseButton+3, 1, CloseButton, CloseButton)
      Gdip_DrawRectangle(G, pPen2, 1+Width-CloseButton+3, 1, CloseButton, CloseButton)
   }
   Gdip_DrawRectangle(G, pPen1, 1, 1, Width+3, Height+3)
   Gdip_DrawRectangle(G, pPen2, 1, 1, Width+3, Height+3)
   Gdip_DeletePen(pPen1), Gdip_DeletePen(pPen2)

   UpdateLayeredWindow(hwnd, hdc, x-3, y-3, Width+6, Height+6)
   SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc), Gdip_DeleteGraphics(G)
   SCW_Reg("G" GuiNum "#HWND", hwnd)
   SCW_Reg("G" GuiNum "#XClose", Width+6-CloseButton)
   SCW_Reg("G" GuiNum "#YClose", CloseButton)
   Return hwnd
}

SCW_LBUTTONDOWN() {
   MouseGetPos,,, WinUMID
    WinGetTitle, Title, ahk_id %WinUMID%
   if Title = ScreenClippingWindow
   {
      PostMessage, 0xA1, 2,,, ahk_id %WinUMID%
      KeyWait, Lbutton
      CoordMode, mouse, Relative
      MouseGetPos, x,y
     XClose := SCW_Reg("G" A_Gui "#XClose"), YClose := SCW_Reg("G" A_Gui "#YClose")
      if (x > XClose and y < YClose)
      Gui %A_Gui%: Destroy
      return 1   ; confirm that click was on module's screen clipping windows
   }
}

SCW_Reg(variable, value="") {
   static
   if (value = "") {
      yaqxswcdevfr := kxucfp%variable%pqzmdk
      Return yaqxswcdevfr
   }
   Else
   kxucfp%variable%pqzmdk = %value%
}

SCW_Default(ByRef Variable,DefaultValue) {
   if (Variable="")
   Variable := DefaultValue
}

SCW_Win2Clipboard(KeepBorders=0) {
   /*   ;   does not work for layered windows
   ActiveWinID := WinExist("A")
   pBitmap := Gdip_BitmapFromHWND(ActiveWinID)
   Gdip_SetBitmapToClipboard(pBitmap)
   */
   Send, !{PrintScreen} ; Active Win's client area to Clipboard
   if (!KeepBorders)
   {
		pToken := Gdip_Startup()
		pBitmap := Gdip_CreateBitmapFromClipboard()
		Gdip_GetDimensions(pBitmap, w, h)
		pBitmap2 := SCW_CropImage(pBitmap, 3, 3, w-6, h-6)
		Gdip_SetBitmapToClipboard(pBitmap2)
		Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
		Gdip_Shutdown("pToken")
   }
}

SCW_Win2Clipboard2(DeleteBorders:=1, Hwnd := "")
{
 Sleep 300 ; Right click menu takes time to fade out therefore need to wait until it completely fades out before taking screenshot
	/*   ;   does not work for layered windows
	ActiveWinID := WinExist("A")
	pBitmap := Gdip_BitmapFromHWND(ActiveWinID)
	Gdip_SetBitmapToClipboard(pBitmap)
	*/
	if !Hwnd
		WinGet, Hwnd, ID, A
	WinGetPos, X, Y, W, H,  ahk_id %Hwnd%
	if DeleteBorders
		X+=3, Y+=3, W-=6, H-=6
	pToken := Gdip_Startup()
	pBitmap := Gdip_BitmapFromScreen(X "|" Y "|" W "|" H)
	Gdip_SetBitmapToClipboard(pBitmap)
	Gdip_Shutdown("pToken")
}

SCW_Win2Clipboardxi(DeleteBorders:=1, Hwnd := "")
{
	/*   ;   does not work for layered windows
	ActiveWinID := WinExist("A")
	pBitmap := Gdip_BitmapFromHWND(ActiveWinID)
	Gdip_SetBitmapToClipboard(pBitmap)
	*/
	if !Hwnd
		WinGet, Hwnd, ID, A
	WinGetPos, X, Y, W, H,  ahk_id %Hwnd%
	if DeleteBorders
		X+=3, Y+=3, W-=6, H-=6
	pToken := Gdip_Startup()
	pBitmap := Gdip_BitmapFromScreen(X "|" Y "|" W "|" H)
	Gdip_SetBitmapToClipboard(pBitmap)
	Gdip_Shutdown("pToken")
}

SCW_CropImage(pBitmap, x, y, w, h) {
   pBitmap2 := Gdip_CreateBitmap(w, h), G2 := Gdip_GraphicsFromImage(pBitmap2)
   Gdip_DrawImage(G2, pBitmap, 0, 0, w, h, x, y, w, h)
   Gdip_DeleteGraphics(G2)
   return pBitmap2
}


;***********Function by Tervon*******************
SCW_Win2File(KeepBorders=0, Email=0, FromMenu=0) {
   If(FromMenu=1)
    Sleep 300 ;sleep to wait till menu fully disappears
   Send, !{PrintScreen} ; Active Win's client area to Clipboard
   sleep 50
   
   if !KeepBorders
   {
      pToken := Gdip_Startup()
      pBitmap := Gdip_CreateBitmapFromClipboard()
      Gdip_GetDimensions(pBitmap, w, h)
      pBitmap2 := SCW_CropImage(pBitmap, 3, 3, w-6, h-6)
   }
   
   If(Email=0) {
    Gui +LastFound +OwnDialogs +AlwaysOnTop
    InputBox, myFileName, , Save File Name As:, , 140, 130, , , , , %A_Now%
    if ErrorLevel
     return
   }
   Else
    myFileName := "Capture"      
      
   FilePath:=A_Desktop . "\" . myFileName . ".PNG" ;path to file to save
  
   if !KeepBorders
   {
   Gdip_SaveBitmapToFile(pBitmap2, FilePath) ;Exports automatcially to file
   Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap2)
   Gdip_Shutdown("pToken")
   }
   
   If(Email=0)
    MsgBox, 4096, , Saved to your Desktop!
   
   return FilePath
}

Email_AttachFile(FileToEmail)
 {
  ;**********************make sure outlook is running so email will be sent*********************************
  Process, Exist, olk.exe    ; check to see if Outlook is running.
     Outlook_pid=%errorLevel%         ; errorlevel equals the PID if active
  If (Outlook_pid = 0)   { ;
  run olk.exe
  WinWait, Mail - Outlook, ,3
 }

;**********************Write email*********************************
  olMailItem := 0
  try
      IsObject(MailItem := ComObjActive("Outlook.Application").CreateItem(olMailItem)) ; Get the Outlook application object if Outlook is open
  catch
      MailItem  := ComObjCreate("Outlook.Application").CreateItem(olMailItem) ; Create if Outlook is not open

  olFormatHTML := 2
  MailItem.BodyFormat := olFormatHTML
  ;~ MailItem.TO := (MailTo)
  ;~ MailItem.CC :="example@mail.com"
  MailItem.Subject := ""

  MailItem.HTMLBody := "
  <HTML><p style='font-family:Calibri'; font-size:11px;></p>
  </HTML>"
  ;~ MailItem.Attachments.Add(File1) > BMP file format
  MailItem.Attachments.Add(FileToEmail)
  MailItem.Display ;
  ;~ Reload

  FileDelete, %FileToEmail%
}


Clipboard2Acrobat(SavePathPDF:="")		; Adobe Acrobat must be installed
{
	App := ComObjCreate("AcroExch.App")
	App.Show()
	App.MenuItemExecute("ImageConversion:Clipboard")
	if SavePathPDF
	{
		IfNotExist, %SavePathPDF%
			FileCreateDir, %SavePathPDF%
		FormatTime, TimeStamp ,, yyyy_MM_dd @ HH_mm_ss 
		FileName := TimeStamp ".PDF"
		AVDoc := App.GetActiveDoc()
		PVDoc := AVDoc.GetPDDoc()
		PDSaveIncremental		:= 0x0000   ;/* write changes only */ 
		PDSaveFull						:= 0x0001   ;/* write entire file */ 
		PDSaveCopy					:= 0x0002   ;/* write copy w/o affecting current state */
		PDSaveLinearized			:= 0x0004   ;/* write the file linearized for */
		PDSaveBinaryOK			:= 0x0010   ;/* OK to store binary in file */
		PDSaveCollectGarbage	:= 0x0020   ;/* perform garbage collection on */
		PVDoc.save(PDSaveFull|PDSaveLinearized, SavePathPDF FileName)
	}
}

; PLUGIN FUNCTION -----------------------------------------------------
GK_Win2OCR(lang:="en") {
	;Send, !{PrintScreen} ; Active Win's client area to Clipboard
	WinGet, hwnd, ID, ahk_class AutoHotkeyGUI
	Loop 99 {
		Gui %A_Index%: +LastFound
		if WinExist() = hwnd {
			currentgui := A_Index
			break
		}
	}
	winGetPos, X, Y, W, H, ahk_id %Hwnd%
	x:=x+3, y:=y+3, w:=w-6, h:=h-6
	pToken := Gdip_Startup()
	pBitmap := Gdip_BitmapFromScreen(X "|" Y "|" W "|" H)	
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap) ; Convert an hBitmap from the pBitmap
	pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap) ; OCR function needs a randome access stream (so it isn't "locked down")
	DllCall("DeleteObject", "Ptr", hBitmap)	
	Clipboard := ocr(pIRandomAccessStream, lang)
	ObjRelease(pIRandomAccessStream)
	tooltip, %  clipboard
	Sleep, 4000
	ToolTip
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken) ; clear selection
}


; OTHER FUNCTIONS -----------------------------------------------------

CreateClass(string, interface, ByRef Class){
	CreateHString(string, hString)
	VarSetCapacity(GUID, 16)
	DllCall("ole32\CLSIDFromString", "wstr", interface, "ptr", &GUID)
	result := DllCall("Combase.dll\RoGetActivationFactory", "ptr", hString, "ptr", &GUID, "ptr*", Class)
	if (result != 0){
		if (result = 0x80004002)
			msgbox No such interface supported
		else if (result = 0x80040154)
			msgbox Class not registered
		else
			msgbox error: %result%
			Reload
	}
	DeleteHString(hString)
}

CreateHString(string, ByRef hString){
	 DllCall("Combase.dll\WindowsCreateString", "wstr", string, "uint", StrLen(string), "ptr*", hString)
}

DeleteHString(hString){
	DllCall("Combase.dll\WindowsDeleteString", "ptr", hString)
}

WaitForAsync(Object, ByRef ObjectResult){
	AsyncInfo := ComObjQuery(Object, IAsyncInfo := "{00000036-0000-0000-C000-000000000046}")
	loop	{
		DllCall(NumGet(NumGet(AsyncInfo+0)+7*A_PtrSize), "ptr", AsyncInfo, "uint*", status)   ; IAsyncInfo.Status
		if (status != 0)		{
			if (status != 1)			{
				msgbox AsyncInfo status error.
				ExitApp
			}
			ObjRelease(AsyncInfo)
			AsyncInfo := ""
			break
		}
		sleep 10
	}
	DllCall(NumGet(NumGet(Object+0)+8*A_PtrSize), "ptr", Object, "ptr*", ObjectResult)   ; GetResults
}


HBitmapToRandomAccessStream(hBitmap) {
	static IID_IRandomAccessStream := "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}", IID_IPicture:= "{7BF80980-BF32-101A-8BBB-00AA00300CAB}", PICTYPE_BITMAP := 1, BSOS_DEFAULT   := 0
	DllCall("Ole32\CreateStreamOnHGlobal", "Ptr", 0, "UInt", true, "PtrP", pIStream, "UInt")

	VarSetCapacity(PICTDESC, sz := 8 + A_PtrSize*2, 0)
	NumPut(sz, PICTDESC)
	NumPut(PICTYPE_BITMAP, PICTDESC, 4)
	NumPut(hBitmap, PICTDESC, 8)
	riid := CLSIDFromString(IID_IPicture, GUID1)
	DllCall("OleAut32\OleCreatePictureIndirect", "Ptr", &PICTDESC, "Ptr", riid, "UInt", false, "PtrP", pIPicture, "UInt")
	; IPicture::SaveAsFile
	DllCall(NumGet(NumGet(pIPicture+0) + A_PtrSize*15), "Ptr", pIPicture, "Ptr", pIStream, "UInt", true, "UIntP", size, "UInt")
	riid := CLSIDFromString(IID_IRandomAccessStream, GUID2)
	DllCall("ShCore\CreateRandomAccessStreamOverStream", "Ptr", pIStream, "UInt", BSOS_DEFAULT, "Ptr", riid, "PtrP", pIRandomAccessStream, "UInt")
	ObjRelease(pIPicture)
	ObjRelease(pIStream)
	Return pIRandomAccessStream
}

CLSIDFromString(IID, ByRef CLSID) {
	VarSetCapacity(CLSID, 16, 0)
	if res := DllCall("ole32\CLSIDFromString", "WStr", IID, "Ptr", &CLSID, "UInt")
		throw Exception("CLSIDFromString failed. Error: " . Format("{:#x}", res))
	Return &CLSID
}

;********************teadrinker OCR ***********************************
OCR(IRandomAccessStream, language := "en"){
	static OcrEngineClass, OcrEngineObject, MaxDimension, LanguageClass, LanguageObject, CurrentLanguage, StorageFileClass, BitmapDecoderClass
	static rlangList := {"ar":"Arabic (Saudi Arabia)","bg":"Bulgarian (Bulgaria)","zh":"Chinese (Hong Kong S.A.R.)","zh":"Chinese (PRC)","zh":"Chinese (Taiwan)","hr":"Croatian (Croatia)","cs":"Czech (Czech Republic)","da":"Danish (Denmark)","nl":"Dutch (Netherlands)","En":"English (Great Britain)","en":"English (United States)","et":"Estonian (Estonia)","fi":"Finnish (Finland)","fr":"French (France)","de":"German (Germany)","el":"Greek (Greece)","he":"Hebrew (Israel)","hu":"Hungarian (Hungary)","it":"Italian (Italy)","ja":"Japanese (Japan)","ko":"Korean (Korea)","lv":"Latvian (Latvia)","lt":"Lithuanian (Lithuania)","nb":"Norwegian, BokmÃ¥l (Norway)","pl":"Polish (Poland)","pt":"Portuguese (Brazil)","pt":"Portuguese (Portugal)","ro":"Romanian (Romania)","ru":"Russian (Russia)","sr":"Serbian (Latin, Serbia)","sr":"Serbian (Latin, Serbia)","sk":"Slovak (Slovakia)","sl":"Slovenian (Slovenia)","es":"Spanish (Spain)","sv":"Swedish (Sweden)","th":"Thai (Thailand)","tr":"Turkish (Turkey)","uk":"Ukrainian (Ukraine)"}

	if (OcrEngineClass = "")	{
		CreateClass("Windows.Globalization.Language", ILanguageFactory := "{9B0252AC-0C27-44F8-B792-9793FB66C63E}", LanguageClass)
		CreateClass("Windows.Graphics.Imaging.BitmapDecoder", IStorageFileStatics := "{438CCB26-BCEF-4E95-BAD6-23A822E58D01}", BitmapDecoderClass)
		CreateClass("Windows.Media.Ocr.OcrEngine", IOcrEngineStatics := "{5BFFA85A-3384-3540-9940-699120D428A8}", OcrEngineClass)
		DllCall(NumGet(NumGet(OcrEngineClass+0)+6*A_PtrSize), "ptr", OcrEngineClass, "uint*", MaxDimension)   ; MaxImageDimension
	}
	if (CurrentLanguage != language){
		if (LanguageObject != ""){
			ObjRelease(LanguageObject)
			ObjRelease(OcrEngineObject)
			LanguageObject := OcrEngineObject := ""
		}
		CreateHString(language, hString)
		DllCall(NumGet(NumGet(LanguageClass+0)+6*A_PtrSize), "ptr", LanguageClass, "ptr", hString, "ptr*", LanguageObject)   ; CreateLanguage
		DeleteHString(hString)
		DllCall(NumGet(NumGet(OcrEngineClass+0)+9*A_PtrSize), "ptr", OcrEngineClass, ptr, LanguageObject, "ptr*", OcrEngineObject)   ; TryCreateFromLanguage
		if (OcrEngineObject = 0){
			Run % "ms-settings:regionlanguage"
			MsgBox % 0x10, % "OCR Error"
						 , % "Can not use language """ rlangList[language] """ for OCR, please install the corresponding language pack."
			return "error"
		}
		CurrentLanguage := language
	}
	DllCall(NumGet(NumGet(BitmapDecoderClass+0)+14*A_PtrSize), "ptr", BitmapDecoderClass, "ptr", IRandomAccessStream, "ptr*", BitmapDecoderObject)   ; CreateAsync
	WaitForAsync(BitmapDecoderObject, BitmapDecoderObject1)
	BitmapFrame := ComObjQuery(BitmapDecoderObject1, IBitmapFrame := "{72A49A1C-8081-438D-91BC-94ECFC8185C6}")
	DllCall(NumGet(NumGet(BitmapFrame+0)+12*A_PtrSize), "ptr", BitmapFrame, "uint*", width)   ; get_PixelWidth
	DllCall(NumGet(NumGet(BitmapFrame+0)+13*A_PtrSize), "ptr", BitmapFrame, "uint*", height)   ; get_PixelHeight
	if (width > MaxDimension) or (height > MaxDimension){
		msgbox Image is to big - %width%x%height%.`nIt should be maximum - %MaxDimension% pixels
		return
	}
	SoftwareBitmap := ComObjQuery(BitmapDecoderObject1, IBitmapFrameWithSoftwareBitmap := "{FE287C9A-420C-4963-87AD-691436E08383}")
	DllCall(NumGet(NumGet(SoftwareBitmap+0)+6*A_PtrSize), "ptr", SoftwareBitmap, "ptr*", BitmapFrame1)   ; GetSoftwareBitmapAsync
	WaitForAsync(BitmapFrame1, BitmapFrame2)
	DllCall(NumGet(NumGet(OcrEngineObject+0)+6*A_PtrSize), "ptr", OcrEngineObject, ptr, BitmapFrame2, "ptr*", OcrResult)   ; RecognizeAsync
	WaitForAsync(OcrResult, OcrResult1)
	DllCall(NumGet(NumGet(OcrResult1+0)+6*A_PtrSize), "ptr", OcrResult1, "ptr*", lines)   ; get_Lines
	DllCall(NumGet(NumGet(lines+0)+7*A_PtrSize), "ptr", lines, "int*", count)   ; count
	loop % count {
		DllCall(NumGet(NumGet(lines+0)+6*A_PtrSize), "ptr", lines, "int", A_Index-1, "ptr*", OcrLine)
		DllCall(NumGet(NumGet(OcrLine+0)+7*A_PtrSize), "ptr", OcrLine, "ptr*", hText)
		buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
		text .= StrGet(buffer, "UTF-16") "`n"
		ObjRelease(OcrLine)
		OcrLine := ""
	}
	ObjRelease(BitmapDecoderObject)
	ObjRelease(BitmapDecoderObject1)
	ObjRelease(SoftwareBitmap)
	ObjRelease(BitmapFrame)
	ObjRelease(BitmapFrame1)
	ObjRelease(BitmapFrame2)
	ObjRelease(OcrResult)
	ObjRelease(OcrResult1)
	ObjRelease(lines)
	BitmapDecoderObject := BitmapDecoderObject1 := SoftwareBitmap := BitmapFrame := BitmapFrame1 := BitmapFrame2 := OcrResult := OcrResult1 := lines := ""
	return text
}


;#####################################################################################


class Tesseract 
{
;********************jg added- wait for file to exist***********************************
	static leptonica := A_ScriptDir "\bin\leptonica_util\leptonica_util.exe"
	static tesseract := A_ScriptDir "\bin\tesseract\tesseract.exe"
	static tessdata_best := A_ScriptDir "\bin\tesseract\tessdata_best"
	static tessdata_fast := A_ScriptDir "\bin\tesseract\tessdata_fast"
	
	static file := A_ScriptDir "\mcoc_screenshot.bmp"
	static fileProcessedImage := A_ScriptDir "\mcoc_preprocess.tif"
	static fileConvertedText := A_ScriptDir "\mcoc_text.txt"
	
	; OCR() can be called directly
	OCR(pBitmap, language:="", options:="")
	{
		this.language := language
		imgFile:= this.toFile(pBitmap, this.file)
		this.preprocess(imgFile, this.fileProcessedImage)
		this.convert_fast(this.fileProcessedImage, this.fileConvertedText, 0, options)
		return this.read(), this.cleanup()
	}
	
	; toFile() - Saves the image as a temporary file.
	toFile(image, outputFile:="")
	{
		Gdip_SaveBitmapToFile(image, outputFile)
		While ! FileExist(outputFile) ;Added by Joe Glines on 9/21/2019
			Sleep, 100 ;Added by Joe Glines on 9/21/2019
		return outputFile
	}
	
	__New(language:="", options:="")
	{
		this.language := language
	}
	
	cleanup()
	{
		FileDelete, % this.file
		FileDelete, % this.fileProcessedImage
		FileDelete, % this.fileConvertedText
	}
	
	convert_best(in:="", out:="", fast:=0, options:="")
	{
		
		in := (in) ? in : this.fileProcessedImage
		out := (out) ? out : this.fileConvertedText
		fast := (fast) ? this.tessdata_fast : this.tessdata_best
		
		if !(FileExist(in))
			throw Exception("Input image for conversion not found.",, in)
		
		if !(FileExist(this.tesseract))
			throw Exception("Tesseract not found",, this.tesseract)
		
		static q := Chr(0x22)
		_cmd .= q this.tesseract q " --tessdata-dir " q fast q " " q in q " " q SubStr(out, 1, -4) q 
		_cmd .= (options) ? options : " -psm 6"
		_cmd .= (this.language) ? " -l " q this.language q : ""
		_cmd := ComSpec " /C " q _cmd q
		
		;~ msgbox % _cmd
		
		RunWait % _cmd,, Hide
		
		if !(FileExist(out))
			throw Exception("Tesseract failed.",, _cmd)
		
		return out
		
	}
	
	convert_fast(in:="", out:="")
	{
		return this.convert_best(in, out, 1)
	}
	
	
	preprocess(in:="", out:="")
	{
		static LEPT_TRUE 				:= ocrPreProcessing := 1
		static negateArg 				:= 2 ; 0=NEGATE_NO,   /* Do not negate image */  1=NEGATE_YES,  /* Force negate */  2=NEGATE_AUTO, /* Automatically negate if border pixels are dark */
		static dark_bg_threshold 		:= 0.5 ; /* From 0.0 to 1.0, with 0 being all white and 1 being all black */
		static performScaleArg 			:= LEPT_TRUE ; true/false
		static scaleFactor 				:= 3.5 ;
		static perform_unsharp_mask 	:= LEPT_TRUE ;
		static usm_halfwidth 			:= 5 ;
		static usm_fract 				:= 2.5 ;
		static perform_otsu_binarize	:= LEPT_TRUE ;
		static otsu_sx					:= 2000 ;
		static otsu_sy					:= 2000 ;
		static otsu_smoothx				:= 0 ;
		static otsu_smoothy				:= 0 ;
		static otsu_scorefract   		:= 0.0 ;
		
		static q := Chr(0x22)
		
		in := (in != "") ? in : this.file
		out := (out != "") ? out : this.fileProcessedImage
		
		if !(FileExist(in))
			throw Exception("Input image for preprocessing not found.",, in)
		
		if !(FileExist(this.leptonica))
			throw Exception("Leptonica not found",, this.leptonica)
		
		_cmd .= q this.leptonica q " " q in q " " q out q
		
		_cmd .= " " negateArg " " dark_bg_threshold 
			.	" " performScaleArg " " scaleFactor 
			.	" " perform_unsharp_mask " " usm_halfwidth " " usm_fract 
			.	" " perform_otsu_binarize  " " otsu_sx " " otsu_sy " " otsu_smoothx " " otsu_smoothy " " otsu_scorefract
		
		_cmd := ComSpec " /C " q _cmd q
		
		; leptonica_util.exe in.png out.png  2 0.5  1 3.5  1 5 2.5  1 2000 2000 0 0 0.0  1 */
		RunWait, % _cmd,, Hide
		
		if !(FileExist(out))
			throw Exception("Preprocessing failed.",, _cmd)
		
		return out
		
	}
	
	read(in:="", lines:="")
	{
		in := (in) ? in : this.fileConvertedText
		database := FileOpen(in, "r`n", "UTF-8")
		
		if (lines == "") 
		{
			text := RegExReplace(database.Read(), "^\s*(.*?)\s*$", "$1")
			text := RegExReplace(text, "(?<!\r)\n", "`r`n")
		} 
		else
		{
			while (lines > 0) 
			{
				data := database.ReadLine()
				data := RegExReplace(data, "^\s*(.*?)\s*$", "$1")
				if (data != "") 
				{
					text .= (text) ? ("`n" . data) : data
					lines--
				}
				if (!database || database.AtEOF)
					break
			}
		}
		database.Close()
		return text
	}
	
	readlines(lines)
	{
		return this.read(, lines)
	}
}


;#####################################################################################

; Gdip standard library v1.45 by tic (Tariq Porter) 07/09/11
; source: https://github.com/tariqporter/Gdip
;#####################################################################################
;#####################################################################################
; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type
;#####################################################################################
;
; Ok =						= 0
; GenericError				= 1
; InvalidParameter			= 2
; OutOfMemory				= 3
; ObjectBusy				= 4
; InsufficientBuffer		= 5
; NotImplemented			= 6
; Win32Error				= 7
; WrongState				= 8
; Aborted					= 9
; FileNotFound				= 10
; ValueOverflow				= 11
; AccessDenied				= 12
; UnknownImageFormat		= 13
; FontFamilyNotFound		= 14
; FontStyleNotFound			= 15
; NotTrueTypeFont			= 16
; UnsupportedGdiplusVersion	= 17
; GdiplusNotInitialized		= 18
; PropertyNotFound			= 19
; PropertyNotSupported		= 20
; ProfileNotFound			= 21
;
;#####################################################################################
;#####################################################################################
; FUNCTIONS
;#####################################################################################
;
; UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
; BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
; StretchBlt(dDC, dx, dy, dw, dh, sDC, sx, sy, sw, sh, Raster="")
; SetImage(hwnd, hBitmap)
; Gdip_BitmapFromScreen(Screen=0, Raster="")
; CreateRectF(ByRef RectF, x, y, w, h)
; CreateSizeF(ByRef SizeF, w, h)
; CreateDIBSection
;
;#####################################################################################

; Function:     			UpdateLayeredWindow
; Description:  			Updates a layered window with the handle to the DC of a gdi bitmap
; 
; hwnd        				Handle of the layered window to update
; hdc           			Handle to the DC of the GDI bitmap to update the window with
; Layeredx      			x position to place the window
; Layeredy      			y position to place the window
; Layeredw      			Width of the window
; Layeredh      			Height of the window
; Alpha         			Default = 255 : The transparency (0-255) to set the window transparency
;
; return      				If the function succeeds, the return value is nonzero
;
; notes						If x or y omitted, then layered window will use its current coordinates
;							If w or h omitted then current width and height will be used

UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
{
	if ((x != "") && (y != ""))
		VarSetCapacity(pt, 8), NumPut(x, pt, 0), NumPut(y, pt, 4)

	if (w = "") ||(h = "")
		WinGetPos,,, w, h, ahk_id %hwnd%
   
	return DllCall("UpdateLayeredWindow", "uint", hwnd, "uint", 0, "uint", ((x = "") && (y = "")) ? 0 : &pt
	, "int64*", w|h<<32, "uint", hdc, "int64*", 0, "uint", 0, "uint*", Alpha<<16|1<<24, "uint", 2)
}

;#####################################################################################

; Function				BitBlt
; Description			The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle 
;						of pixels from the specified source device context into a destination device context.
;
; dDC					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of the area to copy
; dh					height of the area to copy
; sDC					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; BLACKNESS				= 0x00000042
; NOTSRCERASE			= 0x001100A6
; NOTSRCCOPY			= 0x00330008
; SRCERASE				= 0x00440328
; DSTINVERT				= 0x00550009
; PATINVERT				= 0x005A0049
; SRCINVERT				= 0x00660046
; SRCAND				= 0x008800C6
; MERGEPAINT			= 0x00BB0226
; MERGECOPY				= 0x00C000CA
; SRCCOPY				= 0x00CC0020
; SRCPAINT				= 0x00EE0086
; PATCOPY				= 0x00F00021
; PATPAINT				= 0x00FB0A09
; WHITENESS				= 0x00FF0062
; CAPTUREBLT			= 0x40000000
; NOMIRRORBITMAP		= 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster="")
{
	return DllCall("gdi32\BitBlt", "uint", dDC, "int", dx, "int", dy, "int", dw, "int", dh
	, "uint", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				StretchBlt
; Description			The StretchBlt function copies a bitmap from a source rectangle into a destination rectangle, 
;						stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
;						The system stretches or compresses the bitmap according to the stretching mode currently set in the destination device context.
;
; ddc					handle to destination DC
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination rectangle
; dh					height of destination rectangle
; sdc					handle to source DC
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Raster				raster operation code
;
; return				If the function succeeds, the return value is nonzero
;
; notes					If no raster operation is specified, then SRCCOPY is used. It uses the same raster operations as BitBlt		

StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster="")
{
	return DllCall("gdi32\StretchBlt", "uint", ddc, "int", dx, "int", dy, "int", dw, "int", dh
	, "uint", sdc, "int", sx, "int", sy, "int", sw, "int", sh, "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function				SetStretchBltMode
; Description			The SetStretchBltMode function sets the bitmap stretching mode in the specified device context
;
; hdc					handle to the DC
; iStretchMode			The stretching mode, describing how the target will be stretched
;
; return				If the function succeeds, the return value is the previous stretching mode. If it fails it will return 0
;
; STRETCH_ANDSCANS 		= 0x01
; STRETCH_ORSCANS 		= 0x02
; STRETCH_DELETESCANS 	= 0x03
; STRETCH_HALFTONE 		= 0x04

SetStretchBltMode(hdc, iStretchMode=4)
{
	return DllCall("gdi32\SetStretchBltMode", "uint", hdc, "int", iStretchMode)
}

;#####################################################################################

; Function				SetImage
; Description			Associates a new image with a static control
;
; hwnd					handle of the control to update
; hBitmap				a gdi bitmap to associate the static control with
;
; return				If the function succeeds, the return value is nonzero

SetImage(hwnd, hBitmap)
{
	SendMessage, 0x172, 0x0, hBitmap,, ahk_id %hwnd%
	E := ErrorLevel
	DeleteObject(E)
	return E
}

;#####################################################################################

; Function				SetSysColorToControl
; Description			Sets a solid colour to a control
;
; hwnd					handle of the control to update
; SysColor				A system colour to set to the control
;
; return				If the function succeeds, the return value is zero
;
; notes					A control must have the 0xE style set to it so it is recognised as a bitmap
;						By default SysColor=15 is used which is COLOR_3DFACE. This is the standard background for a control
;
; COLOR_3DDKSHADOW				= 21
; COLOR_3DFACE					= 15
; COLOR_3DHIGHLIGHT				= 20
; COLOR_3DHILIGHT				= 20
; COLOR_3DLIGHT					= 22
; COLOR_3DSHADOW				= 16
; COLOR_ACTIVEBORDER			= 10
; COLOR_ACTIVECAPTION			= 2
; COLOR_APPWORKSPACE			= 12
; COLOR_BACKGROUND				= 1
; COLOR_BTNFACE					= 15
; COLOR_BTNHIGHLIGHT			= 20
; COLOR_BTNHILIGHT				= 20
; COLOR_BTNSHADOW				= 16
; COLOR_BTNTEXT					= 18
; COLOR_CAPTIONTEXT				= 9
; COLOR_DESKTOP					= 1
; COLOR_GRADIENTACTIVECAPTION	= 27
; COLOR_GRADIENTINACTIVECAPTION	= 28
; COLOR_GRAYTEXT				= 17
; COLOR_HIGHLIGHT				= 13
; COLOR_HIGHLIGHTTEXT			= 14
; COLOR_HOTLIGHT				= 26
; COLOR_INACTIVEBORDER			= 11
; COLOR_INACTIVECAPTION			= 3
; COLOR_INACTIVECAPTIONTEXT		= 19
; COLOR_INFOBK					= 24
; COLOR_INFOTEXT				= 23
; COLOR_MENU					= 4
; COLOR_MENUHILIGHT				= 29
; COLOR_MENUBAR					= 30
; COLOR_MENUTEXT				= 7
; COLOR_SCROLLBAR				= 0
; COLOR_WINDOW					= 5
; COLOR_WINDOWFRAME				= 6
; COLOR_WINDOWTEXT				= 8

SetSysColorToControl(hwnd, SysColor=15)
{
   WinGetPos,,, w, h, ahk_id %hwnd%
   bc := DllCall("GetSysColor", "Int", SysColor)
   pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
   pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
   Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
   hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
   SetImage(hwnd, hBitmap)
   Gdip_DeleteBrush(pBrushClear)
   Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
   return 0
}

;#####################################################################################

; Function				Gdip_BitmapFromScreen
; Description			Gets a gdi+ bitmap from the screen
;
; Screen				0 = All screens
;						Any numerical value = Just that screen
;						x|y|w|h = Take specific coordinates with a width and height
; Raster				raster operation code
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1:		one or more of x,y,w,h not passed properly
;
; notes					If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen=0, Raster="")
{
	if (Screen = 0)
	{
		Sysget, x, 76
		Sysget, y, 77	
		Sysget, w, 78
		Sysget, h, 79
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:")
	{
		Screen := SubStr(Screen, 6)
		if !WinExist( "ahk_id " Screen)
			return -2
		WinGetPos,,, w, h, ahk_id %Screen%
		x := y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if (Screen&1 != "")
	{
		Sysget, M, Monitor, %Screen%
		x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
	}
	else
	{
		StringSplit, S, Screen, |
		x := S1, y := S2, w := S3, h := S4
	}

	if (x = "") || (y = "") || (w = "") || (h = "")
		return -1

	chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
	ReleaseDC(hhdc)
	
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_BitmapFromHWND
; Description			Uses PrintWindow to get a handle to the specified window and return a bitmap from it
;
; hwnd					handle to the window to get a bitmap from
;
; return				If the function succeeds, the return value is a pointer to a gdi+ bitmap
;
; notes					Window must not be not minimised in order to get a handle to it's client area

Gdip_BitmapFromHWND(hwnd)
{
	WinGetPos,,, Width, Height, ahk_id %hwnd%
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}

;#####################################################################################

; Function    			CreateRectF
; Description			Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRectF(ByRef RectF, x, y, w, h)
{
   VarSetCapacity(RectF, 16)
   NumPut(x, RectF, 0, "float"), NumPut(y, RectF, 4, "float"), NumPut(w, RectF, 8, "float"), NumPut(h, RectF, 12, "float")
}

;#####################################################################################

; Function    			CreateRect
; Description			Creates a Rect object, containing a the coordinates and dimensions of a rectangle
;
; RectF       			Name to call the RectF object
; x            			x-coordinate of the upper left corner of the rectangle
; y            			y-coordinate of the upper left corner of the rectangle
; w            			Width of the rectangle
; h            			Height of the rectangle
;
; return      			No return value

CreateRect(ByRef Rect, x, y, w, h)
{
	VarSetCapacity(Rect, 16)
	NumPut(x, Rect, 0, "uint"), NumPut(y, Rect, 4, "uint"), NumPut(w, Rect, 8, "uint"), NumPut(h, Rect, 12, "uint")
}
;#####################################################################################

; Function		    	CreateSizeF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreateSizeF(ByRef SizeF, w, h)
{
   VarSetCapacity(SizeF, 8)
   NumPut(w, SizeF, 0, "float"), NumPut(h, SizeF, 4, "float")     
}
;#####################################################################################

; Function		    	CreatePointF
; Description			Creates a SizeF object, containing an 2 values
;
; SizeF         		Name to call the SizeF object
; w            			w-value for the SizeF object
; h            			h-value for the SizeF object
;
; return      			No Return value

CreatePointF(ByRef PointF, x, y)
{
   VarSetCapacity(PointF, 8)
   NumPut(x, PointF, 0, "float"), NumPut(y, PointF, 4, "float")     
}
;#####################################################################################

; Function				CreateDIBSection
; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w						width of the bitmap to create
; h						height of the bitmap to create
; hdc					a handle to the device context to use the palette from
; bpp					bits per pixel (32 = ARGB)
; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return				returns a DIB. A gdi bitmap
;
; notes					ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
{
	hdc2 := hdc ? hdc : GetDC()
	VarSetCapacity(bi, 40, 0)
	NumPut(w, bi, 4), NumPut(h, bi, 8), NumPut(40, bi, 0), NumPut(1, bi, 12, "ushort"), NumPut(0, bi, 16), NumPut(bpp, bi, 14, "ushort")
	hbm := DllCall("CreateDIBSection", "uint" , hdc2, "uint" , &bi, "uint" , 0, "uint*", ppvBits, "uint" , 0, "uint" , 0)

	if !hdc
		ReleaseDC(hdc2)
	return hbm
}

;#####################################################################################

; Function				PrintWindow
; Description			The PrintWindow function copies a visual window into the specified device context (DC), typically a printer DC
;
; hwnd					A handle to the window that will be copied
; hdc					A handle to the device context
; Flags					Drawing options
;
; return				If the function succeeds, it returns a nonzero value
;
; PW_CLIENTONLY			= 1

PrintWindow(hwnd, hdc, Flags=0)
{
	return DllCall("PrintWindow", "uint", hwnd, "uint", hdc, "uint", Flags)
}

;#####################################################################################

; Function				DestroyIcon
; Description			Destroys an icon and frees any memory the icon occupied
;
; hIcon					Handle to the icon to be destroyed. The icon must not be in use
;
; return				If the function succeeds, the return value is nonzero

DestroyIcon(hIcon)
{
   return DllCall("DestroyIcon", "uint", hIcon)
}

;#####################################################################################

PaintDesktop(hdc)
{
	return DllCall("PaintDesktop", "uint", hdc)
}

;#####################################################################################

CreateCompatibleBitmap(hdc, w, h)
{
	return DllCall("gdi32\CreateCompatibleBitmap", "uint", hdc, "int", w, "int", h)
}

;#####################################################################################

; Function				CreateCompatibleDC
; Description			This function creates a memory device context (DC) compatible with the specified device
;
; hdc					Handle to an existing device context					
;
; return				returns the handle to a device context or 0 on failure
;
; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc=0)
{
   return DllCall("CreateCompatibleDC", "uint", hdc)
}

;#####################################################################################

; Function				SelectObject
; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc					Handle to a DC
; hgdiobj				A handle to the object to be selected into the DC
;
; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes					The specified object must have been created by using one of the following functions
;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;						Font - CreateFont, CreateFontIndirect
;						Pen - CreatePen, CreatePenIndirect
;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION			= 2 Region consists of a single rectangle
; COMPLEXREGION			= 3 Region consists of more than one rectangle
; NULLREGION			= 1 Region is empty

SelectObject(hdc, hgdiobj)
{
   return DllCall("SelectObject", "uint", hdc, "uint", hgdiobj)
}

;#####################################################################################

; Function				DeleteObject
; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;						After the object is deleted, the specified handle is no longer valid
;
; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject)
{
   return DllCall("DeleteObject", "uint", hObject)
}

;#####################################################################################

; Function				GetDC
; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window. 
;
; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen					
;
; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd=0)
{
	return DllCall("GetDC", "uint", hwnd)
}

;#####################################################################################

; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags=0, hrgnClip=0)
{
    return DllCall("GetDCEx", "uint", hwnd, "uint", hrgnClip, "int", flags)
}

;#####################################################################################

; Function				ReleaseDC
; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc					Handle to the device context to be released
; hwnd					Handle to the window whose device context is to be released
;
; return				1 = released
;						0 = not released
;
; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function. 

ReleaseDC(hdc, hwnd=0)
{
   return DllCall("ReleaseDC", "uint", hwnd, "uint", hdc)
}

;#####################################################################################

; Function				DeleteDC
; Description			The DeleteDC function deletes the specified device context (DC)
;
; hdc					A handle to the device context
;
; return				If the function succeeds, the return value is nonzero
;
; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc)
{
   return DllCall("DeleteDC", "uint", hdc)
}
;#####################################################################################

; Function				Gdip_LibraryVersion
; Description			Get the current library version
;
; return				the library version
;
; notes					This is useful for non compiled programs to ensure that a person doesn't run an old version when testing your scripts

Gdip_LibraryVersion()
{
	return 1.45
}

;#####################################################################################

; Function:    			Gdip_BitmapFromBRA
; Description: 			Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn			The variable for a BRA file read to memory
; File					The name of the file, or its number that you would like (This depends on alternate parameter)
; Alternate				Changes whether the File parameter is the file name or its number
;
; return      			If the function succeeds, the return value is a pointer to a gdi+ bitmap
;						-1 = The BRA variable is empty
;						-2 = The BRA has an incorrect header
;						-3 = The BRA has information missing
;						-4 = Could not find file inside the BRA

Gdip_BitmapFromBRA(ByRef BRAFromMemIn, File, Alternate=0)
{
	if !BRAFromMemIn
		return -1
	Loop, Parse, BRAFromMemIn, `n
	{
		if (A_Index = 1)
		{
			StringSplit, Header, A_LoopField, |
			if (Header0 != 4 || Header2 != "BRA!")
				return -2
		}
		else if (A_Index = 2)
		{
			StringSplit, Info, A_LoopField, |
			if (Info0 != 3)
				return -3
		}
		else
			break
	}
	if !Alternate
		StringReplace, File, File, \, \\, All
	RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", FileInfo)
	if !FileInfo
		return -4

	hData := DllCall("GlobalAlloc", "uint", 2, "uint", FileInfo2)
	pData := DllCall("GlobalLock", "uint", hData)
	DllCall("RtlMoveMemory", "uint", pData, "uint", &BRAFromMemIn+Info2+FileInfo1, "uint", FileInfo2)
	DllCall("GlobalUnlock", "uint", hData)
	DllCall("ole32\CreateStreamOnHGlobal", "uint", hData, "int", 1, "uint*", pStream)
	DllCall("gdiplus\GdipCreateBitmapFromStream", "uint", pStream, "uint*", pBitmap)
	DllCall(NumGet(NumGet(1*pStream)+8), "uint", pStream)
	return pBitmap
}

;#####################################################################################

; Function				Gdip_DrawRectangle
; Description			This function uses a pen to draw the outline of a rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
   return DllCall("gdiplus\GdipDrawRectangle", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawRoundedRectangle
; Description			This function uses a pen to draw the outline of a rounded rectangle into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
	Gdip_ResetClip(pGraphics)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
	Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_ResetClip(pGraphics)
	return E
}

;#####################################################################################

; Function				Gdip_DrawEllipse
; Description			This function uses a pen to draw the outline of an ellipse into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the top left of the rectangle the ellipse will be drawn into
; y						y-coordinate of the top left of the rectangle the ellipse will be drawn into
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
   return DllCall("gdiplus\GdipDrawEllipse", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_DrawBezier
; Description			This function uses a pen to draw the outline of a bezier (a weighted curve) into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the bezier
; y1					y-coordinate of the start of the bezier
; x2					x-coordinate of the first arc of the bezier
; y2					y-coordinate of the first arc of the bezier
; x3					x-coordinate of the second arc of the bezier
; y3					y-coordinate of the second arc of the bezier
; x4					x-coordinate of the end of the bezier
; y4					y-coordinate of the end of the bezier
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
   return DllCall("gdiplus\GdipDrawBezier", "uint", pgraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2
   , "float", x3, "float", y3, "float", x4, "float", y4)
}

;#####################################################################################

; Function				Gdip_DrawArc
; Description			This function uses a pen to draw the outline of an arc into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the arc
; y						y-coordinate of the start of the arc
; w						width of the arc
; h						height of the arc
; StartAngle			specifies the angle between the x-axis and the starting point of the arc
; SweepAngle			specifies the angle between the starting and ending points of the arc
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipDrawArc", "uint", pGraphics, "uint", pPen, "float", x
   , "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawPie
; Description			This function uses a pen to draw the outline of a pie into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x						x-coordinate of the start of the pie
; y						y-coordinate of the start of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success
;
; notes					as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipDrawPie", "uint", pGraphics, "uint", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_DrawLine
; Description			This function uses a pen to draw a line into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; x1					x-coordinate of the start of the line
; y1					y-coordinate of the start of the line
; x2					x-coordinate of the end of the line
; y2					y-coordinate of the end of the line
;
; return				status enumeration. 0 = success		

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
   return DllCall("gdiplus\GdipDrawLine", "uint", pGraphics, "uint", pPen
   , "float", x1, "float", y1, "float", x2, "float", y2)
}

;#####################################################################################

; Function				Gdip_DrawLines
; Description			This function uses a pen to draw a series of joined lines into the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pPen					Pointer to a pen
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success				

Gdip_DrawLines(pGraphics, pPen, Points)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)   
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }
   return DllCall("gdiplus\GdipDrawLines", "uint", pGraphics, "uint", pPen, "uint", &PointF, "int", Points0)
}

;#####################################################################################

; Function				Gdip_FillRectangle
; Description			This function uses a brush to fill a rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rectangle
; y						y-coordinate of the top left of the rectangle
; w						width of the rectanlge
; h						height of the rectangle
;
; return				status enumeration. 0 = success

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
   return DllCall("gdiplus\GdipFillRectangle", "uint", pGraphics, "int", pBrush
   , "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRoundedRectangle
; Description			This function uses a brush to fill a rounded rectangle in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the rounded rectangle
; y						y-coordinate of the top left of the rounded rectangle
; w						width of the rectanlge
; h						height of the rectangle
; r						radius of the rounded corners
;
; return				status enumeration. 0 = success

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return E
}

;#####################################################################################

; Function				Gdip_FillPolygon
; Description			This function uses a brush to fill a polygon in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Points				the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return				status enumeration. 0 = success
;
; notes					Alternate will fill the polygon as a whole, wheras winding will fill each new "segment"
; Alternate 			= 0
; Winding 				= 1

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode=0)
{
   StringSplit, Points, Points, |
   VarSetCapacity(PointF, 8*Points0)   
   Loop, %Points0%
   {
      StringSplit, Coord, Points%A_Index%, `,
      NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
   }   
   return DllCall("gdiplus\GdipFillPolygon", "uint", pGraphics, "uint", pBrush, "uint", &PointF, "int", Points0, "int", FillMode)
}

;#####################################################################################

; Function				Gdip_FillPie
; Description			This function uses a brush to fill a pie in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the pie
; y						y-coordinate of the top left of the pie
; w						width of the pie
; h						height of the pie
; StartAngle			specifies the angle between the x-axis and the starting point of the pie
; SweepAngle			specifies the angle between the starting and ending points of the pie
;
; return				status enumeration. 0 = success

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
   return DllCall("gdiplus\GdipFillPie", "uint", pGraphics, "uint", pBrush
   , "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

;#####################################################################################

; Function				Gdip_FillEllipse
; Description			This function uses a brush to fill an ellipse in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; x						x-coordinate of the top left of the ellipse
; y						y-coordinate of the top left of the ellipse
; w						width of the ellipse
; h						height of the ellipse
;
; return				status enumeration. 0 = success

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	return DllCall("gdiplus\GdipFillEllipse", "uint", pGraphics, "uint", pBrush, "float", x, "float", y, "float", w, "float", h)
}

;#####################################################################################

; Function				Gdip_FillRegion
; Description			This function uses a brush to fill a region in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Region
;
; return				status enumeration. 0 = success
;
; notes					You can create a region Gdip_CreateRegion() and then add to this

Gdip_FillRegion(pGraphics, pBrush, Region)
{
	return DllCall("gdiplus\GdipFillRegion", "uint", pGraphics, "uint", pBrush, "uint", Region)
}

;#####################################################################################

; Function				Gdip_FillPath
; Description			This function uses a brush to fill a path in the Graphics of a bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBrush				Pointer to a brush
; Region				Pointer to a Path
;
; return				status enumeration. 0 = success

Gdip_FillPath(pGraphics, pBrush, Path)
{
	return DllCall("gdiplus\GdipFillPath", "uint", pGraphics, "uint", pBrush, "uint", Path)
}

;#####################################################################################

; Function				Gdip_DrawImagePointsRect
; Description			This function draws a bitmap into the Graphics of another bitmap and skews it
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; Points				Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left) describing the drawing of the bitmap
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source rectangle
; sh					height of source rectangle
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx="", sy="", sw="", sh="", Matrix=1)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}

	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
		
	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}

	E := DllCall("gdiplus\GdipDrawImagePointsRect", "uint", pGraphics, "uint", pBitmap
	, "uint", &PointF, "int", Points0, "float", sx, "float", sy, "float", sw, "float", sh
	, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_DrawImage
; Description			This function draws a bitmap into the Graphics of another bitmap
;
; pGraphics				Pointer to the Graphics of a bitmap
; pBitmap				Pointer to a bitmap to be drawn
; dx					x-coord of destination upper-left corner
; dy					y-coord of destination upper-left corner
; dw					width of destination image
; dh					height of destination image
; sx					x-coordinate of source upper-left corner
; sy					y-coordinate of source upper-left corner
; sw					width of source image
; sh					height of source image
; Matrix				a matrix used to alter image attributes when drawing
;
; return				status enumeration. 0 = success
;
; notes					if sx,sy,sw,sh are missed then the entire source bitmap will be used
;						Gdip_DrawImage performs faster
;						Matrix can be omitted to just draw with no alteration to ARGB
;						Matrix may be passed as a digit from 0 - 1 to change just transparency
;						Matrix can be passed as a matrix with any delimiter. For example:
;						MatrixBright=
;						(
;						1.5		|0		|0		|0		|0
;						0		|1.5	|0		|0		|0
;						0		|0		|1.5	|0		|0
;						0		|0		|0		|1		|0
;						0.05	|0.05	|0.05	|0		|1
;						)
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_DrawImage(pGraphics, pBitmap, dx="", dy="", dw="", dh="", sx="", sy="", sw="", sh="", Matrix=1)
{
	if (Matrix&1 = "")
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	E := DllCall("gdiplus\GdipDrawImageRectRect", "uint", pGraphics, "uint", pBitmap
	, "float", dx, "float", dy, "float", dw, "float", dh
	, "float", sx, "float", sy, "float", sw, "float", sh
	, "int", 2, "uint", ImageAttr, "uint", 0, "uint", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return E
}

;#####################################################################################

; Function				Gdip_SetImageAttributesColorMatrix
; Description			This function creates an image matrix ready for drawing
;
; Matrix				a matrix used to alter image attributes when drawing
;						passed with any delimeter
;
; return				returns an image matrix on sucess or 0 if it fails
;
; notes					MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;						MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;						MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|0|0|0|0|1

Gdip_SetImageAttributesColorMatrix(Matrix)
{
	VarSetCapacity(ColourMatrix, 100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", "", 1), "[^\d-\.]+", "|")
	StringSplit, Matrix, Matrix, |
	Loop, 25
	{
		Matrix := (Matrix%A_Index% != "") ? Matrix%A_Index% : Mod(A_Index-1, 6) ? 0 : 1
		NumPut(Matrix, ColourMatrix, (A_Index-1)*4, "float")
	}
	DllCall("gdiplus\GdipCreateImageAttributes", "uint*", ImageAttr)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "uint", ImageAttr, "int", 1, "int", 1, "uint", &ColourMatrix, "int", 0, "int", 0)
	return ImageAttr
}

;#####################################################################################

; Function				Gdip_GraphicsFromImage
; Description			This function gets the graphics for a bitmap used for drawing functions
;
; pBitmap				Pointer to a bitmap to get the pointer to its graphics
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					a bitmap can be drawn into the graphics of another bitmap

Gdip_GraphicsFromImage(pBitmap)
{
    DllCall("gdiplus\GdipGetImageGraphicsContext", "uint", pBitmap, "uint*", pGraphics)
    return pGraphics
}

;#####################################################################################

; Function				Gdip_GraphicsFromHDC
; Description			This function gets the graphics from the handle to a device context
;
; hdc					This is the handle to the device context
;
; return				returns a pointer to the graphics of a bitmap
;
; notes					You can draw a bitmap into the graphics of another bitmap

Gdip_GraphicsFromHDC(hdc)
{
    DllCall("gdiplus\GdipCreateFromHDC", "uint", hdc, "uint*", pGraphics)
    return pGraphics
}

;#####################################################################################

; Function				Gdip_GetDC
; Description			This function gets the device context of the passed Graphics
;
; hdc					This is the handle to the device context
;
; return				returns the device context for the graphics of a bitmap

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", "uint", pGraphics, "uint*", hdc)
	return hdc
}

;#####################################################################################

; Function				Gdip_ReleaseDC
; Description			This function releases a device context from use for further use
;
; pGraphics				Pointer to the graphics of a bitmap
; hdc					This is the handle to the device context
;
; return				status enumeration. 0 = success

Gdip_ReleaseDC(pGraphics, hdc)
{
	return DllCall("gdiplus\GdipReleaseDC", "uint", pGraphics, "uint", hdc)
}

;#####################################################################################

; Function				Gdip_GraphicsClear
; Description			Clears the graphics of a bitmap ready for further drawing
;
; pGraphics				Pointer to the graphics of a bitmap
; ARGB					The colour to clear the graphics to
;
; return				status enumeration. 0 = success
;
; notes					By default this will make the background invisible
;						Using clipping regions you can clear a particular area on the graphics rather than clearing the entire graphics

Gdip_GraphicsClear(pGraphics, ARGB=0x00ffffff)
{
    return DllCall("gdiplus\GdipGraphicsClear", "uint", pGraphics, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_BlurBitmap
; Description			Gives a pointer to a blurred bitmap from a pointer to a bitmap
;
; pBitmap				Pointer to a bitmap to be blurred
; Blur					The Amount to blur a bitmap by from 1 (least blur) to 100 (most blur)
;
; return				If the function succeeds, the return value is a pointer to the new blurred bitmap
;						-1 = The blur parameter is outside the range 1-100
;
; notes					This function will not dispose of the original bitmap

Gdip_BlurBitmap(pBitmap, Blur)
{
	if (Blur > 100) || (Blur < 1)
		return -1	
	
	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)
	return pBitmap2
}

;#####################################################################################

; Function:     		Gdip_SaveBitmapToFile
; Description:  		Saves a bitmap to a file in any supported format onto disk
;   
; pBitmap				Pointer to a bitmap
; sOutput      			The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality      			If saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return      			If the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality=75)
{
	SplitPath, sOutput,,, Extension
	if Extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
		return -1
	Extension := "." Extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
	VarSetCapacity(ci, nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uint", &ci)
	if !(nCount && nSize)
		return -2
   
	Loop, %nCount%
	{
		Location := NumGet(ci, 76*(A_Index-1)+44)
		if !A_IsUnicode
		{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			VarSetCapacity(sString, nSize)
			DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
			if !InStr(sString, "*" Extension)
				continue
		}
		else
		{
			nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int",  0, "uint", 0, "uint", 0)
			sString := ""
			Loop, %nSize%
				sString .= Chr(NumGet(Location+0, 2*(A_Index-1), "char"))
			if !InStr(sString, "*" Extension)
				continue
		}
		pCodec := &ci+76*(A_Index-1)
		break
	}
	if !pCodec
		return -3

	if (Quality != 75)
	{
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
		if Extension in .JPG,.JPEG,.JPE,.JFIF
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "uint", pBitmap, "uint", pCodec, "uint*", nSize)
			VarSetCapacity(EncoderParameters, nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "uint", pBitmap, "uint", pCodec, "uint", nSize, "uint", &EncoderParameters)
			Loop, % NumGet(EncoderParameters)      ;%
			{
				if (NumGet(EncoderParameters, (28*(A_Index-1))+20) = 1) && (NumGet(EncoderParameters, (28*(A_Index-1))+24) = 6)
				{
				   p := (28*(A_Index-1))+&EncoderParameters
				   NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20)))
				   break
				}
			}      
	  }
	}

	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wOutput, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sOutput, "int", -1, "uint", &wOutput, "int", nSize)
		VarSetCapacity(wOutput, -1)
		if !VarSetCapacity(wOutput)
			return -4
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &wOutput, "uint", pCodec, "uint", p ? p : 0)
	}
	else
		E := DllCall("gdiplus\GdipSaveImageToFile", "uint", pBitmap, "uint", &sOutput, "uint", pCodec, "uint", p ? p : 0)
	return E ? -5 : 0
}

;#####################################################################################

; Function				Gdip_GetPixel
; Description			Gets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				Returns the ARGB value of the pixel

Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", "uint", pBitmap, "int", x, "int", y, "uint*", ARGB)
	return ARGB
}

;#####################################################################################

; Function				Gdip_SetPixel
; Description			Sets the ARGB of a pixel in a bitmap
;
; pBitmap				Pointer to a bitmap
; x						x-coordinate of the pixel
; y						y-coordinate of the pixel
;
; return				status enumeration. 0 = success

Gdip_SetPixel(pBitmap, x, y, ARGB)
{
   return DllCall("gdiplus\GdipBitmapSetPixel", "uint", pBitmap, "int", x, "int", y, "int", ARGB)
}

;#####################################################################################

; Function				Gdip_GetImageWidth
; Description			Gives the width of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the width in pixels of the supplied bitmap

Gdip_GetImageWidth(pBitmap)
{
   DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
   return Width
}

;#####################################################################################

; Function				Gdip_GetImageHeight
; Description			Gives the height of a bitmap
;
; pBitmap				Pointer to a bitmap
;
; return				Returns the height in pixels of the supplied bitmap

Gdip_GetImageHeight(pBitmap)
{
   DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
   return Height
}

;#####################################################################################

; Function				Gdip_GetDimensions
; Description			Gives the width and height of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetImageDimensions(pBitmap, ByRef Width, ByRef Height)
{
	DllCall("gdiplus\GdipGetImageWidth", "uint", pBitmap, "uint*", Width)
	DllCall("gdiplus\GdipGetImageHeight", "uint", pBitmap, "uint*", Height)
}

;#####################################################################################

Gdip_GetDimensions(pBitmap, ByRef Width, ByRef Height)
{
	Gdip_GetImageDimensions(pBitmap, Width, Height)
}

;#####################################################################################

Gdip_GetImagePixelFormat(pBitmap)
{
	DllCall("gdiplus\GdipGetImagePixelFormat", "uint", pBitmap, "uint*", Format)
	return Format
}

;#####################################################################################

; Function				Gdip_GetDpiX
; Description			Gives the horizontal dots per inch of the graphics of a bitmap
;
; pBitmap				Pointer to a bitmap
; Width					ByRef variable. This variable will be set to the width of the bitmap
; Height				ByRef variable. This variable will be set to the height of the bitmap
;
; return				No return value
;						Gdip_GetDimensions(pBitmap, ThisWidth, ThisHeight) will set ThisWidth to the width and ThisHeight to the height

Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", "uint", pGraphics, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", "uint", pGraphics, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_GetImageHorizontalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHorizontalResolution", "uint", pBitmap, "float*", dpix)
	return Round(dpix)
}

;#####################################################################################

Gdip_GetImageVerticalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageVerticalResolution", "uint", pBitmap, "float*", dpiy)
	return Round(dpiy)
}

;#####################################################################################

Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
	return DllCall("gdiplus\GdipBitmapSetResolution", "uint", pBitmap, "float", dpix, "float", dpiy)
}

;#####################################################################################

Gdip_CreateBitmapFromFile(sFile, IconNumber=1, IconSize="")
{
	SplitPath, sFile,,, ext
	if ext in exe,dll
	{
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		VarSetCapacity(buf, 40)
		Loop, Parse, Sizes, |
		{
			DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, "uint*", hIcon, "uint*", 0, "uint", 1, "uint", 0)
			if !hIcon
				continue

			if !DllCall("GetIconInfo", "uint", hIcon, "uint", &buf)
			{
				DestroyIcon(hIcon)
				continue
			}
			hbmColor := NumGet(buf, 16)
			hbmMask  := NumGet(buf, 12)

			if !(hbmColor && DllCall("GetObject", "uint", hbmColor, "int", 24, "uint", &buf))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}
		if !hIcon
			return -1

		Width := NumGet(buf, 4, "int"),  Height := NumGet(buf, 8, "int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)

		if !DllCall("DrawIconEx", "uint", hdc, "int", 0, "int", 0, "uint", hIcon, "uint", Width, "uint", Height, "uint", 0, "uint", 0, "uint", 3)
		{
			DestroyIcon(hIcon)
			return -2
		}

		VarSetCapacity(dib, 84)
		DllCall("GetObject", "uint", hbm, "int", 84, "uint", &dib)
		Stride := NumGet(dib, 12), Bits := NumGet(dib, 20)

		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, "uint", Bits, "uint*", pBitmapOld)
		pBitmap := Gdip_CreateBitmap(Width, Height), G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)
	}
	else
	{
		if !A_IsUnicode
		{
			VarSetCapacity(wFile, 1023)
			DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sFile, "int", -1, "uint", &wFile, "int", 512)
			DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &wFile, "uint*", pBitmap)
		}
		else
			DllCall("gdiplus\GdipCreateBitmapFromFile", "uint", &sFile, "uint*", pBitmap)
	}
	return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette=0)
{
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uint", hBitmap, "uint", Palette, "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "uint", pBitmap, "uint*", hbm, "int", Background)
	return hbm
}

;#####################################################################################

Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", "uint", hIcon, "uint*", pBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", "uint", pBitmap, "uint*", hIcon)
	return hIcon
}

;#####################################################################################

Gdip_CreateBitmap(Width, Height, Format=0x26200A)
{
    DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, "uint", 0, "uint*", pBitmap)
    Return pBitmap
}

;#####################################################################################

Gdip_CreateBitmapFromClipboard()
{
	if !DllCall("OpenClipboard", "uint", 0)
		return -1
	if !DllCall("IsClipboardFormatAvailable", "uint", 8)
		return -2
	if !hBitmap := DllCall("GetClipboardData", "uint", 2)
		return -3
	if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
		return -4
	if !DllCall("CloseClipboard")
		return -5
	DeleteObject(hBitmap)
	return pBitmap
}

;#####################################################################################

Gdip_SetBitmapToClipboard(pBitmap)
{
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	DllCall("GetObject", "uint", hBitmap, "int", VarSetCapacity(oi, 84, 0), "uint", &oi)
	hdib := DllCall("GlobalAlloc", "uint", 2, "uint", 40+NumGet(oi, 44))
	pdib := DllCall("GlobalLock", "uint", hdib)
	DllCall("RtlMoveMemory", "uint", pdib, "uint", &oi+24, "uint", 40)
	DllCall("RtlMoveMemory", "Uint", pdib+40, "Uint", NumGet(oi, 20), "uint", NumGet(oi, 44))
	DllCall("GlobalUnlock", "uint", hdib)
	DllCall("DeleteObject", "uint", hBitmap)
	DllCall("OpenClipboard", "uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "uint", 8, "uint", hdib)
	DllCall("CloseClipboard")
}

;#####################################################################################

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h
	, "int", Format, "uint", pBitmap, "uint*", pBitmapDest)
	return pBitmapDest
}

;#####################################################################################
; Create resources
;#####################################################################################

Gdip_CreatePen(ARGB, w)
{
   DllCall("gdiplus\GdipCreatePen1", "int", ARGB, "float", w, "int", 2, "uint*", pPen)
   return pPen
}

;#####################################################################################

Gdip_CreatePenFromBrush(pBrush, w)
{
	DllCall("gdiplus\GdipCreatePen2", "uint", pBrush, "float", w, "int", 2, "uint*", pPen)
	return pPen
}

;#####################################################################################

Gdip_BrushCreateSolid(ARGB=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "int", ARGB, "uint*", pBrush)
	return pBrush
}

;#####################################################################################

; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle=0)
{
	DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "int", ARGBfront, "int", ARGBback, "uint*", pBrush)
	return pBrush
}

;#####################################################################################

Gdip_CreateTextureBrush(pBitmap, WrapMode=1, x=0, y=0, w="", h="")
{
	if !(w && h)
		DllCall("gdiplus\GdipCreateTexture", "uint", pBitmap, "int", WrapMode, "uint*", pBrush)
	else
		DllCall("gdiplus\GdipCreateTexture2", "uint", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, "uint*", pBrush)
	return pBrush
}

;#####################################################################################

; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode=1)
{
	CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", "uint", &PointF1, "uint", &PointF2, "int", ARGB1, "int", ARGB2, "int", WrapMode, "uint*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode=1, WrapMode=1)
{
	CreateRectF(RectF, x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", "uint", &RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "uint*", LGpBrush)
	return LGpBrush
}

;#####################################################################################

Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", "uint", pBrush, "uint*", pBrushClone)
	return pBrushClone
}

;#####################################################################################
; Delete resources
;#####################################################################################

Gdip_DeletePen(pPen)
{
   return DllCall("gdiplus\GdipDeletePen", "uint", pPen)
}

;#####################################################################################

Gdip_DeleteBrush(pBrush)
{
   return DllCall("gdiplus\GdipDeleteBrush", "uint", pBrush)
}

;#####################################################################################

Gdip_DisposeImage(pBitmap)
{
   return DllCall("gdiplus\GdipDisposeImage", "uint", pBitmap)
}

;#####################################################################################

Gdip_DeleteGraphics(pGraphics)
{
   return DllCall("gdiplus\GdipDeleteGraphics", "uint", pGraphics)
}

;#####################################################################################

Gdip_DisposeImageAttributes(ImageAttr)
{
	return DllCall("gdiplus\GdipDisposeImageAttributes", "uint", ImageAttr)
}

;#####################################################################################

Gdip_DeleteFont(hFont)
{
   return DllCall("gdiplus\GdipDeleteFont", "uint", hFont)
}

;#####################################################################################

Gdip_DeleteStringFormat(hFormat)
{
   return DllCall("gdiplus\GdipDeleteStringFormat", "uint", hFormat)
}

;#####################################################################################

Gdip_DeleteFontFamily(hFamily)
{
   return DllCall("gdiplus\GdipDeleteFontFamily", "uint", hFamily)
}

;#####################################################################################

Gdip_DeleteMatrix(Matrix)
{
   return DllCall("gdiplus\GdipDeleteMatrix", "uint", Matrix)
}

;#####################################################################################
; Text functions
;#####################################################################################

Gdip_TextToGraphics(pGraphics, Text, Options, Font="Arial", Width="", Height="", Measure=0)
{
	IWidth := Width, IHeight:= Height
	
	RegExMatch(Options, "i)X([\-\d\.]+)(p*)", xpos)
	RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", ypos)
	RegExMatch(Options, "i)W([\-\d\.]+)(p*)", Width)
	RegExMatch(Options, "i)H([\-\d\.]+)(p*)", Height)
	RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", Colour)
	RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", vPos)
	RegExMatch(Options, "i)NoWrap", NoWrap)
	RegExMatch(Options, "i)R(\d)", Rendering)
	RegExMatch(Options, "i)S(\d+)(p*)", Size)

	if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour2))
		PassBrush := 1, pBrush := Colour2
	
	if !(IWidth && IHeight) && (xpos2 || ypos2 || Width2 || Height2 || Size2)
		return -1

	Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	Loop, Parse, Styles, |
	{
		if RegExMatch(Options, "\b" A_loopField)
		Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
	}
  
	Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
	Loop, Parse, Alignments, |
	{
		if RegExMatch(Options, "\b" A_loopField)
			Align |= A_Index//2.1      ; 0|0|1|1|2|2
	}

	xpos := (xpos1 != "") ? xpos2 ? IWidth*(xpos1/100) : xpos1 : 0
	ypos := (ypos1 != "") ? ypos2 ? IHeight*(ypos1/100) : ypos1 : 0
	Width := Width1 ? Width2 ? IWidth*(Width1/100) : Width1 : IWidth
	Height := Height1 ? Height2 ? IHeight*(Height1/100) : Height1 : IHeight
	if !PassBrush
		Colour := "0x" (Colour2 ? Colour2 : "ff000000")
	Rendering := ((Rendering1 >= 0) && (Rendering1 <= 5)) ? Rendering1 : 4
	Size := (Size1 > 0) ? Size2 ? IHeight*(Size1/100) : Size1 : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)
	if !(hFamily && hFont && hFormat && pBrush && pGraphics)
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
   
	CreateRectF(RC, xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)

	if vPos
	{
		StringSplit, ReturnRC, ReturnRC, |
		
		if (vPos = "vCentre") || (vPos = "vCenter")
			ypos += (Height-ReturnRC4)//2
		else if (vPos = "Top") || (vPos = "Up")
			ypos := 0
		else if (vPos = "Bottom") || (vPos = "Down")
			ypos := Height-ReturnRC4
		
		CreateRectF(RC, xpos, ypos, Width, ReturnRC4)
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
	}

	if !Measure
		E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)

	if !PassBrush
		Gdip_DeleteBrush(pBrush)
	Gdip_DeleteStringFormat(hFormat)   
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)
	return E ? E : ReturnRC
}

;#####################################################################################

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, ByRef RectF)
{
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
		return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
		, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
	}
	else
	{
		return DllCall("gdiplus\GdipDrawString", "uint", pGraphics
		, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", pBrush)
	}	
}

;#####################################################################################

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, ByRef RectF)
{
	VarSetCapacity(RC, 16)
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wString, nSize*2)   
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &sString, "int", -1, "uint", &wString, "int", nSize)
		DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
		, "uint", &wString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
	}
	else
	{
		DllCall("gdiplus\GdipMeasureString", "uint", pGraphics
		, "uint", &sString, "int", -1, "uint", hFont, "uint", &RectF, "uint", hFormat, "uint", &RC, "uint*", Chars, "uint*", Lines)
	}
	return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}

; Near = 0
; Center = 1
; Far = 2
Gdip_SetStringFormatAlign(hFormat, Align)
{
   return DllCall("gdiplus\GdipSetStringFormatAlign", "uint", hFormat, "int", Align)
}

; StringFormatFlagsDirectionRightToLeft    = 0x00000001
; StringFormatFlagsDirectionVertical       = 0x00000002
; StringFormatFlagsNoFitBlackBox           = 0x00000004
; StringFormatFlagsDisplayFormatControl    = 0x00000020
; StringFormatFlagsNoFontFallback          = 0x00000400
; StringFormatFlagsMeasureTrailingSpaces   = 0x00000800
; StringFormatFlagsNoWrap                  = 0x00001000
; StringFormatFlagsLineLimit               = 0x00002000
; StringFormatFlagsNoClip                  = 0x00004000 
Gdip_StringFormatCreate(Format=0, Lang=0)
{
   DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, "uint*", hFormat)
   return hFormat
}

; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
Gdip_FontCreate(hFamily, Size, Style=0)
{
   DllCall("gdiplus\GdipCreateFont", "uint", hFamily, "float", Size, "int", Style, "int", 0, "uint*", hFont)
   return hFont
}

Gdip_FontFamilyCreate(Font)
{
	if !A_IsUnicode
	{
		nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", 0, "int", 0)
		VarSetCapacity(wFont, nSize*2)
		DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "uint", &Font, "int", -1, "uint", &wFont, "int", nSize)
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &wFont, "uint", 0, "uint*", hFamily)
	}
	else
		DllCall("gdiplus\GdipCreateFontFamilyFromName", "uint", &Font, "uint", 0, "uint*", hFamily)
	return hFamily
}

;#####################################################################################
; Matrix functions
;#####################################################################################

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
   DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, "uint*", Matrix)
   return Matrix
}

Gdip_CreateMatrix()
{
   DllCall("gdiplus\GdipCreateMatrix", "uint*", Matrix)
   return Matrix
}

;#####################################################################################
; GraphicsPath functions
;#####################################################################################

; Alternate = 0
; Winding = 1
Gdip_CreatePath(BrushMode=0)
{
	DllCall("gdiplus\GdipCreatePath", "int", BrushMode, "uint*", Path)
	return Path
}

Gdip_AddPathEllipse(Path, x, y, w, h)
{
	return DllCall("gdiplus\GdipAddPathEllipse", "uint", Path, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathPolygon(Path, Points)
{
	StringSplit, Points, Points, |
	VarSetCapacity(PointF, 8*Points0)   
	Loop, %Points0%
	{
		StringSplit, Coord, Points%A_Index%, `,
		NumPut(Coord1, PointF, 8*(A_Index-1), "float"), NumPut(Coord2, PointF, (8*(A_Index-1))+4, "float")
	}   

	return DllCall("gdiplus\GdipAddPathPolygon", "uint", Path, "uint", &PointF, "int", Points0)
}

Gdip_DeletePath(Path)
{
	return DllCall("gdiplus\GdipDeletePath", "uint", Path)
}

;#####################################################################################
; Quality functions
;#####################################################################################

; SystemDefault = 0
; SingleBitPerPixelGridFit = 1
; SingleBitPerPixel = 2
; AntiAliasGridFit = 3
; AntiAlias = 4
Gdip_SetTextRenderingHint(pGraphics, RenderingHint)
{
	return DllCall("gdiplus\GdipSetTextRenderingHint", "uint", pGraphics, "int", RenderingHint)
}

; Default = 0
; LowQuality = 1
; HighQuality = 2
; Bilinear = 3
; Bicubic = 4
; NearestNeighbor = 5
; HighQualityBilinear = 6
; HighQualityBicubic = 7
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
   return DllCall("gdiplus\GdipSetInterpolationMode", "uint", pGraphics, "int", InterpolationMode)
}

; Default = 0
; HighSpeed = 1
; HighQuality = 2
; None = 3
; AntiAlias = 4
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
   return DllCall("gdiplus\GdipSetSmoothingMode", "uint", pGraphics, "int", SmoothingMode)
}

; CompositingModeSourceOver = 0 (blended)
; CompositingModeSourceCopy = 1 (overwrite)
Gdip_SetCompositingMode(pGraphics, CompositingMode=0)
{
   return DllCall("gdiplus\GdipSetCompositingMode", "uint", pGraphics, "int", CompositingMode)
}

;#####################################################################################
; Extra functions
;#####################################################################################

Gdip_Startup()
{
	if !DllCall("GetModuleHandle", "str", "gdiplus")
		DllCall("LoadLibrary", "str", "gdiplus")
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "uint*", pToken, "uint", &si, "uint", 0)
	return pToken
}

Gdip_Shutdown(pToken)
{
	DllCall("gdiplus\GdiplusShutdown", "uint", pToken)
	if hModule := DllCall("GetModuleHandle", "str", "gdiplus")
		DllCall("FreeLibrary", "uint", hModule)
	return 0
}

; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipRotateWorldTransform", "uint", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipScaleWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder=0)
{
	return DllCall("gdiplus\GdipTranslateWorldTransform", "uint", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_ResetWorldTransform(pGraphics)
{
	return DllCall("gdiplus\GdipResetWorldTransform", "uint", pGraphics)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, ByRef xTranslation, ByRef yTranslation)
{
	pi := 3.14159, TAngle := Angle*(pi/180)	

	Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
	if ((Bound >= 0) && (Bound <= 90))
		xTranslation := Height*Sin(TAngle), yTranslation := 0
	else if ((Bound > 90) && (Bound <= 180))
		xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
	else if ((Bound > 180) && (Bound <= 270))
		xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
	else if ((Bound > 270) && (Bound <= 360))
		xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, ByRef RWidth, ByRef RHeight)
{
	pi := 3.14159, TAngle := Angle*(pi/180)
	if !(Width && Height)
		return -1
	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

; RotateNoneFlipNone   = 0
; Rotate90FlipNone     = 1
; Rotate180FlipNone    = 2
; Rotate270FlipNone    = 3
; RotateNoneFlipX      = 4
; Rotate90FlipX        = 5
; Rotate180FlipX       = 6
; Rotate270FlipX       = 7
; RotateNoneFlipY      = Rotate180FlipX
; Rotate90FlipY        = Rotate270FlipX
; Rotate180FlipY       = RotateNoneFlipX
; Rotate270FlipY       = Rotate90FlipX
; RotateNoneFlipXY     = Rotate180FlipNone
; Rotate90FlipXY       = Rotate270FlipNone
; Rotate180FlipXY      = RotateNoneFlipNone
; Rotate270FlipXY      = Rotate90FlipNone 

Gdip_ImageRotateFlip(pBitmap, RotateFlipType=1)
{
	return DllCall("gdiplus\GdipImageRotateFlip", "uint", pBitmap, "int", RotateFlipType)
}

; Replace = 0
; Intersect = 1
; Union = 2
; Xor = 3
; Exclude = 4
; Complement = 5
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipRect", "uint", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}

Gdip_SetClipPath(pGraphics, Path, CombineMode=0)
{
   return DllCall("gdiplus\GdipSetClipPath", "uint", pGraphics, "uint", Path, "int", CombineMode)
}

Gdip_ResetClip(pGraphics)
{
   return DllCall("gdiplus\GdipResetClip", "uint", pGraphics)
}

Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", "uint" pGraphics, "uint*", Region)
	return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode=0)
{
	return DllCall("gdiplus\GdipSetClipRegion", "uint", pGraphics, "uint", Region, "int", CombineMode)
}

Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "uint*", Region)
	return Region
}

Gdip_DeleteRegion(Region)
{
	return DllCall("gdiplus\GdipDeleteRegion", "uint", Region)
}

;#####################################################################################
; BitmapLockBits
;#####################################################################################

Gdip_LockBits(pBitmap, x, y, w, h, ByRef Stride, ByRef Scan0, ByRef BitmapData, LockMode = 3, PixelFormat = 0x26200a)
{   
	CreateRect(Rect, x, y, w, h)
	VarSetCapacity(BitmapData, 21, 0)
	E := DllCall("Gdiplus\GdipBitmapLockBits", "uint", pBitmap, "uint", &Rect, "uint", LockMode, "int", PixelFormat, "uint", &BitmapData)
	Stride := NumGet(BitmapData, 8)
	Scan0 := NumGet(BitmapData, 16)
	return E
}

;#####################################################################################

Gdip_UnlockBits(pBitmap, ByRef BitmapData)
{
	return DllCall("Gdiplus\GdipBitmapUnlockBits", "uint", pBitmap, "uint", &BitmapData)
}

;#####################################################################################

Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
	Numput(ARGB, Scan0+0, (x*4)+(y*Stride))
}

;#####################################################################################

Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
	return NumGet(Scan0+0, (x*4)+(y*Stride))
}

;#####################################################################################

Gdip_PixelateBitmap(pBitmap, ByRef pBitmapOut, BlockSize)
{
	static PixelateBitmap
	if !PixelateBitmap
	{
		MCode_PixelateBitmap := "83EC388B4424485355568B74245C99F7FE8B5C244C8B6C2448578BF88BCA894C241C897C243485FF0F8E2E0300008B44245"
		. "499F7FE897C24448944242833C089542418894424308944242CEB038D490033FF397C2428897C24380F8E750100008BCE0FAFCE894C24408DA4240000"
		. "000033C03BF08944241089442460894424580F8E8A0000008B5C242C8D4D028BD52BD183C203895424208D3CBB0FAFFE8BD52BD142895424248BD52BD"
		. "103F9897C24148974243C8BCF8BFE8DA424000000008B5C24200FB61C0B03C30FB619015C24588B5C24240FB61C0B015C24600FB61C11015C241083C1"
		. "0483EF0175D38B7C2414037C245C836C243C01897C241475B58B7C24388B6C244C8B5C24508B4C244099F7F9894424148B44245899F7F9894424588B4"
		. "4246099F7F9894424608B44241099F7F98944241085F60F8E820000008D4B028BC32BC18D68038B44242C8D04B80FAFC68BD32BD142895424248BD32B"
		. "D103C18944243C89742420EB038D49008BC88BFE0FB64424148B5C24248804290FB644245888010FB644246088040B0FB644241088040A83C10483EF0"
		. "175D58B44243C0344245C836C2420018944243C75BE8B4C24408B5C24508B6C244C8B7C2438473B7C2428897C24380F8C9FFEFFFF8B4C241C33D23954"
		. "24180F846401000033C03BF2895424108954246089542458895424148944243C0F8E82000000EB0233D2395424187E6F8B4C243003C80FAF4C245C8B4"
		. "424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC2408BFD2BFA8B54241889442424895424408B4424200FB614080FB60101542414"
		. "8B542424014424580FB6040A0FB61439014424600154241083C104836C24400175CF8B44243C403BC68944243C7C808B4C24188B4424140FAFCE99F7F"
		. "9894424148B44245899F7F9894424588B44246099F7F9894424608B44241099F7F98944241033C08944243C85F60F8E7F000000837C2418007E6F8B4C"
		. "243003C80FAF4C245C8B4424280FAFC68D530203CA8D0C818BC32BC283C003894424208BC32BC2408BFB2BFA8B54241889442424895424400FB644241"
		. "48B5424208804110FB64424580FB654246088018B4424248814010FB654241088143983C104836C24400175CF8B44243C403BC68944243C7C818B4C24"
		. "1C8B44245C0144242C01742430836C2444010F85F4FCFFFF8B44245499F7FE895424188944242885C00F8E890100008BF90FAFFE33D2897C243C89542"
		. "45489442438EB0233D233C03BCA89542410895424608954245889542414894424400F8E840000003BF27E738B4C24340FAFCE03C80FAF4C245C034C24"
		. "548D55028BC52BC283C003894424208BC52BC2408BFD03CA894424242BFA89742444908B5424200FB6040A0FB611014424148B442424015424580FB61"
		. "4080FB6040F015424600144241083C104836C24440175CF8B4424408B7C243C8B4C241C33D2403BC1894424400F8C7CFFFFFF8B44241499F7FF894424"
		. "148B44245899F7FF894424588B44246099F7FF894424608B44241099F7FF8944241033C08944244085C90F8E8000000085F67E738B4C24340FAFCE03C"
		. "80FAF4C245C034C24548D53028BC32BC283C003894424208BC32BC2408BFB03CA894424242BFA897424448D49000FB65424148B4424208814010FB654"
		. "24580FB644246088118B5424248804110FB644241088043983C104836C24440175CF8B4424408B7C243C8B4C241C403BC1894424407C808D04B500000"
		. "00001442454836C2438010F858CFEFFFF33D233C03BCA89542410895424608954245889542414894424440F8E9A000000EB048BFF33D2395424180F8E"
		. "7D0000008B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D550203CA8D0C818BC52BC283C003894424208BC52BC240894424248BC52BC28B54241"
		. "8895424548DA424000000008B5424200FB6140A015424140FB611015424588B5424240FB6140A015424600FB614010154241083C104836C24540175CF"
		. "8B4424448B4C241C403BC1894424440F8C6AFFFFFF0FAF4C24188B44241499F7F9894424148B44245899F7F9894424588B44246099F7F9894424608B4"
		. "4241099F7F98944241033C03944241C894424540F8E7B0000008B7C241885FF7E688B4C24340FAFCE03C80FAF4C245C8B4424280FAFC68D530203CA8D"
		. "0C818BC32BC283C003894424208BC32BC2408BEB894424242BEA0FB65424148B4424208814010FB65424580FB644246088118B5424248804110FB6442"
		. "41088042983C10483EF0175D18B442454403B44241C894424547C855F5E5D33C05B83C438C3"
		VarSetCapacity(PixelateBitmap, StrLen(MCode_PixelateBitmap)//2)
		Loop % StrLen(MCode_PixelateBitmap)//2		;%
			NumPut("0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1, "char")
	}

	Gdip_GetImageDimensions(pBitmap, Width, Height)
	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2

	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, Stride1, Scan01, BitmapData1)
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, Stride2, Scan02, BitmapData2)
	if (E1 || E2)
		return -3

	E := DllCall(&PixelateBitmap, "uint", Scan01, "uint", Scan02, "int", Width, "int", Height, "int", Stride1, "int", BlockSize)
	Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
	return 0
}

;#####################################################################################

Gdip_ToARGB(A, R, G, B)
{
	return (A << 24) | (R << 16) | (G << 8) | B
}

;#####################################################################################

Gdip_FromARGB(ARGB, ByRef A, ByRef R, ByRef G, ByRef B)
{
	A := (0xff000000 & ARGB) >> 24
	R := (0x00ff0000 & ARGB) >> 16
	G := (0x0000ff00 & ARGB) >> 8
	B := 0x000000ff & ARGB
}

;#####################################################################################

Gdip_AFromARGB(ARGB)
{
	return (0xff000000 & ARGB) >> 24
}

;#####################################################################################

Gdip_RFromARGB(ARGB)
{
	return (0x00ff0000 & ARGB) >> 16
}

;#####################################################################################

Gdip_GFromARGB(ARGB)
{
	return (0x0000ff00 & ARGB) >> 8
}

;#####################################################################################

Gdip_BFromARGB(ARGB)
{
	return 0x000000ff & ARGB
}

;=====================================================================================================================
; Shortcut for Numpad
;=====================================================================================================================
;Numpad ahk keys functions enable disable toggle

;---------------------------------------------------------------------------------------------------------------------
#IF (numpadkeytoggle=0)
;---------------------------------------------------------------------------------------------------------------------
;Key Combo, Reload, and Exit Script
Numpad3::
NumpadPgDn::
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
		Tooltip, %KeyPressCount% `n1. ScreenshotState `n2. Speed/UnRe_state `n3. Copy/Cut_State `n4. Play/Pause_State `n5. MediaKey_State `n6. Exit
	}
SetTimer, cKeyPressMonitor, 1000
return
cKeyPressMonitor:
If (KeyPressCount = 1)
	{
		scrstate:=!scrstate
		if (scrstate=0)
			{
				gosub, Screenshot1orScreenshot2State0
				MsgBox, 262144, Screenshot Key Press,
				(
					Screenshot  - 2 press
					`nRepeat last - 1 press
				) 
			}
		else if (scrstate=1)
			{
				gosub, Screenshot1orScreenshot2State1
				MsgBox, 262144, Screenshot Key Press,
				(
					Screenshot  - 1 press
					`nRepeat last - 2 press
				)
			} 	
	}
else if (KeyPressCount = 2) ;speed up down and undo redo
	{
		spustate := !spustate
		if (spustate=0)
			{
				gosub, SpeedUpDownor_State
			}
		else if (spustate=1)
			{
				gosub, UndoRedo_State
			} 
	}
else if (KeyPressCount = 3)
	{
		cpcstate := !cpcstate
		if (cpcstate=0)
			{
				gosub, copycutchoose
			}
		else if (cpcstate=1)
			{
				gosub, copylinkcopycutchoose
			} 
	}
else if (KeyPressCount = 4)
	{
		mdastate:=!mdastate
		if (mdastate = 1)
			{
				SplashTextOn,250,60,,Play/Pause for Bluestack
				Sleep 400
				SplashTextOff
				gosub, MediaPlay4AllorMediaPlay4NoxState1
			}
		else if (mdastate = 0)
			{
				SplashTextOn,250,60,,Play/Pause for all 
				Sleep 400
				SplashTextOff
				gosub, MediaPlay4AllorMediaPlay4NoxState0
			}
	}
else if (KeyPressCount = 5)
		{
			mdkystate := !mdkystate
			if (mdkystate=0)
				{
					if(ChoosePlayer=00)
						{
							gosub, mk4acDefault
						}
					else
						{
							gosub, mk4acPotPlayer
						}
				}
			else if (mdkystate=1)
				{
					gosub, mediakey4onenotechoose
				} 
		}
else if (KeyPressCount > 5)
	{
		SplashTextOn,150,40,,Exit Script
		Sleep 400
		SplashTextOff
		ExitApp
	}
KeyPressCount := 0
SetTimer, cKeyPressMonitor, Off
Tooltip,
return

;Sharex Screenshot
NumpadDiv::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, oKeyPressMonitor, 300
return
oKeyPressMonitor:
if (scrstate = 0)
    {
        If (KeyPressCount = 1)
            {
                SendInput, ^{PrintScreen}
            }
        else if (KeyPressCount > 1)
            {
                SendInput, ^+/
            }
    }
else if (scrstate = 1)
    {
        If (KeyPressCount > 1)
            {
                SendInput, ^{PrintScreen}
            }
        else if (KeyPressCount = 1)
            {
                SendInput, ^+/
            }
    }
KeyPressCount := 0
SetTimer, oKeyPressMonitor, Off
Tooltip,
return

;Paste
NumpadMult::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, twicepasteplainmonitor, 300
return
twicepasteplainmonitor:
if (pstpstplnste=0)
	{
		SendInput, ^v
	}
else if (pstpstplnste=1)
	{
        If (KeyPressCount = 1)
            {
                SendInput, ^v
                ToolTip, Paste
                Sleep 400
            }
        else if (KeyPressCount > 1)
            {
                if winexist("ahk_exe ONENOTE.EXE")
					{
					  	WinActivate
						send {AppsKey}t
						ToolTip, Paste Plain(OneNote)
						Sleep 400
					}
				else
					{
						SendInput, ^v
                		ToolTip, Paste
                		Sleep 400
					}
            }
    }
KeyPressCount := 0
SetTimer, twicepasteplainmonitor, Off
Tooltip,
return

;Copy and Cut
NumpadSub::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, vKeyPressMonitor, 550
return
vKeyPressMonitor:
if (cpcstate = 0)
    {
        If (KeyPressCount = 1)
            {
                SendInput, ^c
                ToolTip, Copy
                Sleep 400
            }
        else if (KeyPressCount > 1)
            {
                SendInput, ^x
                ToolTip, Cut
                Sleep 400
            }
    }
else if (cpcstate = 1)
    {
        If (KeyPressCount = 1) ;copy link to paragraph part
            {
                if winexist("ahk_exe ONENOTE.EXE")
					{
					  WinActivate
						send {AppsKey}p
						ToolTip, Copy Link to Paragraph(OneNote)
						Sleep 400
					}
            }
        else if (KeyPressCount = 2) 
            {
                SendInput, ^c
                ToolTip, Copy
                Sleep 400
            }	
		else if (KeyPressCount > 2)
			{
				SendInput, ^x
				ToolTip, Cut
				Sleep 400
			}
    }
KeyPressCount := 0
SetTimer, vKeyPressMonitor, Off
Tooltip,
return

;Record Start, Finish, and Pause
NumpadAdd::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, xKeyPressMonitor, 500
return

;Volume Down
Numpad2::Volume_Down
NumpadDown::Volume_Down

;Backward by 5sec
Numpad4::
NumpadLeft::
gosub, backwardbysec
return

;Play/Pause 
Numpad5::
NumpadClear::
gosub, playpausepress
return	

;Forward by 5sec
Numpad6::
NumpadRight::
gosub, forwardbysec
return

;Undo and Redo
Numpad1::
NumpadEnd::
if (spustate = 0)
	{
		if (ChoosePlayer=11)
			{
				SendInput, !+3
			}
		else if (ChoosePlayer=10)
			{
				SendInput, ^!7
			}
		else
			{
				SendInput, ^+7
			}
	}
else if (spustate = 1)
    {
        SendInput, ^z
    }
return

Numpad7::
NumpadHome::
if (spustate = 0)
	{
		if (ChoosePlayer=11)
			{
				SendInput, !+4
			}
		else if (ChoosePlayer=10)
			{
				SendInput, ^!8
			}
		else
			{
				SendInput, ^+8
			}
	}
else if (spustate = 1)
    {
        SendInput, ^y
    }
return

;new things pasted from here
;Volume up
Numpad8::Volume_up
NumpadUp::Volume_up

;Aimp Pause/Play
Numpad9::
NumpadPgUp::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, bKeyPressMonitor, 300
return
bKeyPressMonitor:
If (KeyPressCount = 1)
	{
		SendInput, ^!-
		ToolTip, Aimp Play/Pause
		Sleep 400
	}
else if (KeyPressCount > 1)
	{
		SendInput, ^!=
		ToolTip, AIMP Player
		Sleep 400
	}
KeyPressCount := 0
SetTimer, bKeyPressMonitor, Off
Tooltip,
return

;Special Functions Key
Numpad0::
NumpadIns::
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
		Tooltip, %KeyPressCount% `n1. Windows Clipboard `n2. Display Settings `n3. Recent Tasks `n4. Menu
	}
SetTimer, fKeyPressMonitor, 700
return
fKeyPressMonitor:
If (KeyPressCount = 1)
	{
		SendInput, #v
		SplashTextOn,210,40,,Windows Clipboard
		Sleep 500
		SplashTextOff
	}
else if (KeyPressCount = 2)
	{
		SendInput, ^+d
		SplashTextOn,210,40,,Display Settings
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 3)
	{
		SendInput, #{tab}
		SplashTextOn,210,40,,Recent Tasks
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount > 3)
	{
		Menu, MNFunctions, Show
		;MNFunctionmenu()
        ;Menu, MNFunctions, DeleteAll
		SetTimer, fKeyPressMonitor, Off
	}
KeyPressCount := 0
SetTimer, fKeyPressMonitor, Off
Tooltip,
return

;Scrip Play/Pause
NumpadDel::
NumpadDot::
Suspend, Toggle
SoundBeep, 500, 500
If (A_IsSuspended)
{
	Menu, Tray, Icon, %A_ScriptDir%\bin\icons\suspended.ico,,1
}
Else
{
	gosub, iconchanger
}
Return
;--------------------------------------------------------------------------------------------------------------------
#IF
;--------------------------------------------------------------------------------------------------------------------

;=====================================================================================================================
; Keyboard keys
;=====================================================================================================================

;--------------------------------------------------------------------------------------------------------------------
#IF (tklmode=01)
;--------------------------------------------------------------------------------------------------------------------
; Suppress ` + F1–F4 from triggering their default behavior
` & F1::return
` & F2::return
` & F3::return
` & F4::return

` & h::
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P")) ; Shift + Left 
        Send, +{Left}
	else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P")) ; Ctrl + Left
		Send, ^{Left} 
	else if (GetKeyState("Alt", "P") || GetKeyState("F3","P")) ; Alt + Left 
		Send, !{Left}
	else if GetKeyState("F4", "P") ; Win + Left
		Send, #{Left}{Esc}
    else ; Left
        Send, {Left}
return

` & k::
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P")) ; Shift + Up
        Send, +{Up}
	else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P")) ; Ctrl + Up
		Send, ^{Up} 
	else if (GetKeyState("Alt", "P") || GetKeyState("F3","P")) ; Alt + Up
		Send, !{Up}
	else if GetKeyState("F4", "P") ; Win + up
		Send, #{Up}{Esc}
    else ; Up
        Send, {Up}
return

` & j::
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P")) ; Shift + Down
        Send, +{Down}
	else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P")) ; Ctrl + Down
		Send, ^{Down} 
	else if (GetKeyState("Alt", "P") || GetKeyState("F3","P")) ; Alt + Down 
		Send, !{Down}
	else if GetKeyState("F4", "P") ; Win + Down
		Send, #{Down}{Esc}
    else ; Down
        Send, {Down}
return	

` & l::
    if (GetKeyState("Shift", "P") || GetKeyState("F1", "P")) ; Shift + Right
        Send, +{Right}
	else if (GetKeyState("Ctrl", "P") || GetKeyState("F2", "P")) ; Ctrl + Right
		Send, ^{Right} 
	else if (GetKeyState("Alt", "P") || GetKeyState("F3","P")) ; Alt + Right 
		Send, !{Right}
	else if GetKeyState("F4", "P") ; Win + Right
		Send, #{Right}{Esc}
    else ; Right
        Send, {Right}
return

+`::send {~} ; shift + ` = ~

`::`
;--------------------------------------------------------------------------------------------------------------------
#IF 
;--------------------------------------------------------------------------------------------------------------------

;more new files 2
;=====================================================================================================================
; Function keys
;=====================================================================================================================

;Icon switcher based on stage of fn keys
;Fn Script Play/Pause
;--------------------------------------------------------------------------------------------------------------------
#IF (fnstate=1)
;--------------------------------------------------------------------------------------------------------------------

;Key Combo, Reload, and Exit Script
F12::
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
		Tooltip, %KeyPressCount% `n1. ScreenshotState `n2. Speed/UnRe_state `n3. Copy/Cut_State `n4. Play/Pause_State `n5. MediaKey_State `n6. Exit
	}
SetTimer, cKeyPressMonitor, 1000
Return

;Sharex Screenshot
F6::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, oKeyPressMonitor, 300
return

;Paste and clibpoard
F7::
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
				Tooltip, %KeyPressCount% `n1. Paste `n3. Windows Clipboard 
			}
		else if (pstpstplnste=1)
			{
				Tooltip, %KeyPressCount% `n1. Paste `n2. Paste Plain `n3. Windows Clipboard 
			} 
	}
SetTimer, pastewmanager, 500
return
pastewmanager:
If (KeyPressCount = 1)
	{
		SendInput, ^v
	}
else if (KeyPressCount = 2)
	{
		if winexist("ahk_exe ONENOTE.EXE") AND pstpstplnste=1
			{
				WinActivate
				send {AppsKey}t
				ToolTip, Paste Plain(OneNote)
				Sleep 400
			}
		else 
			{
				SendInput, ^v
			}
	}
else if (KeyPressCount > 2)
	{
		SendInput, #v
		SplashTextOn,210,40,,Windows Clipboard
		Sleep 500
		SplashTextOff
	}
KeyPressCount := 0
SetTimer, pastewmanager, Off
Tooltip,
return

;Copy, Cut and Copy Link to Paragraph
F8::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, vKeyPressMonitor, 550
return

;Recording audio of the lectures for onenote
F9::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, xKeyPressMonitor, 500
return

;Speed slow and undo
F4::
if (spustate = 0)
    {
        if (ChoosePlayer=11)
			{
				SendInput, !+3
			}
		else if (ChoosePlayer=10)
			{
				SendInput, ^!7
			}
		else
			{
				SendInput, ^+7
			}
    }
else if (spustate = 1)
    {
        SendInput, ^z
    }
return

;Speed fast and Redo
F5::
if (spustate = 0)
	{
		if (ChoosePlayer=11)
			{
				SendInput, !+4
			}
		else if (ChoosePlayer=10)
			{
				SendInput, ^!8
			}
		else
			{
				SendInput, ^+8
			}
	}
else if (spustate = 1)
    {
        SendInput, ^y
    }
return

;Aimp Pause/Play
F10::
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
		Tooltip, %KeyPressCount%
	}
SetTimer, bKeyPressMonitor, 300
return

;Special Functions Key
F11::
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
		Tooltip, %KeyPressCount% `n1. Recent Tasks `n2. F12 `n3. Escape `n4. Menu
	}
SetTimer, spclonunfykm, 500
return
spclonunfykm:
If (KeyPressCount = 1)
	{
		SendInput, #{tab}
		SplashTextOn,210,40,,Recent Tasks 
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 2)
	{
		SendInput, {F12}
		SplashTextOn,210,40,, F12
		Sleep 500
		SplashTextOff
	}
else if (KeyPressCount = 3)
	{
		SendInput, {Esc}
		SplashTextOn,150,40,,Escape
		Sleep 500
		SplashTextOff
	}
else if (KeyPressCount > 3)
	{
		Menu, MNFunctions, Show
		;MNFunctionmenu()
        ;Menu, MNFunctions, DeleteAll
		SetTimer, spclonunfykm, Off
	}
KeyPressCount := 0
SetTimer, spclonunfykm, Off
Tooltip,
return

;Play/Pause 
F1::
gosub, playpausepress
return

;Backward by 5sec
F2::
gosub, backwardbysec
return

;Forward by 5sec
F3::
gosub, forwardbysec
return

;--------------------------------------------------------------------------------------------------------------------
#IF
;--------------------------------------------------------------------------------------------------------------------
;============================================================================================================
;Capslock || Numlock || Scrollock indicators
;============================================================================================================

;CapsLock & NumLock State
~CapsLock::
cste:=GetKeyState("CapsLock","T")
if (cste=1)
	{
	SplashTextOn,200,50,,CapsLock-On
	Sleep 500
	SplashTextOff
	}
else
	{
	SplashTextOn,200,50,,CapsLock-Off
	Sleep 500
	SplashTextOff
	}
return
/*
;--------------------------------------------------------------------------------------------------------------------
#IF (numpadkeytoggle=1)
;--------------------------------------------------------------------------------------------------------------------
~NumLock::
nste:=GetKeyState("NumLock","T")
if (nste=1)
	{
	SplashTextOn,200,50,,NumLock-On
	Sleep 500
	SplashTextOff
	}
else
	{
	SplashTextOn,200,50,,NumLock-Off
	Sleep 500
	SplashTextOff
	}
return
;--------------------------------------------------------------------------------------------------------------------
#IF
;--------------------------------------------------------------------------------------------------------------------
*/
~ScrollLock::
sste:=GetKeyState("ScrollLock","T")
if (sste=1)
	{
	SplashTextOn,200,50,,ScrollLock-On
	Sleep 500
	SplashTextOff
	}
else
	{
	SplashTextOn,200,50,,ScrollLock-Off
	Sleep 500
	SplashTextOff
	}
return

;============================================================================================================
;Ultimate state changer on pause | break key press
;============================================================================================================
SC16C::
Pause:: 
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
		Tooltip, %KeyPressCount% `n1. Fn AHK Key State `n2. Numpad AHK Key State 
	}
SetTimer, fnnumpadahkkeystate, 500
return
;============================================================================================================

;============================================================================================================
;Dedicated copilot key change to alt in portronics keyboard
;============================================================================================================

*F23::
Send {Alt down}
KeyWait, F23
Send {Alt up}
return

;============================================================================================================


