;Menu, Tray icons and texts
Menu, Tray, Tip, numo - Numpad & Fn's Shortcuts assigner
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





;=====================================================================================================================
; Shortcut for Numpad
;=====================================================================================================================





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
Tooltip, % KeyPressCount
SetTimer, cKeyPressMonitor, 450
return
cKeyPressMonitor:
If (KeyPressCount = 1)
	{
		SplashTextOn,150,40,,Key Combo
		Sleep 400
		SplashTextOff
		^+!#Esc
	}
else if (KeyPressCount = 2)
	{
		SplashTextOn,150,40,,Reload Script
		Sleep 400
		SplashTextOff
		Reload
	}
else if (KeyPressCount = 3)
	{
		SplashTextOn,150,40,,Edit Script
		Sleep 400
		SplashTextOff
		Edit
	}
else if (KeyPressCount > 3)
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

/*
;Sharex Screenshot
NumpadDiv::^PrintScreen
*/

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
		Tooltip, % KeyPressCount
	}

SetTimer, oKeyPressMonitor, 300
return
oKeyPressMonitor:
If (KeyPressCount = 1)
	{
		SendInput, ^{PrintScreen}
	}
else if (KeyPressCount > 1)
	{
		SendInput, ^+/
	}
KeyPressCount := 0
SetTimer, oKeyPressMonitor, Off
Tooltip,
return

;Paste
NumpadMult::^v

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
		Tooltip, % KeyPressCount
	}
SetTimer, vKeyPressMonitor, 550
return
vKeyPressMonitor:
If (KeyPressCount = 1)
	{
		SendInput, ^c
		ToolTip, Copy
		Sleep 400
	}
else if (KeyPressCount = 2)
	{
		SendInput, ^x
		ToolTip, Cut
		Sleep 400
	}
else if (KeyPressCount > 2) ;copy link to paragraph part
	if winexist("ahk_exe ONENOTE.EXE")
		{
		  WinActivate
			send {AppsKey}p
			ToolTip, Copy Link to Paragraph(OneNote)
			Sleep 400
		}	
KeyPressCount := 0
SetTimer, vKeyPressMonitor, Off
Tooltip,
return

;Windows Clipboard and Display Settings
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
		Tooltip, % KeyPressCount
	}

SetTimer, xKeyPressMonitor, 300
return
xKeyPressMonitor:
If (KeyPressCount > 1)
	{
		SendInput, ^{Space}
		SplashTextOn,210,40,,Rec Pause/notStarted
		Sleep 500
		SplashTextOff
	}
else if (KeyPressCount = 1)
	{
		SendInput, ^+{Space}
		SplashTextOn,210,40,,Rec Started/Finished
		Sleep 500
		SplashTextOff
		#NoEnv
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
	}
KeyPressCount := 0
SetTimer, xKeyPressMonitor, Off
Tooltip,
return
/*
If (KeyPressCount = 1)
	{
		SendInput, #v
		SplashTextOn,210,40,,Windows Clipboard
		Sleep 500
		SplashTextOff
	}
else if (KeyPressCount > 2)
	{
		SendInput, ^+d
		SplashTextOn,210,40,,Display Settings
		Sleep 600
		SplashTextOff
	}
KeyPressCount := 0
SetTimer, xKeyPressMonitor, Off
Tooltip,
return
*/

;Volume Down
Numpad2::Volume_Down
NumpadDown::Volume_Down

;Backward by 5sec
Numpad4::^+9
NumpadLeft::^+9

;Play/Pause
Numpad5::Media_Play_Pause
NumpadClear::Media_Play_Pause

;Forward by 5sec
Numpad6::^+0
NumpadRight::^+0

;Undo and Redo
Numpad1::^+7
NumpadEnd::^+7
Numpad7::^+8
NumpadHome::^+8
/*
Numpad7::
NumpadHome::
SendInput, ^y
SplashTextOn,90,40,,Redo
Sleep 400
SplashTextOff
return
Numpad1::
NumpadEnd::
SendInput, ^z
SplashTextOn,90,40,,Undo
Sleep 400
SplashTextOff
return
*/
/*;Undo and Redo
Numpad7::
SendInput, ^y
SplashTextOn,95,40,NumLock-Off,Redo
Sleep 400
SplashTextOff
Return
NumpadHome::
SendInput, ^z
SplashTextOn,95,40,NumLock-On,Undo
Sleep 400
SplashTextOff
return
*/

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
		Tooltip, % KeyPressCount
	}

SetTimer, bKeyPressMonitor, 300
return
bKeyPressMonitor:
If (KeyPressCount = 1)
	{
		SendInput, ^-
		ToolTip, Aimp Play/Pause
		Sleep 400
	}
else if (KeyPressCount = 2)
	{
		SendInput, ^!0
		ToolTip, Aimp Player
		Sleep 400
	}
else if (KeyPressCount > 2)
	{
		SendInput, ^!0
		ToolTip, Aimp Player
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
		Tooltip, % KeyPressCount
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
		SplashTextOn,210,40,,Recent Tasks On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 4)
	{
		SendInput, {F11}
		SplashTextOn,210,40,,Full Screen Mode On/Off
		Sleep 600
		SplashTextOff
	}
KeyPressCount := 0
SetTimer, fKeyPressMonitor, Off
Tooltip,
return
/*
If (KeyPressCount = 1)
	{
		SendInput, #{tab}
		SplashTextOn,210,40,,Recent Tasks On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 2)
	{
		SendInput, {f}
		SplashTextOn,210,40,,Full Screen Player On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 3)
	{
		SendInput, {F11}
		SplashTextOn,210,40,,Full Screen Mode On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 4)
	{
		SendInput, {Esc}
		SplashTextOn,150,40,,Escape
		Sleep 600
		SplashTextOff
	}
*/

;Scrip Play/Pause
NumpadDel::
NumpadDot::
suspend
SoundBeep, 500, 500
return

;Icon switcher based on stage


	

;Mouse Middle Button Function






;=====================================================================================================================
; New Script 4 Keyboard Without Numpad
;=====================================================================================================================

;Icon switcher based on stage of fn keys
;Fn Script Play/Pause
F12::
fnstate:=!fnstate
SoundBeep, 900, 500
if (fnstate = 1)
	{
		Menu, Tray, Icon, fnenable.ico
	}
else if (fnstate = 0)
	{
		Menu, Tray, Icon, fndisable.ico
	}
return


#IF fnstate
;Key Combo, Reload, and Exit Script
F11::
If (KeyPressCount > 0)
	{
		KeyPressCount +=1
	}
else
	{
		KeyPressCount :=1
	}
Tooltip, % KeyPressCount
SetTimer, creKepresMoni, 450
return
creKepresMoni:
If (KeyPressCount = 1)
	{
		SplashTextOn,150,40,,Key Combo
		Sleep 400
		SplashTextOff
		^+!#Esc
	}
else if (KeyPressCount = 2)
	{
		SplashTextOn,150,40,,Reload Script
		Sleep 400
		SplashTextOff
		Reload
	}
else if (KeyPressCount = 3)
	{
		SplashTextOn,150,40,,Edit Script
		Sleep 400
		SplashTextOff
		Edit
	}
else if (KeyPressCount > 3)
	{
		SplashTextOn,150,40,,Exit Script
		Sleep 400
		SplashTextOff
		ExitApp
	}
KeyPressCount := 0
SetTimer, creKepresMoni, Off
Tooltip,
return

;Sharex Screenshot
F5::
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
		Tooltip, % KeyPressCount
	}

SetTimer, shrxykeresnit, 300
return
shrxykeresnit:
If (KeyPressCount = 1)
	{
		SendInput, ^{PrintScreen}
	}
else if (KeyPressCount > 1)
	{
		SendInput, ^+/
	}
KeyPressCount := 0
SetTimer, shrxykeresnit, Off
Tooltip,
return

;Paste
F6::^v

;Copy, Cut and Copy Link to Paragraph
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
		Tooltip, % KeyPressCount
	}
SetTimer, cpctseryerti, 550
return
cpctseryerti:
If (KeyPressCount = 1)
	{
		SendInput, ^c
		ToolTip, Copy
		Sleep 400
	}
else if (KeyPressCount = 2)
	{
		SendInput, ^x
		ToolTip, Cut
		Sleep 400
	}
else if (KeyPressCount > 2) ;copy link to paragraph part
	if winexist("ahk_exe ONENOTE.EXE")
		{
			WinActivate
			send {AppsKey}p
			ToolTip, Copy Link to Paragraph(OneNote)
			Sleep 400
		}	
KeyPressCount := 0
SetTimer, cpctseryerti, Off
Tooltip,
return

;Windows Clipboard and Display Settings
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
		Tooltip, % KeyPressCount
	}

SetTimer, dwsclplngs, 300
return
dwsclplngs:
If (KeyPressCount = 1)
	{
		SendInput, #v
		SplashTextOn,210,40,,Windows Clipboard
		Sleep 500
		SplashTextOff
	}
else if (KeyPressCount > 2)
	{
		SendInput, ^+d
		SplashTextOn,210,40,,Display Settings
		Sleep 600
		SplashTextOff
	}
KeyPressCount := 0
SetTimer, dwsclplngs, Off
Tooltip,
return

;Volume Down
F3::Volume_Down

;Backward by 5sec
F1::^+9

;Play/Pause
Escape::Media_Play_Pause

;Forward by 5sec
F2::^+0

;Volume up
F4::Volume_up

;Aimp Pause/Play
F9::
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
		Tooltip, % KeyPressCount
	}

SetTimer, amplaysuemntr, 300
return
amplaysuemntr:
If (KeyPressCount = 1)
	{
		SendInput, ^-
		ToolTip, Aimp Play/Pause
		Sleep 400
	}
else if (KeyPressCount = 2)
	{
		SendInput, ^!0
		ToolTip, Aimp Player
		Sleep 400
	}
else if (KeyPressCount > 2)
	{
		SendInput, ^!0
		ToolTip, Aimp Player
		Sleep 400
	}
KeyPressCount := 0
SetTimer, amplaysuemntr, Off
Tooltip,
return

;Special Functions Key
F10::
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
		Tooltip, % KeyPressCount
	}

SetTimer, spclonunfykm, 400
return
spclonunfykm:
If (KeyPressCount = 1)
	{
		SendInput, #{tab}
		SplashTextOn,210,40,,Recent Tasks On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 2)
	{
		SendInput, {f}
		SplashTextOn,210,40,,Full Screen Player On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 3)
	{
		SendInput, {F11}
		SplashTextOn,210,40,,Full Screen Mode On/Off
		Sleep 600
		SplashTextOff
	}
else if (KeyPressCount = 4)
	{
		SendInput, {Esc}
		SplashTextOn,150,40,,Escape
		Sleep 600
		SplashTextOff
	}
KeyPressCount := 0
SetTimer, spclonunfykm, Off
Tooltip,
return


#IF

;Mouse Middle Button Function

return




/*
#IfWinExist, ahk_class Shell_TrayWnd
{
#F18::Send, {Ctrl up}{LWin}
	return

l::
	
	if (WinActive(ahk_class IPTip_Main_Window)=0 OR tabtipDeactivate=true) {
		tabtipDeactivate:=false
		;show task bar (keyboard not shown if task bar is autohided)
		WinShow ahk_class Shell_TrayWnd
		WinActivate ahk_class Shell_TrayWnd	
		;show keyboard
		ToggleTouchKeyboard()
	} else {
	
	}
	return
	
#F20::
	clickState:=not clickState
	If (clickState) {
	Click, Down Right
	} else {
	Click, Up Right
	}
	return
}

ToggleTouchKeyboard()
{
  ; Translated to AHK from https://stackoverflow.com/a/39385492
  Shell_TrayWnd := FindWindowEx( 0, 0, "Shell_TrayWnd")
  TrayNotifyWnd := FindWindowEx( Shell_TrayWnd, 0, "TrayNotifyWnd")
  TIPBand := FindWindowEx( TrayNotifyWnd, 0, "TIPBand")
  if (!TIPBand or ErrorLevel)
  {
    MsgBox % "Could not get TIPBand. ErrorLevel: " ErrorLevel
  }
  else
  {	
		PostMessage, 0x201, 1, 65537, , ahk_id %TIPBand%
		PostMessage, 0x202, 1, 65537, , ahk_id %TIPBand%
  }
}

FindWindowEx( hwnd_parent, hwnd_child, str_class, p_title=0 )
{
  if ( p_title = 0 )
    type_title = UInt
  else
    type_title = Str
  return, DllCall( "FindWindowEx"
                   , UInt, hwnd_parent
                   , UInt, hwnd_child
                   , Str, str_class
                   , type_title, p_title )
}

*/

