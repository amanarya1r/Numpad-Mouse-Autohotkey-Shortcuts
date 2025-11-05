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
;---------------------------------------------------------------------------------------; copycut, copylinkcopycut 4 onenote, copy audio or screenshot
Menu, copycutstate, Add, Copy || Cut, copycutchoose
Menu, copycutstate, Add, CopyLinkOneNote || Copy || Cut, copylinkcopycutchoose
Menu, copycutstate, Add, Copy Audio || Copy Screenshot, copyaudioorscreenshotchoose
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
;----------------------------------------------------------------------------------------;tkl, any keyboard navigation button to media button (<- to backward | -> to forward | ^ to speed up | v to speed down | 'Alt' to play pause)
Menu, spclnavigationbuttonmode, Add, ON, spclnavigationbuttonon
Menu, spclnavigationbuttonmode, Add, OFF, spclnavigationbuttonoff
if (spclnavbutm = 01){
	Menu, spclnavigationbuttonmode, check, ON
	Menu, spclnavigationbuttonmode, uncheck, OFF
} else if (spclnavbutm = 00){
	Menu, spclnavigationbuttonmode, uncheck, ON
	Menu, spclnavigationbuttonmode, check, OFF
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
Menu, clippingtoolselect, Add, Snipaste Screen Clipper, ahkscrnclipselect
Menu, clippingtoolselect, Add, Sharex Screen Clipper, sharexscrnclipselect
; condition statment is int bottom of Mnfunction
;----------------------------------------------------------------------------------------;Snipaste Screen Clipper activating button selector
Menu, ahkbtnselector, Add, Snipaste_ScrnClip - MButton, ahkscnclipmdlbtnselect
Menu, ahkbtnselector, Add, Snipaste_ScrnClip - RButton, ahkscncliprghtbtnselect
if (screenclipstate == 10){
	Menu, ahkbtnselector, uncheck, Snipaste_ScrnClip - MButton
    Menu, ahkbtnselector, check, Snipaste_ScrnClip - RButton
} else if (screenclipstate == 01){
	Menu, ahkbtnselector, check, Snipaste_ScrnClip - MButton
    Menu, ahkbtnselector, uncheck, Snipaste_ScrnClip - RButton
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
;----------------------------------------------------------------------------------------;

;======================================================================================
;Menu, Tray icons, menu and texts
Menu, Tray, NoStandard ;Pause reload and supsend will be removed 
Menu, Tray, Tip, Dumo - All Rounder(No Ahk-clipper)
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
Menu, Tray, Add, Keyboard Nav_Btn to Media_Control, :spclnavigationbuttonmode
Menu, Tray, Add
Menu, Tray, Add, ScrollWheel - State, :scrolledstate
Menu, Tray, Add, Mouse_Middle_Button State, :mousemdlbtnstate
Menu, Tray, Add, Mouse_Xtra_Buttons State, :mousextrbtnstate
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Clipping Tool, :clippingtoolselect
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Snipaste Clip Activate Button, :ahkbtnselector
Menu, Tray, Check, Snipaste Clip Activate Button
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
Menu, MNFunctions, Add, Keyboard Nav_Btn to Media_Control, :spclnavigationbuttonmode
Menu, MNFunctions, Add
Menu, MNFunctions, Add, ScrollWheel - State, :scrolledstate
Menu, MNFunctions, Add, Mouse_Middle_Button State, :mousemdlbtnstate
Menu, MNFunctions, Add, Mouse_Xtra_Buttons State, :mousextrbtnstate
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Clipping Tool, :clippingtoolselect
Menu, MNFunctions, Add
Menu, MNFunctions, Add
Menu, MNFunctions, Add, Snipaste Clip Activate Button, :ahkbtnselector
Menu, MNFunctions, Check, Snipaste Clip Activate Button
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
	Menu, clippingtoolselect, check, Snipaste Screen Clipper
	Menu, clippingtoolselect, uncheck, Sharex Screen Clipper
	Menu, Tray, check, Snipaste Clip Activate Button
	Menu, MNFunctions, check, Snipaste Clip Activate Button
	Menu, Tray, uncheck, Sharex Clip Activate Button
	Menu, MNFunctions, uncheck, Sharex Clip Activate Button
} else if (clipperchoose == 1){
	Menu, clippingtoolselect, uncheck, Snipaste Screen Clipper
	Menu, clippingtoolselect, check, Sharex Screen Clipper
	Menu, Tray, uncheck, Snipaste Clip Activate Button
	Menu, MNFunctions, uncheck, Snipaste Clip Activate Button
	Menu, Tray, check, Sharex Clip Activate Button
	Menu, MNFunctions, check, Sharex Clip Activate Button
}
;----------------------------------------------------------------------------------------

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
        SendInput ^!/  ; Trigger the Snipaste screen clipping action
        MiddleMouseDown := false  ; Reset the state to avoid multiple triggers
        SetTimer, CheckMiddleMouseLongPress, Off
    }
return

; Ensure the script doesn't terminate prematurely
#InstallKeybdHook
#InstallMouseHook


; ======= WheelUp + Left Mouse =======
~WheelUp::
    WinGetClass, winClass, A
    WinGet, winExe, ProcessName, A

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            Send, {ctrl down}
            Send, {c down}
            Sleep, 5
            Send, {c up}
            Send, {ctrl up}
            Sleep, 5
            SendInput {Escape}
        }
    }
return

; ======= WheelDown + Left Mouse =======
~WheelDown::
    WinGetClass, winClass, A
    WinGet, winExe, ProcessName, A

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            ; Sleep, 10
            Send, {Escape down}
            Send, {Escape up}
            SendInput ^+{PrintScreen}
        }
    }
return

~RButton::
    WinGetClass, winClass, A
    WinGet, winExe, ProcessName, A

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if GetKeyState("LButton", "P")  ; If left button is held
        {
            ; Hold Shift
            Send, {Shift down}

            ; Send middle click
            MouseClick, Middle

            ; Release Shift
            Send, {Shift up}
        }
    }
return




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
        SendInput ^!/  ; Trigger the Snipaste screen clipping action
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
; ======= WheelUp + Left Mouse =======
~WheelUp::
    WinGetClass, winClass, A
    WinGet, winExe, ProcessName, A

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            Send, {ctrl down}
            Send, {c down}
            Sleep, 5
            Send, {c up}
            Send, {ctrl up}
            Sleep, 5
            SendInput {Escape}
        }
    }
return

; ======= WheelDown + Left Mouse =======
~WheelDown::
    WinGetClass, winClass, A
    WinGet, winExe, ProcessName, A

    if (winClass = "Qt624QWindowToolSaveBits" && winExe = "Snipaste.exe")
    {
        if (GetKeyState("LButton", "P")) {
            ; Sleep, 10
            Send, {Escape down}
            Send, {Escape up}
            SendInput ^+{PrintScreen}
        }
    }
return


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
        SendInput ^+/
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
				Loop, C:\DaTa\#5. Music\Lecture_Recordings\*.mp3*
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
                SplashTextOn,300,70,, Recording Finshed 
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
				SplashTextOn,300,70,, Recording Started 
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
                SplashTextOn,300,70,,Recording Continue
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
                SplashTextOn,300,70,,Recording Paused
                Sleep 1000
                SplashTextOff
				;audiotext := "`n Recording Pause `n "
				audiotext := "Recording Paused"
				;SetTimer, FollowMouse, 10
            }
        else If (recstartv = 0)
            {
                ToolTip 
				SplashTextOn,350,70,,Recording Not Started
                ;ToolTip, % "`n Recording Not Started `n "
				ToolTip,    Recording Not Started
                Sleep 1000
				ToolTip
                SplashTextOff
            }
        else 
            {
                SplashTextOn,350,70,,Recording Not Started
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
		SendInput, !+5
	}
else if (mdastate=0) and (mdkystate=0) and (ChoosePlayer=00)
	{
		;SendInput, {Media_Play_Pause} 
		SendInput, ^+6
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

decundo:
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

incredo:
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
	cacstate:=0
	saveSetting("cpcstate", cpcstate, settingsFile)
	Menu, copycutstate, check, Copy || Cut
	Menu, copycutstate, uncheck, Copy Audio || Copy Screenshot
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
	cacstate:=0
	saveSetting("cpcstate", cpcstate, settingsFile)
	Menu, copycutstate, uncheck, Copy || Cut
	Menu, copycutstate, check, Copy Audio || Copy Screenshot
	Menu, copycutstate, uncheck, CopyLinkOneNote || Copy || Cut
	MsgBox, 262144, copylink/copy/cut,
	(
		copylink(onenote) - 1 press
					`ncopy - 2 press
				 	 `ncut - 3 press
	)  
}
Return

copyaudioorscreenshotchoose:
{
	cacstate:=1
	saveSetting("cacstate", cacstate, settingsFile)
	Menu, copycutstate, uncheck, Copy || Cut
	Menu, copycutstate, uncheck, CopyLinkOneNote || Copy || Cut
	Menu, copycutstate, check, Copy Audio || Copy Screenshot
	MsgBox, 262144, copy audio/screenshot,
	(
		copy audio - 1 press
		`ncopy screenshot - 2 press
	) 
}
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
	SplashTextOn,350,40,,Numpad AHK Keys Enable
	Sleep 800
	SplashTextOff
	gosub, iconchanger
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////
spclnavigationbuttonon:
{
	spclnavbutm := 01
	saveSetting("spclnavbutm", spclnavbutm, settingsFile)
	SoundBeep, 700, 800
	Menu, spclnavigationbuttonmode, check, ON
	Menu, spclnavigationbuttonmode, uncheck, OFF
	SplashTextOn, 350, 40,, NavBtn changed to Media_Control
	Sleep 800
	SplashTextOff
}
Return

spclnavigationbuttonoff:
{
	spclnavbutm := 00
	saveSetting("spclnavbutm", spclnavbutm, settingsFile)
	SoundBeep, 700, 800
	Menu, spclnavigationbuttonmode, uncheck, ON
	Menu, spclnavigationbuttonmode, check, OFF
	SplashTextOn, 350, 40,, NavBtn changed to Default
	Sleep 800
	SplashTextOff
}
Return

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
	Menu, clippingtoolselect, check, Snipaste Screen Clipper
	Menu, clippingtoolselect, uncheck, Sharex Screen Clipper
	Menu, Tray, check, Snipaste Clip Activate Button
	Menu, MNFunctions, check, Snipaste Clip Activate Button
	Menu, Tray, uncheck, Sharex Clip Activate Button
	Menu, MNFunctions, uncheck, Sharex Clip Activate Button
}
Return

sharexscrnclipselect:
{
	clipperchoose:=1
	saveSetting("clipperchoose", clipperchoose, settingsFile)
	Menu, clippingtoolselect, uncheck, Snipaste Screen Clipper
	Menu, clippingtoolselect, check, Sharex Screen Clipper
	Menu, Tray, uncheck, Snipaste Clip Activate Button
	Menu, MNFunctions, uncheck, Snipaste Clip Activate Button
	Menu, Tray, check, Sharex Clip Activate Button
	Menu, MNFunctions, check, Sharex Clip Activate Button
}
Return
;/////////////////////////////////////////////////////////////////////////////////////////////////

ahkscncliprghtbtnselect:
{
    screenclipstate := 10
	saveSetting("screenclipstate", screenclipstate, settingsFile)
	Menu, ahkbtnselector, uncheck, Snipaste_ScrnClip - MButton
    Menu, ahkbtnselector, check, Snipaste_ScrnClip - RButton
}
Return

ahkscnclipmdlbtnselect:
{
	screenclipstate := 01
	saveSetting("screenclipstate", screenclipstate, settingsFile)
	Menu, ahkbtnselector, check, Snipaste_ScrnClip - MButton
    Menu, ahkbtnselector, uncheck, Snipaste_ScrnClip - RButton
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
run, C:\DaTa\#5. Music\Lecture_Recordings
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

checkahkguisclipclosernmedia() ; minimize Snipaste GUI otherwise play media
{
    ; Get the handle of the window under the mouse cursor
    MouseGetPos,,, hWnd
    ; Get the class name of the window under the mouse cursor
    WinGetClass, className, ahk_id %hWnd%
    ; Get the process name of the window under the mouse cursor
    WinGet, processName, ProcessName, ahk_id %hWnd%
    ; Get the process ID of the window under the mouse cursor
    WinGet, windowPID, PID, ahk_id %hWnd%
    
    ; Check if the class name and process name match Snipaste
    if (className = "Qt624QWindowToolSaveBits" and processName = "Snipaste.exe")
    {
        ; Get the handle of the active window
        WinGet, activePID, PID, A
        ; Check if the active window and the window under the cursor are the same
        if (activePID = windowPID) {
            ; Simulate Ctrl+T to minimize/close the Snipaste overlay
            MouseClick, Middle
        }
    }
    else
    {
        gosub, mbclickplaypressmonitor4left
    }
Return
}


;---------------------------------------------------------------------------------------------------------------------
#IF (ChoosePlayer=10)
;---------------------------------------------------------------------------------------------------------------------
; Shortcut diversion for amazon mouse by which forward and backward keys does work on pot player 
; ChoosePlayer=10 is for choosing pot player

^+9::Send ^!9 ; Backward by -5 sec

^+0::Send ^!0 ; Forward by +5 sec

;--------------------------------------------------------------------------------------------------------------------
#IF
;--------------------------------------------------------------------------------------------------------------------

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
if (cpcstate = 0) And (cacstate=0)
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
else if (cpcstate = 1) And (cacstate=0)
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
Else
{
	If (KeyPressCount = 1)
		{
			; Retrieve files in a certain directory sorted by modification date:
			FileList :=  "" ; Initialize to be blank
			; Create a list of those files consisting of the time the file was modified and the file path separated by tab
			Loop, \\TIX\DaTa\#5. Music\Lecture_Recordings\*.mp3*
				FileList .= A_LoopFileTimeModified . "`t" . A_LoopFileLongPath . "`n"
			Sort, FileList, R  ;   ; Sort by time modified in reverse order
			Loop, Parse, FileList, `n
				{
					If (A_LoopField = "") ; omit the last linefeed (blank item) at the end of the list.
						Continue
					StringSplit, FileItem, A_LoopField, %A_Tab%  ; Split into two parts at the tab char
					; FileItem1 is FileTimeModified und FileItem2 is FileName
						ClipBoardSetFiles1(FileItem2)
						Break
				}

			ClipboardSetFiles1(FilesToSet, DropEffect := "Copy") {
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
			SplashTextOn,500,70,, Copied! Audio File
			audiotext := "Copied Audio File to Clipboard"
			Sleep 1000 
			SplashTextOff  
			SetTimer, FollowMouse, Off
			ToolTip        
		}
	else if (KeyPressCount > 1)
		{
			; Retrieve files in a certain directory sorted by modification date:
			FileList :=  "" ; Initialize to be blank
			; Create a list of those files consisting of the time the file was modified and the file path separated by tab
			Loop, \\TIX\DaTa\#4. ScreenShots\*.png*
				FileList .= A_LoopFileTimeModified . "`t" . A_LoopFileLongPath . "`n"
			Sort, FileList, R  ;   ; Sort by time modified in reverse order
			Loop, Parse, FileList, `n
				{
					If (A_LoopField = "") ; omit the last linefeed (blank item) at the end of the list.
						Continue
					StringSplit, FileItem, A_LoopField, %A_Tab%  ; Split into two parts at the tab char
					; FileItem1 is FileTimeModified und FileItem2 is FileName
						ClipBoardSetFiles2(FileItem2)
						Break
				}

			ClipboardSetFiles2(FilesToSet, DropEffect := "Copy") {
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
			SplashTextOn,500,70,, Copied! Screenshot
			audiotext := "Copied Screenshot to Clipboard"
			Sleep 1000 
			SplashTextOff  
			SetTimer, FollowMouse, Off
			ToolTip        
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
gosub, decundo
return

Numpad7::
NumpadHome::
gosub, incredo
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
gosub, decundo
return

;Speed fast and Redo
F5::
gosub, incredo
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

;=====================================================================================================================
; Navigation keys to Media Control
;=====================================================================================================================

;--------------------------------------------------------------------------------------------------------------------
#IF (spclnavbutm=01)
;--------------------------------------------------------------------------------------------------------------------

RAlt::
    gosub, playpausepress
return

; Hotkey for Left Arrow
Left::
    gosub, backwardbysec
return

; Hotkey for Right Arrow
Right::
    gosub, forwardbysec
return

Up::
	gosub, decundo
Return

Down::
	gosub, incredo
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


