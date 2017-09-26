
Global TimerState.b, StepTimer.l
Enumeration
  #TIMER_NULL
  #TIMER_BT1_DOWN
  #TIMER_BT1_UP
  #TIMER_BT2_DOWN
  #TIMER_BT2_UP
EndEnumeration
StepTimer = 30 ; tps en ms


CompleteConfWin()

ImageMAJ(WindowFromPoint_(DesktopMouseX(), DesktopMouseY()))

SetWindowCallback(@WindowCallback())

FromParamToPL()

SetSkinPreview(GetGadgetItemText(#BUTTON_SK_LISTE, SearchSkin(myALP\Skin\name), 0))


curSong = Player\track
plSize = CountList(PlayList())
lastSongScan = ElapsedMilliseconds()
NumProgressText = #BUTTON_SRC_PROGRESS ;Var globale




If Player\track > -1
  SetMaxTB(#BUTTON_TRACK_POS, Player\temps)
EndIf
SetGadgetState(#BUTTON_TRACK_VOL, Player\volume)
;SetGadgetState(#BUTTON_TRACK_BAL, -1000)
SetGadgetState(#BUTTON_TRACK_BAL, (Player\balance)/2+500)


RegisterHotKey_(WindowID(#Win_Main), #PB_Shortcut_Mci_Next, 0, #PB_Shortcut_Mci_Next)
RegisterHotKey_(WindowID(#Win_Main), #PB_Shortcut_Mci_Prev, 0, #PB_Shortcut_Mci_Prev)
RegisterHotKey_(WindowID(#Win_Main), #PB_Shortcut_Mci_Stop, 0, #PB_Shortcut_Mci_Stop)
RegisterHotKey_(WindowID(#Win_Main), #PB_Shortcut_Mci_Play, 0, #PB_Shortcut_Mci_Play)








;{ _ _ _ _ _    MAJ ProgressBar while Thread      _ _ _ _ _ _ }


wait_while_process:

  While myALP\majBD\threadStatut = #SRC_RUN

    EventID.l = WindowEvent()

    Select EventID 


  ; -----------------------
  ;      Bouton droit
  ; -----------------------

      Case #WM_LBUTTONDOWN ;   Déplacement de la fenêtre
        Select WindowFromPoint_(DesktopMouseX(), DesktopMouseY())
          Case WindowID(#Win_Main)
            SendMessage_(WindowID(#Win_Main)  , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
          Case WindowID(#Win_Pl)
            SendMessage_(WindowID(#Win_Pl)    , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
          Case WindowID(#Win_Skin)
            SendMessage_(WindowID(#Win_Skin)  , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
          Case WindowID(#Win_Conf)
            SendMessage_(WindowID(#Win_Conf)  , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
          Case WindowID(#Win_Search)
            SendMessage_(WindowID(#Win_Search), #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
        EndSelect
      ;EndCase


  ; -----------------------
  ;      EventGadget
  ; -----------------------

      Case #PB_Event_Gadget
        If EventGadgetID() = #BUTTON_SRC_BT_SRC
          PauseThread(myALP\majBD\threadID)
          If MessageRequester(GetPrefString("TITLE", "CONFIRM"), GetPrefString("LABEL", "STOP_SCAN"), #MB_OKCANCEL | #MB_ICONINFORMATION) = #True
            KillThread(myALP\majBD\threadID)
            myALP\majBD\threadStatut = #SRC_STOP
            myALP\majBD\total = 0
          Else
            ResumeThread(myALP\majBD\threadID)
          EndIf
        EndIf
      ;EndCase
      
    EndSelect

    If *allInfoALP\majBD\total
      SetGadgetState(#BUTTON_SRC_BAR,(myALP\majBD\current*100)/myALP\majBD\total)
    Else
      SetGadgetState(#BUTTON_SRC_BAR, 0)
    EndIf
    Sleep_(20)

  Wend ;{ Fin du Thread }
  ActivateGadget(#BUTTON_SRC_NOM_TEXT)



;On remet le bouton "Launch MAJ" avec cette valeur
  SetGadgetText(#BUTTON_SRC_BT_SRC, GetPrefString("BOUTON", "MAJ"))


;MAJ auto nécessaire ???
  If myALP\majBD\nDays>0 And CountList(ALP_LibFolder())>0
    If Date() - myALP\majBD\lastScan >= (3600 * 24 * myALP\majBD\nDays)
      TimerState = #TIMER_BT1_DOWN
      TimerGadgetId = GadgetID(#BUTTON_SEARCH)
      SetTimer_(WindowID(#Win_Main),1,StepTimer,0)
    EndIf
  EndIf





;  <><><><><><><><><><><><><><><><><><><><><><>
;  |                                          |\
;  |           DEBUT DU PROGRAMME             | |
;  |                                          | |
;  <><><><><><><><><><><><><><><><><><><><><><> |
;   \__________________________________________\|

;- Debut

Repeat
  EventID.l = WindowEvent()

  onTrackBar = #False
  Current = GetSongElapsedTime()
  
  If Current = Player\temps
    If Player\track >= 0 And Current>0
      If LaunchMusic(ALP_Choice(#ALP_NEXT_AUTO)) = #False
        StopMusic()
        Player\track = -1
      EndIf
    EndIf
  EndIf

  If EventID = 0  ; We wait only when nothing is being done
    Sleep_(20)
  EndIf
  
  ;{--  
  Select EventID
  

; -----------------------
;      Event Close
; -----------------------

    ;{--
    Case #PB_Event_CloseWindow
      QuitALP()
    ; --}
  


; -----------------------
;      Event Gadget
; -----------------------

    ;{-- EVENT GADGET
    Case #PB_Event_Gadget
    
      If EventType() = #PB_EventType_LeftDoubleClick
      
        ;{--
        Select EventGadgetID()
        
          ; Lancement d'un morceau depuis la PL
          Case #BUTTON_PL_LISTE
            If GetGadgetState(#BUTTON_PL_LISTE)>=0
              SelectElement(playList(), GetGadgetState(#BUTTON_PL_LISTE))
              SelectMusicByPL( GetGadgetState(#BUTTON_PL_LISTE) )
            EndIf
        
          ; Changement de skin par double-clic
          Case #BUTTON_SK_LISTE
            If GetGadgetState(#BUTTON_SK_LISTE)>=0
              HideWindow(#Win_Skin, #True)
              If myALP\Skin\name <> GetGadgetText(#BUTTON_SK_LISTE)
                myALP\Skin\name = GetGadgetText(#BUTTON_SK_LISTE)
                ChoiceSkin(myALP)
              EndIf
            EndIf
          
          ; Changement de la langue
          Case #BUTTON_CF_LNG_LIST
            If GetGadgetState(#BUTTON_CF_LNG_LIST) >= 0
              SelectElement(ALP_LangFile(),GetGadgetState(#BUTTON_CF_LNG_LIST))
              ChangeLang(ALP_LangFile())
            EndIf
        
        EndSelect
        ; --}
        
      ElseIf EventType() = #PB_EventType_LeftClick Or EventType() = -1
        
        
        ;{--
        Select EventGadgetID()
        
          ; Preview d'un skin
          Case #BUTTON_SK_LISTE
            If GetGadgetState(#BUTTON_SK_LISTE)>=0
              SetSkinPreview(GetGadgetText(#BUTTON_SK_LISTE))
            EndIf
          
          ; Changement de skin
          Case #BUTTON_SK_OK
            If GetGadgetState(#BUTTON_SK_LISTE)>=0
              HideWindow(#Win_Skin, #True)
              If myALP\Skin\name <> GetGadgetText(#BUTTON_SK_LISTE)
                myALP\Skin\name = GetGadgetText(#BUTTON_SK_LISTE)
                ChoiceSkin(myALP)
                HideWindow(#WIN_MAIN, #False)
              EndIf
            EndIf
          
          
          Case #BUTTON_SYSTRAY
            ALP_ToSystray()
          
          
          ; ------------------------------
          ;         Les TrackBar
          ; ------------------------------
          
          Case #BUTTON_TRACK_POS
            onTrackBar = #True
            ReplaceTrackBarCursor(#BUTTON_TRACK_POS, #Win_Main)
            SetMusicPosition(GetGadgetState(#BUTTON_TRACK_POS))
          
          Case #BUTTON_TRACK_VOL
            ReplaceTrackBarCursor(#BUTTON_TRACK_VOL, #Win_Main)
            Player\volume = GetGadgetState(#BUTTON_TRACK_VOL)
            GadgetToolTip(#BUTTON_TRACK_VOL, ALP_Volume$ + Str(Player\volume / 10))
            AjusteVolume()
          
          Case #BUTTON_TRACK_BAL
            ReplaceTrackBarCursor(#BUTTON_TRACK_BAL, #Win_Main)
            Player\balance = 2*(GetGadgetState(#BUTTON_TRACK_BAL)-500)
            GadgetToolTip(#BUTTON_TRACK_BAL, ALP_Balance$ + Str(Player\balance / 10))
            AjusteVolume()
          
          
          ; ------------------------------
          ;   Affiche/Masque les fenêtre
          ; ------------------------------
          
          Case #BUTTON_SKIN
            SetSkinPreview(myALP\Skin\name)
            HideWindow(#WIN_SKIN, IsWindowVisible_(WindowID(#WIN_SKIN)))
          
          Case #BUTTON_SK_EXIT
            HideWindow(#WIN_SKIN, #True)
          
          
          Case #BUTTON_PL
            ActualiseGadgetPL(#BUTTON_PL_LISTE)
            HideWindow(#WIN_PL, IsWindowVisible_(WindowID(#WIN_PL)))
          
          Case #BUTTON_PL_EXIT
            HideWindow(#WIN_PL, #True)
          
          
          Case #BUTTON_CONF
            SetGadgetText(#BUTTON_CF_SRC_TEXT, Str(myALP\majBD\nDays))
            HideWindow(#WIN_CONF, IsWindowVisible_(WindowID(#WIN_CONF)))
          
          Case #BUTTON_CF_EXIT
            HideWindow(#WIN_CONF, #True)
            myALP\majBD\nDays = Val(GetGadgetText(#BUTTON_CF_SRC_TEXT))
            If myALP\majBD\nDays < 0
              myALP\majBD\nDays = 0
            EndIf
          
          
          Case #BUTTON_SEARCH
            HideWindow(#WIN_SEARCH, IsWindowVisible_(WindowID(#WIN_SEARCH)))
            If IsWindowVisible_(WindowID(#WIN_SEARCH))
              ActivateGadget(#BUTTON_SRC_NOM_TEXT)
            EndIf
          
          Case #BUTTON_SRC_EXIT
            HideWindow(#WIN_SEARCH, #True)
          
          
          ; -------------------------
          ;     CONFIGURATION
          ; -------------------------
        
          ; Ajout d'un dossier
          Case #BUTTON_CF_FLD_NEW
            folder$ = PathRequester(GetPrefString("WINDOW", "MSG_FOLDER"), "")
            If folder$
              NormalizeFolder(@folder$)
              find.b = #False
              ForEach ALP_LibFolder()
                If ALP_LibFolder() = Left(folder$, Len(ALP_LibFolder()))
                  find = #True
                EndIf
              Next
              If find = #False
                DatabaseQuery("INSERT INTO repertoire VALUES(" + ForUpdate(folder$) + ")")
                ReloadListDirALP()
              EndIf
            EndIf
          
          
          ; Supprime un dossier
          Case #BUTTON_CF_FLD_DEL
            DeleteOneFolder()
          
          ; Ajout d'une extension
          Case #BUTTON_CF_EXT_NEW
            ext$ = CorrectMajExt(InputRequester(GetPrefString("TITLE", "ADD_EXT"), GetPrefString("LABEL", "ADD_EXT1"), ""))
            If ext$
              If Left(ext$,1) = "."
                ext$ = Right(ext$, Len(ext$)-1)
              EndIf
              find = #False
              ForEach ALP_Format()
                If ALP_Format()\name = ext$
                  find = #True
                EndIf
              Next
              If find = #False
                pt$ = GetRegKeyStrValue("HKEY_CLASSES_ROOT\."+LCase(ext$)+"\", "")
                If pt$
                  pt$ = GetRegKeyStrValue("HKEY_CLASSES_ROOT\"+pt$+"\", "")
                EndIf
                descrp$ = Trim(InputRequester(GetPrefString("TITLE", "ADD_EXT"), GetPrefString("LABEL", "ADD_EXT2"), pt$))
                If descrp$ = ""
                  descrp$ = pt$
                EndIf
                DatabaseQuery("INSERT INTO extension VALUES(" + ForUpdate(ext$) + ", " + ForUpdate(descrp$)+")")
                ReloadListExtensionALP()
              EndIf
            EndIf
          
          ; Supprime une extension
          Case #BUTTON_CF_EXT_DEL
            DeleteOneExtension()
          
          
          ; -------------------------
          ;      RECHERCHE BD
          ; -------------------------
          
          Case #BUTTON_SRC_NOM_BT
            SearchMusicFromLib()
          
          Case #BUTTON_SRC_ADD_PL
            ForEach ALP_FoundBySearch()
              If GetGadgetItemState(#BUTTON_SRC_LIST, ListIndex(ALP_FoundBySearch()))
                AddToPlayList(ALP_FoundBySearch())
              EndIf
            Next
          
          Case #BUTTON_SRC_ADD_ALL
            ForEach ALP_FoundBySearch()
              AddToPlayList(ALP_FoundBySearch())
            Next
          
          Case #BUTTON_SRC_BT_SRC
            If myALP\majBD\threadStatut = #SRC_STOP
              If CountList(ALP_LibFolder())
                ThreadID.l = CreateThread(@LoadMusicToLib(), 0)
                If ThreadID
                  myALP\majBD\threadID = ThreadID
                  myALP\majBD\font = #FONT_LIST
                  myALP\majBD\threadStatut = #SRC_RUN
                  SetGadgetText(#BUTTON_SRC_BT_SRC, GetPrefString("BOUTON", "STOP_MAJ"))
                  Goto wait_while_process
                Else
                  ;Erreur de création du Thread
                  Alert(GetPrefString("TITLE", "ERR_MSG"), GetPrefString("ERROR", "ERR_SEARCH_THREAD"), #False)
                EndIf
              ElseIf myALP\majBD\nDays And Date() - myALP\majBD\lastScan < (3600 * 24 * myALP\majBD\nDays)
                ;pas de dossiers
                Alert(GetPrefString("TITLE", "ERR_MSG"), GetPrefString("ERROR", "ERR_NO_FOLDER"), #False)
              EndIf
            EndIf
          
        EndSelect
        ; --}
          
    EndIf



; -----------------------
;      Bouton gauche
; -----------------------

    ; Clic Droit
    Case #WM_RButtonDown
      If WindowFromPoint_(DesktopMouseX(), DesktopMouseY()) = WindowID(#WIN_MAIN)
        ShowPopUpMenu()
      EndIf
    


; -----------------------
;      Drag And Drop
; -----------------------

    ;{ Darg And Drop
    Case #WM_DROPFILES
      dropped.l = EventwParam()
      num.l = DragQueryFile_(dropped, -1, "", 0)
      For i = 0 To num - 1
        size.l = DragQueryFile_(dropped, i, 0, 0)
        filename.s = Space(size)
        DragQueryFile_(dropped, i, filename, size + 1)
        AddToPlayList(filename)
      Next
      DragFinish_(dropped)
      
      If plSize <> CountList(PlayList())
        If Player\track = -1 And Player\autoLaunch = #True
          PlayMusic()
        EndIf
      EndIf
    ;}
    
    


; -----------------------
;      Event Menu
; -----------------------

    ;{ Choix d'un menu
    Case #PB_Event_Menu
    
      Select EventMenuID()
      
        ;{-- Lecture NORMALE
        Case #POP_LECT_NORM
          SetLectureRndToNormal()
          Player\lecture = #LECT_NORMAL
        ; --}
        
        Case #POP_LECT_RAND
          Player\lecture = #LECT_RANDOM
        
        Case #POP_RPT_NONE
          Player\boucle = #REPEAT_NONE
        
        Case #POP_RPT_TRK
          Player\boucle = #REPEAT_TRACK
        
        Case #POP_RPT_ALL
          Player\boucle = #REPEAT_ALL
        
        Case #POP_AUTO_NO
          Player\autoLaunch = #False
        
        Case #POP_AUTO_YES
          Player\autoLaunch = #True
      
        ;{-- Suppr d'une chanson de la PL
        Case #MENU_SUPPR_PL
          ClearList(tempList())
          cur.l = -1

          ForEach PlayList()
            index = ListIndex(PlayList())
            If GetGadgetItemState(#BUTTON_PL_LISTE, index)
              If index = Player\track
                cur = index - CountList(tempList())
              Else
                ResetList(tempList())
                AddElement(tempList()) : tempList() = index
              EndIf
            EndIf
          Next
              
          
          ForEach tempList()
            DeleteFromPL(tempList())
            If Player\track > -1 And tempList() < Player\track
              Player\track - 1
            EndIf
          Next
          
          If cur > -1 And cur = Player\track
            etat = Player\etat
            SelectElement(PlayList(), cur)
            Joue = PlayList()\joue
            
            Player\track = -1
            ForEach PlayList()
              If PlayList()\joue = joue - 1
                Player\track = ListIndex(PlayList())
                If Player\track > cur
                  Player\track - 1
                EndIf
                Break
              EndIf
            Next
            DeleteFromPL(cur)
            StopMusic()
            If etat = #MP3_ETAT_PLAY
              StopMusic()
              LaunchMusic(ALP_Choice(#ALP_NEXT))
            Else
              ChangeMusic(ALP_Choice(#ALP_NEXT))
            EndIf
          EndIf
        ; --}
        
        
        Case #POP_RESTORE
          RestaureALP()
        
        Case #POP_SYSTRAY
          ALP_ToSystray()
        
        Case #POP_MINIMIZE
          ShowWindow_(WindowID(#Win_Main), #SW_MINIMIZE)
        
        
        Case #MENU_SUPPR_CONF
          Select GetFocus_()
            Case GadgetID(#BUTTON_CF_FLD_LIST)
              DeleteOneFolder()
            Case GadgetID(#BUTTON_CF_EXT_LIST)
              DeleteOneExtension()
          EndSelect
        
        Case #MENU_SRC_BD
          If GetFocus_() = GadgetID(#BUTTON_SRC_NOM_TEXT)
            SearchMusicFromLib()
          EndIf
        
        
        Case #POP_VOL_LESS
          Player\volume - #POP_STEP_VOL 
          If Player\volume < 0
            Player\volume = 0
          EndIf
          UpdateVolTrackBar()
          
        
        Case #POP_VOL_MORE
          Player\volume + #POP_STEP_VOL 
          If Player\volume > 1000
            Player\volume = 1000
          EndIf
          UpdateVolTrackBar()
        
        Case #POP_VOL_MUTE
          Player\muet = Not(Player\muet)
          AjusteVolume()
        
        
        
        Case #POP_BAL_LESS
          Player\balance - #POP_STEP_BAL
          If Player\balance < -1000
            Player\balance = 1000
          EndIf
          UpdateBalTrackBar()
          
        
        Case #POP_BAL_MORE
          Player\balance + #POP_STEP_BAL
          If Player\balance > 1000
            Player\balance = 1000
          EndIf
          UpdateBalTrackBar()
        
        Case #POP_BAL_MIL
          Player\balance = 0
          UpdateBalTrackBar()
        
        Case #POP_QUIT
          QuitALP()
          
         
        Case #Menu_Ctrl_N
          HideWindow(#Win_PL, #False)
          Pl_Event_New(#BUTTON_PL_LISTE, #BUTTON_TRACK_POS)
        
        Case #Menu_Ctrl_O
          HideWindow(#Win_PL, #False)
          Pl_Event_Open(#BUTTON_PL_LISTE)
        
        Case #Menu_Ctrl_S
          HideWindow(#Win_PL, #False)
          Pl_Event_Save()
        
      EndSelect

      
    ;}
    

; -----------------------
;     Bouton droit (2)
; -----------------------

    ; Clic gauche
    Case #WM_LBUTTONUP
    
      id.l = WindowFromPoint_(DesktopMouseX(), DesktopMouseY())
      Select id
      
      
        ;{ PLAY
        Case GadgetID(#BUTTON_PLAY)
          PlayMusic()
        ;}
        
        
        ;{ PAUSE
        Case GadgetID(#BUTTON_PAUSE)
          PauseMusic()
        ;}
          
          
        ;{ STOP
        Case GadgetID(#BUTTON_STOP)
          StopMusic()
        ;}
        
        
        ;{ NEXT
        Case GadgetID(#BUTTON_NEXT)
          If Player\etat = #MP3_ETAT_PLAY
            LaunchMusic(ALP_Choice(#ALP_NEXT))
          Else
            ChangeMusic(ALP_Choice(#ALP_NEXT))
          EndIf
        ;}
        
        
        ;{ PREVIOUS
        Case GadgetID(#BUTTON_PREV)
          If Player\etat = #MP3_ETAT_PLAY
            LaunchMusic(ALP_Choice(#ALP_PREV))
          Else
            ChangeMusic(ALP_Choice(#ALP_PREV))
          EndIf
        ;}
      
        
        Case GadgetID(#BUTTON_PAUSE)
          PauseMusic()
        
        ;{ OPEN
        Case GadgetID(#BUTTON_OPEN)
          dir$ = "D:\Lionel\MP3\"
          file$ = OpenFileRequester(GetPrefString("WINDOW", "MSG_LOAD"), dir$, GetExtensionPattern(), 0, #PB_Requester_MultiSelection)
          While file$ 
            AddToPlayList(file$)
            file$ = NextSelectedFileName()
          Wend
          
          If Player\track = -1 And GetNbTrackInPlayList()>0 And Player\autoLaunch = #True
            PlayMusic()
          EndIf
        ;}
        
        
        ;{ EXIT
        Case GadgetID(#BUTTON_EXIT)
          QuitALP()
        ;}
        
        
        ;{ REDUIRE
        Case GadgetID(#BUTTON_REDUCE)
          ShowWindow_(WindowID(#Win_Main), #SW_MINIMIZE)
        ;}
        
        
        
        
        ;{ NEW PL
        Case GadgetID(#BUTTON_PL_NEW)
          ;If Player\namePL <> ALP_Dossier$(#FOLDER_PL) + #DEF_PL$
          ;  SavePlayList(Player\namePL)
          ;EndIf
          ;StopMusic()
          ;Player\track = -1
          ;ClearList(PlayList())
          ;ClearGadgetItemList(#BUTTON_PL_LISTE)
          ;Player\namePL = ALP_Dossier$(#FOLDER_PL) + #DEF_PL$
          ;SetGadgetState(#BUTTON_TRACK_POS, 0)
          Pl_Event_New(#BUTTON_PL_LISTE, #BUTTON_TRACK_POS)
        ;}
        
        ;{ OPEN PL
        Case GadgetID(#BUTTON_PL_OPEN)
          ;filtre$ = GetPrefString("OTHER", "FILE_PL")+"|*"+#EXT_PL$
          ;file$ = OpenFileRequester(GetPrefString("INFO_BULLE", "PL_OPEN"), ALP_Dossier$(#FOLDER_PL), filtre$, 0)
          ;If file$ And file$ <> Player\namePL
          ;  ;SavePlayList(Player\namePL) ; On enregistre l'ancienne PL
          ;  ;StopMusic()
          ;  LoadPlayList(file$)
          ;EndIf
          Pl_Event_Open(#BUTTON_PL_LISTE)
        ;}
        
        
        ;{ SAVE PL
        Case GadgetID(#BUTTON_PL_SAVE)
          ;filtre$ = GetPrefString("OTHER", "FILE_PL")+"|*"+#EXT_PL$
          ;file$ = SaveFileRequester(GetPrefString("INFO_BULLE", "PL_SAVE"), ALP_Dossier$(#FOLDER_PL), filtre$, 0)
          ;If file$
          ;  SavePlayList(file$)
          ;EndIf
          Pl_Event_Save()
        ;}
        
        
      EndSelect 
    

; -----------------------------
;   Déplacement de la fenêtre
; -----------------------------

    Case #WM_LBUTTONDOWN
      Select WindowFromPoint_(DesktopMouseX(), DesktopMouseY())
        Case WindowID(#Win_Main)
          SendMessage_(WindowID(#Win_Main)  , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
        Case WindowID(#Win_Pl)
          SendMessage_(WindowID(#Win_Pl)    , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
        Case WindowID(#Win_Skin)
          SendMessage_(WindowID(#Win_Skin)  , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
        Case WindowID(#Win_Conf)
          SendMessage_(WindowID(#Win_Conf)  , #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
        Case WindowID(#Win_Search)
          SendMessage_(WindowID(#Win_Search), #WM_NCLBUTTONDOWN, #HTCAPTION, 0)
      EndSelect
   ;EndCase
    
    
; -------------------------
;      Event TIMER
; -------------------------
    Case #WM_TIMER
    
      Select TimerState
        
        Case #TIMER_BT1_DOWN
          If CountList(ALP_LibFolder())
            SendMessage_(TimerGadgetId, #WM_LBUTTONDOWN,0,0)
          Else
            TimerState = #TIMER_NULL
          EndIf
          
        Case #TIMER_BT1_UP
          SendMessage_(TimerGadgetId, #WM_LBUTTONUP,0,0)
          TimerGadgetId = GadgetID(#BUTTON_SRC_BT_SRC)
        
        Case #TIMER_BT2_DOWN
          Debug ">timer"
          SendMessage_(TimerGadgetId, #WM_LBUTTONDOWN,0,0)
          
        Case #TIMER_BT2_UP
          Debug ">timer2"
          SendMessage_(TimerGadgetId, #WM_LBUTTONUP,0,0)
          TimerState = #TIMER_NULL
        
        Default 
          TimerState = #TIMER_NULL
          
      EndSelect
      If TimerState
        TimerState + 1
        SetTimer_(WindowID(#Win_Main),1,StepTimer,0) ; TimerGadgetId ; TimerState = #TIMER_BT2_DOWN
      EndIf
   ;EndCase
    
    
; -------------------------
;     Touches ShortCut
; -------------------------
    
    Case #WM_HOTKEY
      Select EventwParam()
        
        Case #PB_Shortcut_Mci_Next
          If Player\etat = #MP3_ETAT_PLAY
            LaunchMusic(ALP_Choice(#ALP_NEXT))
          Else
            ChangeMusic(ALP_Choice(#ALP_NEXT))
          EndIf
        
        Case #PB_Shortcut_Mci_Prev
          If Player\etat = #MP3_ETAT_PLAY
            LaunchMusic(ALP_Choice(#ALP_PREV))
          Else
            ChangeMusic(ALP_Choice(#ALP_PREV))
          EndIf
        
        Case #PB_Shortcut_Mci_Stop
          StopMusic()
        
        Case #PB_Shortcut_Mci_Play
          If Player\etat = #MP3_ETAT_STOP
            PlayMusic()
          Else
            PauseMusic()
          EndIf
      EndSelect
   ;EndCase
    


; -----------------------
;      Event Systray
; -----------------------

    Case #PB_Event_SysTray
      
      Select EventType()
        Case #PB_EventType_RightClick
          ShowPopUpMenu()
        Case #PB_EventType_LeftDoubleClick 
          RestaureALP()
      EndSelect
   ;EndCase
    
    
    Default
      ImageMAJ(WindowFromPoint_(DesktopMouseX(), DesktopMouseY()))


  EndSelect
  ; --}
  


; - - - - - - - - - - - -
;        All MAJ
; - - - - - - - - - - - -
  
  
  If lastSongScan + #SCAN_FOR_DELETE_SONG <= ElapsedMilliseconds()
    lastSongScan = ElapsedMilliseconds()
    ForEach PlayList()
      If FileSize(PlayList()\nom) = -1
        index = ListIndex(PlayList())
        DeleteFromPL(index)
        SelectElement(PlayList(),index)
      EndIf
    Next
  EndIf
  

  If curSong <> Player\track
    SetGadgetState(#BUTTON_PL_LISTE, Player\track)
    If Player\track >= 0
      SelectElement(playList(), Player\track)
      LoadTagFromFile(playList()\nom)
      SetMaxTB(#BUTTON_TRACK_POS, Player\temps)
    Else
      ClearTagV2Data(Player\tag)
      SetMaxTB(#BUTTON_TRACK_POS, 0)
    EndIf
    curSong = Player\track
  EndIf
  

  If IsWindowVisible_(WindowID(#WIN_Main)) ; Si la fenêtre est visible
  
    If plSize <> CountList(PlayList())
      ActualiseGadgetPL(#BUTTON_PL_LISTE)
      plSize = CountList(PlayList())
    EndIf
    
    
    ; Affichage des infos sur la chanson jouée
    If lastUpadte + #UPDATE_TIME <= ElapsedMilliseconds() Or curSong <> Player\track
      UpdateTitleInfo()
      lastUpadte = ElapsedMilliseconds()
    EndIf
    
    
    If GetGadgetState(#BUTTON_SRC_BAR) <> 0
      SetGadgetText(#BUTTON_SRC_PROGRESS, "")
      SetGadgetState(#BUTTON_SRC_BAR, 0)
    EndIf
    
    
    If onTrackBar = #False
      SetGadgetState(#BUTTON_TRACK_POS, GetSongElapsedTime())
      If WindowFromPoint_(DesktopMouseX(), DesktopMouseY()) <> GadgetID(#BUTTON_TRACK_POS)
        If Player\track > -1
          GadgetToolTip(#BUTTON_TRACK_POS, ALP_PosSong$ + " : " + SetSecToStr(GetSongElapsedTime()) + "/" + SetSecToStr(Player\temps))
        Else
          GadgetToolTip(#BUTTON_TRACK_POS, ALP_PosSong$)
        EndIf
      EndIf
    EndIf
    
  EndIf

ForEver


End

; ExecutableFormat=Windows
; EOF
