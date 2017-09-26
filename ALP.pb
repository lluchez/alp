;    __      __      ___    ______     _____    __
;   /\ \    /\_\    /__ \  /\  __ \   /\  __\  /\ \
;   \ \ \   \/_/_  /\\/\ \ \ \ \/\ \  \ \  _\  \ \ \
;    \ \ \___ /\ \ \ \\_\ \ \ \ \ \ \  \ \ \___ \ \ \___
;     \ \____\\ \_\ \ \___/  \ \_\ \_\  \ \____\ \ \____\
;      \/____/ \/_/  \/__/    \/_/\/_/   \/____/  \/____/
;
; Author : b!g b@$s
; Name : AudioLibPlayer
; Version : 0.9
; Software : PureBasic v3.93
; Begin date : 29 May 2005



;Procedure RunOnlyOneInstance()
;  *a = CreateSemaphore_(null,0,1,GetProgramName())
;  If *a <> 0 And GetLastError_()=#ERROR_ALREADY_EXISTS
;    CloseHandle_(*a)
;    End
;  EndIf
;EndProcedure

RunOnlyOneInstance()
SetCurrentDirectory(GetProgramPath())


RandomSeed(ElapsedMilliseconds())
UseJPEGImageDecoder(): UsePNGImageDecoder(): ALP_addDecoder = #True


Global isDebug.b
  isDebug = 0


;- 1 Fichiers generaux

XIncludeFile "ALP_CST.pb"
XIncludeFile "ALP_FCT.pb"
XIncludeFile "ALP_TAGS.pb"
;XIncludeFile "IDTags.pb"
XIncludeFile "ALP_TrackBar.pb"
XIncludeFile "E:\PureBasic\Projets\From the Net\Registre\Registre.pb"


;- 2 Les structures

XIncludeFile "ALP_STR_WIN.pb"
XIncludeFile "ALP_STR_BD.pb"


;- 3 Les variables

XIncludeFile "ALP_VAR.pb"


;- 4 Les autres fcts

XIncludeFile "ALP_FCT_PREFS.pb"
XIncludeFile "ALP_FCT_BD1.pb"
XIncludeFile "ALP_FCT_BD2.pb"
XIncludeFile "ALP_FCT_BD3.pb"
XIncludeFile "ALP_FCT_PL.pb"
XIncludeFile "ALP_FCT_MP3.pb"
XIncludeFile "ALP_FCT_LANG.pb"
XIncludeFile "ALP_FCT_WIN.pb"
XIncludeFile "ALP_FCT_SKIN.pb"
XIncludeFile "ALP_FCT_GRAP.pb"


;- 5 Les Datas

XIncludeFile "ALP_DATA.pb"


;- 6 Initialisation

XIncludeFile "ALP_INI_WIN.pb"
XIncludeFile "ALP_INI_BD.pb"

;DatabaseUpdate("delete * from chanson")
;DatabaseUpdate("delete * from artiste")
;DatabaseUpdate("delete * from album")
;End


;- 7 Lancement
XIncludeFile "ALP_MAIN.pb"

End





; ExecutableFormat=
; EnableAsm
; EnableXP
; UseIcon=E:\PureBasic\Projets\ALP\ALP.ico
; Executable=E:\PureBasic\Projets\ALP\ALP.exe
; EOF
