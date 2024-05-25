/*--------------------------------------------------------------------------------------------------------------------
[Plugin] GK_OCR (Win 10+) (by Gorgrak/Speedmaster)
File Name : GK_OCR.ahk
version: 1.1  2023 04 23
usage: select a clip text and press " Y " to use built-in OCR in Windows 10 to copy text to the clipboard.
topic: https://www.autohotkey.com/boards/viewtopic.php?p=506077#p506077
credits: Plugin: Gorgrak, Speedmaster  OCR: malcev, teadrinker, joe glines, Jackie 

Help:
how to install this plugin ?
1° download FG ScreenClipper at https://www.autohotkey.com/boards/viewtopic.php?p=506077#p506077
2° put this script plugin GK_OCR.ahk in the Lib folder of the main RUN script
3° insert "#Include GK_OCR.ahk" in the INCLUDE SECTION of the main RUN script 

Note this plugin has internal default shortcuts (see below) that you can change 
or migrate in the #ifwinactive section of the main run script
*/---------------------------------------------------------------------------------------------------------------------


; DEFAULT SHORTCUTS ---------------------------------------------------
#IfWinActive, ScreenClipperWindow ahk_class AutoHotkeyGUI
y::GK_Win2OCR()          ; Press Y to use built-in Win10+ OCR
#IfWinActive


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
