




; Identifiants BD

  ALP_user$ = ""
  ALP_pass$ = ""



; Chargement des structure de tables

  Restore TableAndField
    For i = 0 To ALP_NumField-1
      Read ALP_Field(i)\table
      Read ALP_Field(i)\champ
      Read ALP_Field(i)\value
    Next i



  hasBD = #True
  ALP_BD_Ini(#True)
  If hasBD
    ALP_BD_Connect(#True, ALP_user$, ALP_pass$)
  EndIf


;- Chargement des extensions

LoadExtensionSupported()
LoadLibraryFolder()



;ALP_BD_Close()
;UnIniConnection() ; Pas obligatoire, mais bon...


  
  
; ExecutableFormat=Windows
; EOF
