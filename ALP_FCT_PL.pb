Declare.l GetSongElapsedTime()
Declare LoadPlayList(name$)
Declare PlayMusic()
Declare StopMusic()


; Ajoute un morceau à la playList
Procedure AddToPlayList(file$)
  Protected ext$, find.w, *files.Vector
  
  If FileSize(file$) = -1
    ProcedureReturn #False
  EndIf
  
  If FileSize(file$) = -2
    NormalizeFolder(@file$)
    *files = Vector_ScanDir(file$, "*.*", #LC_SCANDIR_RECURSIVE)
    Vector_Reset(*files)
    While Vector_Next(*files)
      AddToPlayList(file$ + PeekS(*files\current\info))
    Wend
    ProcedureReturn #True
  EndIf
  
  ; Controle de l'extension
  find = #False
  ext$ = LCase(GetExtensionPart(file$))
  ForEach ALP_Format()
    If LCase(ALP_Format()\name) = ext$
      find = #True
      Break
    EndIf
  Next
  
  If find = #False
    ProcedureReturn
  EndIf

  ForEach playList()
    If playList()\nom = file$
      ProcedureReturn
    EndIf
  Next
  AddElement(playList())
    playList()\nom  = file$
    playList()\joue = 0
  
  ProcedureReturn #True

EndProcedure





;Renvoi la taille de la playList
Procedure GetNbTrackInPlayList()

  ProcedureReturn CountList(playList())

EndProcedure




; Renvoi le nombre de chansons déja jouées
Procedure GetPosOfPL()
  Protected num.l
  
  num = 0
  ForEach playList()
    If playList()\joue
      num + 1
    EndIf
  Next

  ProcedureReturn num

EndProcedure



Procedure ActualiseGadgetPL(gadget.l)

  ClearGadgetItemList(gadget)

  ForEach playList()
    AddGadgetItem(gadget, -1, GetFilePart(playList()\nom))
  Next
  
  SetGadgetState(gadget, Player\track)

EndProcedure






Procedure DeleteFromPL(pos)
  Protected nb.l, joue.l

  nb = CountList(PlayList())
  If pos<0 Or pos>= nb
    ProcedureReturn #False
  EndIf
  
  SelectElement(PlayList(), pos)
  joue = PlayList()\joue
  
  ; Si la chanson a déja été jouée
  ;Debug "PL joue : " + Str(joue)
  If joue
  
    ForEach PlayList()
      If PlayList()\joue > joue
        ;Debug "> Decal : " + Left(GetFilePart(PlayList()\nom), 5) + " : " + Str(PlayList()\joue)
        PlayList()\joue - 1
      EndIf
    Next
    
    SelectElement(PlayList(), pos)
  Else
    ; Rien à faire
  EndIf
  
  DeleteElement(PlayList())

EndProcedure







; Ajoute les paramètres à la PL ou charge l'ancienne
Procedure FromParamToPL()
  Protected Parametre$, FileName$, Extension$, FileType.l, FromParam.b

  Parametre$ = ProgramParameter()

  If Parametre$
    FromParam = #True
  EndIf

  While Parametre$
    
    If FileSize(Parametre$) = -2
      NormalizeFolder(@Parametre$)
      If ExamineDirectory(#PB_Any, Parametre$, "*.*")
        
        Repeat
          FileType = NextDirectory()
          If FileType = #DIR_IS_FILE
            FileName$ = DirectoryEntryName()
            Extension$ = UCase(GetExtensionPart(FileName$))
            ForEach ALP_Format()
              If UCase(ALP_Format()\name) = Extension$
                AddToPlayList(Parametre$ + FileName$)
              EndIf
            Next
          EndIf
        Until FileType = #DIR_EMPTY
        
      EndIf
    Else
      AddToPlayList(Parametre$)
    EndIf
    
    Parametre$ = ProgramParameter()
    
  Wend
  
  
  If FromParam
    PlayMusic()
  Else
    LoadPlayList(Player\namePL)
  EndIf
  
  
  DeleteFile(ALP_Dossier$(#FOLDER_PL) + #DEF_PL$)

EndProcedure





; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/





; Sauvegarde de la playList
Procedure SavePlayList(name$)
  Protected file.l

  If LCase(Right(name$,Len(#EXT_PL$))) <> #EXT_PL$
    name$ = name$ + #EXT_PL$
  EndIf

  DeleteFile(name$)
  DeleteFile(ALP_Dossier$(#FOLDER_PL) + #DEF_PL$)
  file = OpenFile(#PB_ANY, name$)
  If file
    ForEach PlayList()
      WriteStringN(PlayList()\nom)
    Next
    If Player\track >= 0
      WriteStringN("; "+#PL_TAG_TRACK$+"=" + Str(Player\track))
      WriteStringN("; "+#PL_TAG_TIME$ +"=" + Str(GetSongElapsedTime()))
    EndIf
    CloseFile(file)
    Player\namePL = name$
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf

EndProcedure



; Sauvegarde de la PL et création du Lien si nécessaire
Procedure SavePlayListBeforeEnding()
  Protected file.l

  If SavePlayList(Player\namePL)
    If Player\namePL <> ALP_Dossier$(#FOLDER_PL) + #DEF_PL$
      file = OpenFile(#PB_ANY, ALP_Dossier$(#FOLDER_PL) + #DEF_PL$)
      If file
        WriteStringN("; "+#PL_TAG_PL$+"=" +  Player\namePL)
        CloseFile(file)
      Else
        ProcedureReturn #False
      EndIf
    EndIf
  EndIf

EndProcedure


; Chargement d'une playList
Procedure.s LoadPlayListToLK(name$)
  Protected file.l, mp3$

  If FileSize(name$)>0
    file = OpenFile(#PB_ANY, name$)
    
    If file
      Player\track = -1
      Player\temps = 0
      
      While ~Eof(file)
        mp3$ = ReadString()
        If GetMid(@mp3$, 1) = ';'  ; Chanson courante ou Temps écoulé
          mp3$ = Trim(ReplaceString(mp3$,";",""))
          Select Trim(LCase(StringField(mp3$,1,"=")))
            Case #PL_TAG_TRACK$
              Player\track = Val(StringField(mp3$,2,"="))
            Case #PL_TAG_TIME$
              Player\temps = Val(StringField(mp3$,2,"="))
            Case #PL_TAG_PL$
              CloseFile(file)
              ProcedureReturn LoadPlayListToLK(StringField(mp3$,2,"="))
          EndSelect
        Else
          ; Ajout de la chanson(fichier) à la PL
          If GetPathPart(mp3$)
            AddToPlayList(mp3$)
          Else
            AddToPlayList(GetPathPart(name$)+mp3$)
          EndIf
        EndIf
        
      Wend
      
      CloseFile(file)
      
      ProcedureReturn name$
   
    Else
      Debug "Impossible d'ouvrir le fichier"  
    EndIf
  Else
    Debug "Fichier introuvable !"    
  EndIf
  
EndProcedure




Procedure Pl_Event_New(listView.l, track.l)
  If Player\namePL <> ALP_Dossier$(#FOLDER_PL) + #DEF_PL$
    SavePlayList(Player\namePL)
  EndIf
  StopMusic()
  Player\track = -1
  ClearList(PlayList())
  ClearGadgetItemList(listView)
  Player\namePL = ALP_Dossier$(#FOLDER_PL) + #DEF_PL$
  SetGadgetState(track, 0)
EndProcedure


Procedure Pl_Event_Open(listView.l)
  filtre$ = GetPrefString("OTHER", "FILE_PL")+"|*"+#EXT_PL$
  file$ = OpenFileRequester(GetPrefString("INFO_BULLE", "PL_OPEN"), ALP_Dossier$(#FOLDER_PL), filtre$, 0)
  If file$ And file$ <> Player\namePL
    ;SavePlayList(Player\namePL) ; On enregistre l'ancienne PL
    ;StopMusic()
    LoadPlayList(file$)
    ActualiseGadgetPL(listView)
  EndIf
EndProcedure


Procedure Pl_Event_Save()
  filtre$ = GetPrefString("OTHER", "FILE_PL")+"|*"+#EXT_PL$
  file$ = SaveFileRequester(GetPrefString("INFO_BULLE", "PL_SAVE"), ALP_Dossier$(#FOLDER_PL), filtre$, 0)
  If file$
    SavePlayList(file$)
  EndIf
EndProcedure


; ExecutableFormat=Windows
; EOF
