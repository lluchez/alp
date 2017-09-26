
Enumeration 0
  #SRC_STOP
  #SRC_RUN
EndEnumeration




;- Extensions

Procedure LoadExtensionSupported()
  Protected head$, msg$

  If DatabaseQuery("SELECT * FROM extension ORDER BY nomExtension")

    ClearList(ALP_Format())
    While NextDatabaseRow()
      AddElement(ALP_Format())
        ALP_Format()\name     = UCase(GetStrField("nomExtension"))
        ALP_Format()\descrip  = GetStrField("descriptionExt")
    Wend

  Else
    head$ = GetPrefString("TITLE", "ERR_MSG")
    msg$ = GetPrefString("ERROR", "ERR_LOAD_EXT")
    Alert(head$, msg$, #True) 
  EndIf

EndProcedure







; Analyse et BD


Procedure RemoveDeletedFiles()
  Protected file$, array.ExplodedFile

  NewList Del.s()
  If DatabaseQuery("SELECT nomChanson, cheminChanson, cheminChanson2 FROM chanson")
  
    While NextDatabaseRow()
      file$ = GetStrField("cheminChanson") + GetStrField("cheminChanson2") + GetStrField("nomChanson")
      
      If FileSize(file$) = -1
        ;alert("", file$,0)
        AddElement(Del()): Del() = file$
      EndIf
    Wend
    
    ForEach Del()
      ExplodeFile(Del(), array)
      If DatabaseQuery("DELETE FROM chanson WHERE cheminChanson = " + ForUpdate(array\chemin1) + " cheminChanson2 = " + ForUpdate(array\chemin1) + " AND nomChanson = " + ForUpdate(array\fichier))
        Debug "Suppr : " + Del()
      Else
        Debug "Impossible de supprimer : " + Del()
      EndIf
    Next

  Else
    Debug "Impossible d'effectuer la requete."
  EndIf

EndProcedure






Procedure LoadLibraryFolder()
  Protected folder.s, find.b
  NewList toDel.s()

  If DatabaseQuery("SELECT * FROM repertoire ORDER BY nomRepertoire")

    ClearList(ALP_LibFolder())
    While NextDatabaseRow()
      folder = GetStrField("nomRepertoire")
      If FileSize(folder) = -2
        find = #False
        ForEach ALP_LibFolder()
          If ALP_LibFolder() = Left(folder, Len(ALP_LibFolder()))
            find = #True
          EndIf
        Next
        If find = #False
          AddElement(ALP_LibFolder()): ALP_LibFolder() = folder
        Else
          AddElement(toDel()): toDel() = folder
        EndIf
      Else
        AddElement(toDel()): toDel() = folder
      EndIf
    Wend
    
    ForEach toDel()
      If isDebug
        Debug "To del : " + toDel()
      EndIf
      DatabaseUpdate("DELETE FROM repertoire WHERE nomRepertoire = " + ForUpdate(toDel()) )
    Next

  Else
    head$ = GetPrefString("TITLE", "ERR_MSG")
    msg$ = GetPrefString("ERROR", "#ERR_LOAD_FOLD_LIB")
    Alert(head$, msg$, #True) 
  EndIf

EndProcedure




Procedure.l ListFileFromDir(folder$)
  Protected numRep.l, nbFile.l, find.b, FileType.l, FileName$
  
  nbFile = 0
  NormalizeFolder(@folder$)

  numRep = ExamineDirectory(#PB_Any, folder$, "*.*")
  If numRep
  
    Repeat
      FileType = NextDirectory()
      If FileType
        FileName$ = DirectoryEntryName()
        
        Select FileType
          Case #DIR_IS_FILE
            ext$ =  UCase(GetExtensionPart(FileName$))
            ForEach ALP_Format()
              If ext$ = ALP_Format()\name
                AddElement(ALP_MusicFile()) : ALP_MusicFile() = folder$ + FileName$
                nbFile + 1
                Break
              EndIf
            Next
        
          Case #DIR_IS_DIR
            nbFile + ListFileFromDir(folder$ + FileName$ + "\")
            UseDirectory(numRep)
        
        EndSelect

      EndIf
    Until FileType = 0  

    ProcedureReturn nbFile
  Else
    Debug "Répertoire non trouvé : " + folder$
  EndIf
EndProcedure




Procedure.l CountAndListMusicFile()
  Protected nFile.l

  ClearList(ALP_MusicFile())
  ForEach ALP_LibFolder()
    nFile = ListFileFromDir(ALP_LibFolder())
    *allInfoALP\majBD\total + nFile
  Next
  
  ForEach ALP_MusicFile()
    If FileSize(ALP_MusicFile()) = -1
      Debug "Pb : " + ALP_MusicFile()
      DeleteElement(ALP_MusicFile())
    EndIf
  Next
  
EndProcedure




Procedure AddAllSongToBD(all.b, nFont.l)
  Protected tag.ID3TagV2Tag, progressTmp$

  ForEach ALP_MusicFile()
    ClearTagV2Data(@tag)
    
    If (UCase(GetExtensionPart(ALP_MusicFile())) = "MP3")
      If FileSize(ALP_MusicFile()) = -1
        Debug ">>> Erreur fichier : " + ALP_MusicFile()
      EndIf
      ;GetMp3Infos(ALP_MusicFile())
      ReadTagV1(ALP_MusicFile())
      ReadTagV2(ALP_MusicFile())
      MixTheTags(m_tagV1Info, m_tagV2Info, tag)
    EndIf
    
    If TagIsEmpty(@tag) = #False Or all = #True
      CompleteTagWithFileName(@tag, GetFilePart(ALP_MusicFile()))
      AddSongToBD(ALP_MusicFile(), @tag)
      DeleteElement(ALP_MusicFile())
      *allInfoALP\majBD\current + 1
      ;progressTmp$ = ALP_ProcessBeginStr$ + " : " + Str(*allInfoALP\majBD\current) + "/" + Str(*allInfoALP\majBD\total)
      progressTmp$ = Str(*allInfoALP\majBD\current) + "/" + Str(*allInfoALP\majBD\total)
      ; Erreur, la suite ne marche pas .... !!!!!!
      ;If StartDrawing(WindowOutput())
      ;  DrawingFont(UseFont(nFont))
      ;  If TextLength(progressTmp$) > GadgetWidth(NumProgressText)
      ;    progressTmp$ = Str(*allInfoALP\majBD\current) + "/" + Str(*allInfoALP\majBD\total)
      ;    StopDrawing()
      ;  EndIf
      ;EndIf
      SetGadgetText(NumProgressText, progressTmp$)
    EndIf
  
  Next
  If all = #False
    AddAllSongToBD(#True, nFont)
  EndIf

EndProcedure





Procedure LoadMusicToLib(auto.l)

  *allInfoALP\majBD\threadStatut = #SRC_RUN
  *allInfoALP\majBD\total = 0
  *allInfoALP\majBD\current = 0
  *allInfoALP\majBD\lastScan = Date()
  ;*allInfoALP\majBD\font = #FONT_LIST

 ;On supprime les chansons qui ont bougées
  RemoveDeletedFiles()

 ;Liste les fichiers audio
  CountAndListMusicFile()
  
 ;Ajout des fichiers à la BD
  AddAllSongToBD(#False, *allInfoALP\majBD\font)
  
  *allInfoALP\majBD\threadID = #False
  *allInfoALP\majBD\threadStatut = #SRC_STOP

EndProcedure

; ExecutableFormat=
; EOF
