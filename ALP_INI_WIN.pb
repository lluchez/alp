



;On vérifie que le fichier 'Setting.pref' exite

  If FileSize(#MAIN_PREF$) = -1
    Alert(#ERR_DEF_TITLE$, #ERR_NO_PREF$, #True)
  EndIf



;Déclaration des fenetres et du skin
  
  myALP.ALP_ALL
  *allInfoALP = @myALP ; Ptr Global (pr le CallBack ou autre)
  myALP\majBD\threadStatut = #SRC_STOP


;Termine avec msg d'erreur si auncun fichier n'est trouvé

  ALP_Langue$ = GetPrefStrFromFile(#MAIN_PREF$, "DATA", "lang")
  ALP_Langue$ = GetFileLanguage(ALP_Langue$, #DEF_LANG$)



;Skin

  myALP\Skin\name = GetPrefStrFromFile(#MAIN_PREF$, "DATA", "skin")
  If myALP\Skin\name = ""
    Alert(#ERR_DEF_TITLE$, "ERR_SKIN_NONE", #True)
  EndIf


;Initialisation du Player

  Player\track      = -1
  Player\etat       = #MP3_ETAT_STOP
  Player\alias      = #ALIAS_TRACK ; "morceau"
  Player\namePL     = ALP_Dossier$(#FOLDER_PL) + #DEF_PL$



;Chargement depuis 'Settings.prefs'

  GetInfoSettings(#MAIN_PREF$, myALP)


;Création de la liste de boutons et d'images

  MakeListes()


;Chargement de l'icone

  CatchImage(#IMG_ICON_ALP, ?Icones_16_16)


;Chargement du skin

  If ChoiceSkin(myALP) = #False
    End
  EndIf


;Ajout d'un racourci pour la suppression d'un elt de la playList

  AddKeyboardShortcut(#WIN_PL,      #PB_Shortcut_Delete, #MENU_SUPPR_PL)
  AddKeyboardShortcut(#WIN_CONF,    #PB_Shortcut_Delete, #MENU_SUPPR_CONF)
  AddKeyboardShortcut(#WIN_SEARCH,  #PB_Shortcut_Return, #MENU_SRC_BD)
  
  AddKeyboardShortcut(#Win_Main,    #PB_Shortcut_Control | #PB_Shortcut_N,  #Menu_Ctrl_N)
  AddKeyboardShortcut(#Win_Pl,      #PB_Shortcut_Control | #PB_Shortcut_N,  #Menu_Ctrl_N)
  AddKeyboardShortcut(#Win_Main,    #PB_Shortcut_Control | #PB_Shortcut_O,  #Menu_Ctrl_O)
  AddKeyboardShortcut(#Win_Pl,      #PB_Shortcut_Control | #PB_Shortcut_O,  #Menu_Ctrl_O)
  AddKeyboardShortcut(#Win_Main,    #PB_Shortcut_Control | #PB_Shortcut_S,  #Menu_Ctrl_S)
  AddKeyboardShortcut(#Win_Pl,      #PB_Shortcut_Control | #PB_Shortcut_S,  #Menu_Ctrl_S)



; Ajout des textes et des ToolTips

  SetBtTag()
  SetGadgetText(#BUTTON_CF_SRC_TEXT, Str(myALP\majBD\nDays))
  SetGadgetState(#BUTTON_SRC_CHK_SONG,#True)
  SetGadgetState(#BUTTON_SRC_CHK_ART, #True)
  SetGadgetState(#BUTTON_SRC_CHK_ALB, #True)


  
  FindFileLanguage()
  ClearGadgetItemList(#BUTTON_CF_LNG_LIST)
  ForEach ALP_LangFile()
    lang$ = EnleveExtension(ALP_LangFile())
    SetFirstLetterToMaj(@lang$)
    AddGadgetItem(#BUTTON_CF_LNG_LIST, -1, lang$)
  Next
  
  
; ExecutableFormat=Windows
; EOF
