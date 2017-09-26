


; -------------------------------------------------------
;-                          Window
; -------------------------------------------------------

; Les LinkedList
  NewList playList.PlayL()
  NewList mesImg.s()
  NewList mesBt.ALP_Bouton()
  NewList tempList.l()

  Global Player.Lecteur

  Global *allInfoALP.ALP_ALL

  Global ALP_Langue$    ; Nom de la langue
    Global ALP_ProcessBeginStr$   ; "Fichiers : n/m"
    Global ALP_Volume$, ALP_balance$, ALP_PosSong$

  Global hBrush.l, sBrush.l

; -------------------------------------------------------
;-                      Base de Donnees
; -------------------------------------------------------


  Global hasBD.b


; Les dossiers

Dim ALP_Dossier$(#FOLDER_END)
  ALP_Dossier$(#FOLDER_LANG)  = "LANG\"
  ALP_Dossier$(#FOLDER_LIB)   = ""
  ALP_Dossier$(#FOLDER_SKIN)  = "SKIN\"
  ALP_Dossier$(#FOLDER_PL)    = "PL\"
  
  ; Création des dossiers si nécessaire
  For i = #FOLDER_LANG To #FOLDER_END - 1
    If ALP_Dossier$(i) <> ""
      If FileSize(ALP_Dossier$(i)) <> -2
        CreateDirectory(ALP_Dossier$(i))
      EndIf
    EndIf
  Next i


; Les formats d'images (pour els skins)

NewList ALP_ImgFormat.s()
  AddElement(ALP_ImgFormat()): ALP_ImgFormat() = "bmp"
  If ALP_addDecoder
    AddElement(ALP_ImgFormat()): ALP_ImgFormat() = "jpeg"
    AddElement(ALP_ImgFormat()): ALP_ImgFormat() = "jpg"
    AddElement(ALP_ImgFormat()): ALP_ImgFormat() = "png"
  EndIf


; Les LinkedList
  NewList ALP_LibFolder.s()
  NewList ALP_Format.Extension()
  NewList ALP_LangFile.s()
  NewList ALP_FoundBySearch.s()
  NewList ALP_MusicFile.s()
  


; Les tags
  ;Global newTagV2Info.ID3TagV2Tag, newTagV1Info.ID3TagV1Tag
  ;Global m_inputFilename.s
  Global NumProgressText.l



; Champ principal de certaines tables
;  (pour completer les TAGS avec le nom du fichier)

  Global ALP_NumField.b
    ALP_NumField = 3
  Dim ALP_Field.MainField(ALP_NumField)

; ExecutableFormat=
; EOF
