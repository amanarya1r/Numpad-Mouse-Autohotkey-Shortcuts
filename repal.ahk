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
if (KeyPressCount <3)
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
if (KeyPressCount <3)
	{
		Tooltip, % KeyPressCount
	}
SetTimer, vKeyPressMonitor, 300
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
else if (KeyPressCount > 2)
	{

	}
KeyPressCount := 0
SetTimer, vKeyPressMonitor, Off
Tooltip,
return

;Windows Clipboard and Display Settings
NumpadAdd::
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

SetTimer, xKeyPressMonitor, 300
return
xKeyPressMonitor:
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

;Windows Display Settings
Numpad1::^+d
NumpadEnd::^+d

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

SetTimer, fKeyPressMonitor, 400
return
fKeyPressMonitor:
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
SetTimer, fKeyPressMonitor, Off
Tooltip,
return

;Scrip Play/Pause
NumpadDot::Suspend
NumpadDel::Suspend

;Mouse Middle Button Function
aman the boss 


return



