;backward for MEmu
NumpadLeft::
Numpad4::
if winexist("ahk_exe HD-Player.exe") 
	{
	  WinActivate, BlueStacks App Player
		SendInput, a
	}
return	

;forward for MEmu
NumpadRight::
Numpad6::
if winexist("ahk_exe HD-Player.exe") 
	{
	  WinActivate, BlueStacks App Player
		SendInput, d
	}
return	

;MEmu media play pause
Numpad5::
NumpadClear::
if winexist("ahk_exe HD-Player.exe") 
	{
	  WinActivate, BlueStacks App Player
		SendInput, s
	}
return	