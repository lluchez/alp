;over = GetDlgCtrlID_(over)


;- Up
#SYSTRAY_ICON = 0


; Les Fenetres et les Pop_Up
Enumeration
  #WIN_MAIN
  #WIN_PL
  #WIN_SKIN
  #WIN_SEARCH
  #WIN_CONF
  #POP_UP
EndEnumeration


; Les ShortCut clavier
Enumeration 176
  #PB_Shortcut_Mci_Next
  #PB_Shortcut_Mci_Prev
  #PB_Shortcut_Mci_Stop
  #PB_Shortcut_Mci_Play
EndEnumeration


; Les menus Pop_up
Enumeration
  #POP_RESTORE
  #POP_MINIMIZE
  #POP_SYSTRAY
  #POP_LECT_NORM
  #POP_LECT_RAND
  #POP_RPT_NONE
  #POP_RPT_TRK
  #POP_RPT_ALL
  #POP_AUTO_NO
  #POP_AUTO_YES
  #POP_MAX
  #POP_VOL_LESS
  #POP_VOL_MORE
  #POP_VOL_MUTE
  #POP_BAL_LESS
  #POP_BAL_MIL
  #POP_BAL_MORE
  #POP_QUIT
  
  #MENU_SUPPR_PL
  #MENU_SUPPR_CONF
  #MENU_SRC_BD
  #MENU_NEXT
  #MENU_PREV
  #MENU_STOP
  #MENU_PLAY
  
  #Menu_Ctrl_N
  #Menu_Ctrl_O
  #Menu_Ctrl_S
EndEnumeration


; Les Boutons
Enumeration 0
  #BUTTON_PLAY
  #BUTTON_PAUSE
  #BUTTON_STOP
  #BUTTON_OPEN
  #BUTTON_PREV
  #BUTTON_NEXT
  #BUTTON_EXIT
  #BUTTON_REDUCE
  #BUTTON_SYSTRAY
  #BUTTON_LABEL1
  #BUTTON_LABEL2
  #BUTTON_LABEL3
  #BUTTON_TRACK_POS
  #BUTTON_TRACK_VOL
  #BUTTON_TRACK_BAL
  
  #BUTTON_PL
  #BUTTON_SKIN
  #BUTTON_SEARCH
  #BUTTON_CONF

  #BUTTON_PL_EXIT
  #BUTTON_PL_LISTE
  #BUTTON_PL_TITLE
  #BUTTON_PL_NEW
  #BUTTON_PL_OPEN
  #BUTTON_PL_SAVE
  
  #BUTTON_SK_EXIT
  #BUTTON_SK_TITLE
  #BUTTON_SK_LISTE
  #BUTTON_SK_VIEW
  #BUTTON_SK_OK
  
  #BUTTON_CF_TITLE
  #BUTTON_CF_EXIT
  #BUTTON_CF_SCROLL
  #BUTTON_CF_FLD_LBL
  #BUTTON_CF_FLD_LIST
  #BUTTON_CF_FLD_NEW
  #BUTTON_CF_FLD_DEL
  #BUTTON_CF_EXT_LBL
  #BUTTON_CF_EXT_LIST
  #BUTTON_CF_EXT_NEW
  #BUTTON_CF_EXT_DEL
  #BUTTON_CF_LNG_LBL
  #BUTTON_CF_LNG_LIST
  #BUTTON_CF_SRC_LBL
  #BUTTON_CF_SRC_LBL1
  #BUTTON_CF_SRC_LBL2
  #BUTTON_CF_SRC_TEXT
  
  #BUTTON_SRC_EXIT
  #BUTTON_SRC_TITLE
  #BUTTON_SRC_NOM_LBL
  #BUTTON_SRC_NOM_TEXT
  #BUTTON_SRC_NOM_BT
  #BUTTON_SRC_CHK_SONG
  #BUTTON_SRC_CHK_ART
  #BUTTON_SRC_CHK_ALB
  #BUTTON_SRC_RESULT
  #BUTTON_SRC_LIST
  #BUTTON_SRC_ADD_PL
  #BUTTON_SRC_ADD_ALL
  #BUTTON_SRC_BAR
  #BUTTON_SRC_BT_SRC
  #BUTTON_SRC_PROGRESS
EndEnumeration


; Les images
Enumeration 0
  #IMG_WIN_MAIN
  #IMG_WIN_PL
  #IMG_WIN_SKIN
  #IMG_WIN_SRC
  #IMG_WIN_CONF
  
  #IMG_SKIN_VIEW
  
  #IMG_PLAY_OUT
  #IMG_PLAY_OVER
  #IMG_PAUSE_OUT
  #IMG_PAUSE_OVER
  #IMG_STOP_OUT
  #IMG_STOP_OVER
  #IMG_OPEN_OUT
  #IMG_OPEN_OVER
  #IMG_PREV_OUT
  #IMG_PREV_OVER
  #IMG_NEXT_OUT
  #IMG_NEXT_OVER
  #IMG_EXIT_OUT
  #IMG_EXIT_OVER
  #IMG_REDUC_OUT
  #IMG_REDUC_OVER
  #IMG_SYSTRAY_OUT
  #IMG_SYSTRAY_OVER
  
  #IMG_EXIT2_OUT
  #IMG_EXIT2_OVER
  #IMG_PL_OUT
  #IMG_PL_OVER
  #IMG_SKIN_OUT
  #IMG_SKIN_OVER
  #IMG_BD_OUT
  #IMG_BD_OVER
  #IMG_CONF_OUT
  #IMG_CONF_OVER
  
  #IMG_PL_NEW_OUT
  #IMG_PL_NEW_OVER
  #IMG_PL_OPEN_OUT
  #IMG_PL_OPEN_OVER
  #IMG_PL_SAVE_OUT
  #IMG_PL_SAVE_OVER

  #IMG_ICON_ALP
EndEnumeration


; Les types de boutons
Enumeration -1
  #BT_Min
  #BT_Image         ; ImageGadget
  #BT_Label         ; TextGadget
  #BT_ListView
  #BT_Button
  #BT_Scroll
  #BT_String        ; Champs de texte
  #BT_Check
  #BT_Progress
  #BT_TrackBar
  #BT_Max
EndEnumeration


; Les erreurs pour le 'SkinHasError()'
Enumeration 0
  #PB_SKIN_OK
  #PB_SKIN_NOTEXIST
  #PB_SKIN_IMG
  #PB_SKIN_PREF
  #PB_SKIN_DATA
EndEnumeration


Enumeration 0
  #FONT_INFO
  #FONT_TITLE
  #FONT_sTITLE
  #FONT_LIST
EndEnumeration

; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/



; Crer la liste des images
Procedure MakeImageListe()

  ClearList(mesImg())
  Restore Images
    Read img$
    While img$ <> ""
      AddElement(mesImg())
        mesImg() = img$
      Read img$
    Wend

EndProcedure



; Création de la liste des boutons
Procedure MakeBoutonListe()
  Protected img$, win.l, n1.l, n2.l, t.l
  
  ClearList(mesBt())
  Restore Boutons
    Read img$
    While img$ <> ""
      Read win
      Read n1
      Read n2
      Read t
      AddElement(mesBt())
        mesBt()\name      = img$
        mesBt()\win       = win
        mesBt()\out    = n1
        mesBt()\over   = n2
        mesBt()\type   = t
      Read img$
    Wend

EndProcedure



Procedure MakeListes()

  MakeImageListe()
  MakeBoutonListe()

EndProcedure




; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/





; Lecture des settings dans le fichier de configuration 'Settings.prefs'
Procedure GetInfoSettings(pref$, *info.ALP_ALL)

  If OpenPreferences(pref$)

    ; informations sur la fenetre
    *info\WinMain\propr = #PB_Window_BorderLess
    If PreferenceGroup("MAIN")
      *info\WinMain\posX    = ReadPreferenceLong("posX",     0)
      *info\WinMain\posY    = ReadPreferenceLong("posY",     0)
      If ReadPreferenceLong("centered", 0)
        *info\WinMain\propr = *info\WinMain\propr | #PB_Window_ScreenCentered
      EndIf
    EndIf
    
    *info\WinPL\propr = #PB_Window_BorderLess
    If PreferenceGroup("PLAYLIST")
      *info\WinPL\posX    = ReadPreferenceLong("posX",     0)
      *info\WinPL\posY    = ReadPreferenceLong("posY",     0)
      If ReadPreferenceLong("centered", 0)
        *info\WinPL\propr = *info\WinPL\propr | #PB_Window_ScreenCentered
      EndIf
    EndIf
    
    *info\WinSkin\propr = #PB_Window_BorderLess
    If PreferenceGroup("SKIN")
      *info\WinSkin\posX    = ReadPreferenceLong("posX",     0)
      *info\WinSkin\posY    = ReadPreferenceLong("posY",     0)
      If ReadPreferenceLong("centered", 0)
        *info\WinSkin\propr = *info\WinSkin\propr | #PB_Window_ScreenCentered
      EndIf
    EndIf
    
    *info\WinSearch\propr = #PB_Window_BorderLess
    If PreferenceGroup("SEARCH")
      *info\WinSearch\posX    = ReadPreferenceLong("posX",     0)
      *info\WinSearch\posY    = ReadPreferenceLong("posY",     0)
      If ReadPreferenceLong("centered", 0)
        *info\WinSearch\propr = *info\WinSearch\propr | #PB_Window_ScreenCentered
      EndIf
    EndIf
    
    *info\WinConfig\propr = #PB_Window_BorderLess
    If PreferenceGroup("CONF")
      *info\WinConfig\posX    = ReadPreferenceLong("posX",     0)
      *info\WinConfig\posY    = ReadPreferenceLong("posY",     0)
      If ReadPreferenceLong("centered", 0)
        *info\WinConfig\propr = *info\WinConfig\propr | #PB_Window_ScreenCentered
      EndIf
    EndIf

    If PreferenceGroup("INFO")
      Player\lecture    = ReadPreferenceLong("lecture",    0)
      Player\boucle     = ReadPreferenceLong("repeat",     0)
      Player\autoLaunch = ReadPreferenceLong("auto",       0)
      Player\volume     = ReadPreferenceLong("volume",  1000)
      Player\balance    = ReadPreferenceLong("balance",    0)
    Else
      Player\volume = 1000
    EndIf
    
    If PreferenceGroup("SCAN")
      *info\majBD\nDays     = ReadPreferenceLong("nDays", 0)
      *info\majBD\lastScan  = ReadPreferenceLong("lastScan", 0)
    EndIf

    If Player\lecture > #LECT_RANDOM Or Player\lecture < #LECT_NORMAL
      Player\lecture = #LECT_NORMAL
    EndIf
    
    If Player\boucle > #REPEAT_ALL Or Player\boucle < #REPEAT_NONE
      Player\boucle = #REPEAT_NONE
    EndIf
    
    If Player\autoLaunch
      Player\autoLaunch = #TRUE
    EndIf
    
    ClosePreferences() 
  Else
    Debug "Impossible d'ouvrir : " + pref$   
  EndIf

EndProcedure








; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/


Procedure.s FindImage(folder$, file$)
  
  If FileSize(folder$ + file$) > 0
    ProcedureReturn file$
  EndIf
  ForEach ALP_ImgFormat()
    If FileSize(folder$ + file$ + "." + ALP_ImgFormat()) > 0
      ProcedureReturn file$ + "." + ALP_ImgFormat()
    EndIf
  Next
  ProcedureReturn ""

EndProcedure


; Chargement des images
Procedure LoadImages(folder$)
  Protected img$

  ForEach mesImg()
    If IsImage(ListIndex(mesImg()))
      FreeImage(ListIndex(mesImg()))
    EndIf
    img$ = FindImage(folder$, mesImg())
    If img$
      If LoadImage(ListIndex(mesImg()), folder$ + img$) = #FALSE
        Debug "Erreur Load image : "
        Debug " >> " + img$
      EndIf
    Else
      Alert(GetPrefString("TITLE", "ERR_SKIN"), GetPrefString("ERROR", "ERR_SKIN_IMG"), #TRUE)
    EndIf
  Next

EndProcedure


Procedure CreateButton(num, *bouton.ALP_Bouton)
  Protected tmp.l

  If *bouton\win > -1
    UseGadgetList(WindowID(*bouton\win))
  EndIf
  
  If IsGadget(num)
  
    ResizeGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height)
    Select *bouton\type
      Case #BT_Image
        SetGadgetState(num, UseImage(*bouton\out))
      Case #BT_Label
        SetWindowLong_(GadgetID(num), #GWL_STYLE, 1342308352 | *bouton\param1)
      Case #BT_Scroll
        SetGadgetAttribute(num, #PB_ScrollArea_InnerWidth,  *bouton\param1)
        SetGadgetAttribute(num, #PB_ScrollArea_InnerHeight, *bouton\param2)
      Case #BT_String
        SetWindowLong_(GadgetID(num), #GWL_STYLE, 1342374016 | *bouton\param1)
      Case #BT_Progress
        SetProgressBarColor(num, *bouton\param1, *bouton\param2)
      Case #BT_TrackBar
        tmp.l = GetGadgetState(num)
        If *bouton\width > *bouton\height
          HorizontalTrackBar(num)
        Else
          VerticalTrackBar(num)
        EndIf
        If num <> #BUTTON_TRACK_POS
          ;SetMinTB(num, *bouton\param1)
          ;SetMaxTB(num, *bouton\param2)
          SetGadgetState(num, tmp)
        EndIf
    EndSelect
  
  Else
  
    Select *bouton\type
      Case #BT_Image
        ImageGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, UseImage(*bouton\out))
      Case #BT_Label
        TextGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, "", *bouton\param1)
      Case #BT_ListView
        If num = #BUTTON_PL_LISTE Or num = #BUTTON_SRC_LIST
          ListViewGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, #LBS_EXTENDEDSEL)
        Else
          ListViewGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height)
        EndIf
      Case #BT_Button
        ButtonGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, "")
      Case #BT_Scroll
        ScrollAreaGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, *bouton\param1, *bouton\param2, 30)
      Case #BT_String
        StringGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, "", *bouton\param1)
      Case #BT_Check
        CheckBoxGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, "")
      Case #BT_Progress
        ProgressBarGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, 0, 100)
        SetProgressBarColor(num, *bouton\param1, *bouton\param2)
      Case #BT_TrackBar
        If *bouton\width > *bouton\height
          ;TrackBarGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, *bouton\param1, *bouton\param2)
          TrackBarGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, 0, 1000)
        Else
          ;TrackBarGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, *bouton\param1, *bouton\param2, #PB_TrackBar_Vertical)
          TrackBarGadget(num, *bouton\posX, *bouton\posY, *bouton\width, *bouton\height, 0, 1000, #PB_TrackBar_Vertical)
        EndIf
        ;SetMinTB(num, *bouton\param1)
      Default
        Debug "Erreur de type de Bouton"
        Debug "> Num : " + Str(num) + " (val : " + Str(*bouton\type) + ")"
    EndSelect
  
  EndIf

EndProcedure



; Creation des boutons
Procedure MakeButtons()
  last.b = 0

  ForEach mesBt()
    CreateButton(ListIndex(mesBt()), mesBt())
    
    If mesBt()\hide
      HideGadget(ListIndex(mesBt()), #TRUE)
    Else
      HideGadget(ListIndex(mesBt()), #FALSE)
    EndIf
    
    If mesBt()\win = -1
      mesBt()\win = last
    Else
      last = mesBt()\win
    EndIf
  Next
  
  ;SetGadgetState(#BUTTON_SRC_CHK_SONG, #False)
  ;SetGadgetState(#BUTTON_SRC_CHK_ART,  #False)
  ;SetGadgetState(#BUTTON_SRC_CHK_ALB,  #False)

EndProcedure




; Creation du menu Pop-up
Procedure MakePopupMenu()

  If IsMenu(#POP_UP)
    FreeMenu(#POP_UP)
  EndIf
  
  If CreatePopupMenu(#POP_UP)
    If OpenPreferences(ALP_Langue$) And PreferenceGroup("POP_UP")
      If IsWindowVisible_(WindowID(#WIN_Main))
        MenuItem(#POP_MINIMIZE, ReadPreferenceString("MINIMIZ", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_SYSTRAY,  ReadPreferenceString("SYSTRAY", #ERR_PREF_KEY_MISS$))
      Else
        MenuItem(#POP_RESTORE,  ReadPreferenceString("RESTORE", #ERR_PREF_KEY_MISS$))
      EndIf
    
      MenuTitle(ReadPreferenceString("LECT", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_LECT_NORM,  ReadPreferenceString("LECT_N", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_LECT_RAND,  ReadPreferenceString("LECT_R", #ERR_PREF_KEY_MISS$))
        CloseSubMenu()
      MenuTitle(ReadPreferenceString("REP", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_RPT_NONE,   ReadPreferenceString("REP_N", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_RPT_TRK,    ReadPreferenceString("REP_T", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_RPT_ALL,    ReadPreferenceString("REP_A", #ERR_PREF_KEY_MISS$))
        CloseSubMenu()
      MenuTitle(ReadPreferenceString("AUTO", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_AUTO_NO,    ReadPreferenceString("AUTO_N", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_AUTO_YES,   ReadPreferenceString("AUTO_Y", #ERR_PREF_KEY_MISS$))
        CloseSubMenu()
      MenuTitle(ReadPreferenceString("VOLUME", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_VOL_LESS,   ReadPreferenceString("VOL-", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_VOL_MORE,   ReadPreferenceString("VOL+", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_VOL_MUTE,   ReadPreferenceString("MUTE", #ERR_PREF_KEY_MISS$))
        CloseSubMenu()
      MenuTitle(ReadPreferenceString("BALANCE", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_BAL_LESS,   ReadPreferenceString("BAL_L", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_BAL_MIL,    ReadPreferenceString("BAL_M", #ERR_PREF_KEY_MISS$))
        MenuItem(#POP_BAL_MORE,   ReadPreferenceString("BAL_R", #ERR_PREF_KEY_MISS$))
        CloseSubMenu()
      MenuItem(#POP_QUIT,  ReadPreferenceString("QUIT", #ERR_PREF_KEY_MISS$))
      
      ClosePreferences()
    Else
      Alert(#ERR_DEF_TITLE$, #ERR_LANG_FILE$ + " " + #ERR_S_DOWN$, #TRUE)
    EndIf
      
    ProcedureReturn(#TRUE)
  EndIf
  ProcedureReturn(#FALSE)

EndProcedure



; Creation de la fenetre
Procedure MakeWindow(win, *Window.Fenetre, winName$)
  Protected idImg.l

  idImg = UseImage(win)
  If IsWindow(win)
    UseWindow(win)
    ResizeWindow(ImageWidth(), ImageHeight())
  Else
    *Window\propr | #PB_Window_Invisible
    If *Window\posX >= GetSystemMetrics_(#SM_CXSCREEN)-100 Or *Window\posY >= GetSystemMetrics_(#SM_CYSCREEN)-60 Or *Window\posX < 0 Or *Window\posY < 0
      *Window\propr | #PB_Window_ScreenCentered
    EndIf
    OpenWindow(win, *Window\posX, *Window\posY, ImageWidth(), ImageHeight(), *Window\propr , winName$)
    CreateGadgetList(WindowID())
  EndIf
  SkinWin(WindowID(), idImg)
EndProcedure







; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/




Procedure SetBtTag()

 ;Labels
  SetGadgetText(#BUTTON_PL_TITLE,   GetPrefString("LABEL", "PL"))
  SetGadgetText(#BUTTON_SK_TITLE,   GetPrefString("LABEL", "SKIN"))
  SetGadgetText(#BUTTON_CF_TITLE,   GetPrefString("LABEL", "CONF"))
  SetGadgetText(#BUTTON_SRC_TITLE,  GetPrefString("LABEL", "SEARCH"))
  
  SetGadgetText(#BUTTON_CF_FLD_LBL, GetPrefString("LABEL", "CF_FOLD"))
  SetGadgetText(#BUTTON_CF_EXT_LBL, GetPrefString("LABEL", "CF_EXT"))
  SetGadgetText(#BUTTON_CF_LNG_LBL, GetPrefString("LABEL", "CF_LANG"))
  SetGadgetText(#BUTTON_CF_SRC_LBL, GetPrefString("LABEL", "CF_SRC"))
  SetGadgetText(#BUTTON_CF_SRC_LBL1,GetPrefString("LABEL", "CF_SRC1"))
  SetGadgetText(#BUTTON_CF_SRC_LBL2,GetPrefString("LABEL", "CF_SRC2"))
  
  SetGadgetText(#BUTTON_SRC_NOM_LBL,  GetPrefString("LABEL", "SRC_NOM"))
  SetGadgetText(#BUTTON_SRC_CHK_SONG, GetPrefString("LABEL", "SRC_C_T"))
  SetGadgetText(#BUTTON_SRC_CHK_ART,  GetPrefString("LABEL", "SRC_C_C"))
  SetGadgetText(#BUTTON_SRC_CHK_ALB,  GetPrefString("LABEL", "SRC_C_A"))
  SetGadgetText(#BUTTON_SRC_RESULT,   GetPrefString("LABEL", "SRC_RESULT"))
  ALP_ProcessBeginStr$ = GetPrefString("LABEL", "SRC_PROC")
  
  
 ;Boutons
  SetGadgetText(#BUTTON_SK_OK,      GetPrefString("BOUTON", "OK"))
  SetGadgetText(#BUTTON_CF_FLD_NEW, GetPrefString("BOUTON", "NEW"))
  SetGadgetText(#BUTTON_CF_FLD_DEL, GetPrefString("BOUTON", "DEL"))
  SetGadgetText(#BUTTON_CF_EXT_NEW, GetPrefString("BOUTON", "NEW"))
  SetGadgetText(#BUTTON_CF_EXT_DEL, GetPrefString("BOUTON", "DEL"))
  SetGadgetText(#BUTTON_SRC_ADD_PL ,GetPrefString("BOUTON", "ADD_PL"))
  SetGadgetText(#BUTTON_SRC_ADD_ALL,GetPrefString("BOUTON", "ADD_ALL"))
  SetGadgetText(#BUTTON_SRC_BT_SRC ,GetPrefString("BOUTON", "MAJ"))
  SetGadgetText(#BUTTON_SRC_NOM_BT ,GetPrefString("BOUTON", "SEARCH"))
  
  
 ;ToolTips
  If OpenPreferences(ALP_Langue$) And PreferenceGroup("INFO_BULLE")
    GadgetToolTip(#BUTTON_PLAY      ,ReadPreferenceString("PLAY",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_PAUSE     ,ReadPreferenceString("PAUSE",  #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_STOP      ,ReadPreferenceString("STOP",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_OPEN      ,ReadPreferenceString("OPEN",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_PREV      ,ReadPreferenceString("PREV",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_NEXT      ,ReadPreferenceString("NEXT",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_EXIT      ,ReadPreferenceString("EXIT",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_REDUCE    ,ReadPreferenceString("REDUCE", #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SYSTRAY   ,ReadPreferenceString("MINIMIZE", #ERR_PREF_KEY_MISS$))
    
    GadgetToolTip(#BUTTON_PL        ,ReadPreferenceString("OPEN_PL",    #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SKIN      ,ReadPreferenceString("OPEN_SKIN",  #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SEARCH    ,ReadPreferenceString("OPEN_BD",    #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_CONF      ,ReadPreferenceString("OPEN_CONF",  #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_PL_EXIT   ,ReadPreferenceString("CLOSE",      #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_PL_OPEN   ,ReadPreferenceString("PL_OPEN",    #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_PL_SAVE   ,ReadPreferenceString("PL_SAVE",    #ERR_PREF_KEY_MISS$))
    
    GadgetToolTip(#BUTTON_SK_EXIT   ,ReadPreferenceString("CLOSE",  #ERR_PREF_KEY_MISS$))

    GadgetToolTip(#BUTTON_CF_EXIT   ,   ReadPreferenceString("CLOSE",    #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_CF_FLD_LIST,  ReadPreferenceString("FLD_LIST", #ERR_PREF_KEY_MISS$))
    
    GadgetToolTip(#BUTTON_SRC_EXIT,     ReadPreferenceString("CLOSE",   #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_CHK_SONG, ReadPreferenceString("SRC_SONG",#ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_CHK_ART,  ReadPreferenceString("SRC_ART", #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_CHK_ALB,  ReadPreferenceString("SRC_ALB", #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_NOM_TEXT, ReadPreferenceString("SEARCH",  #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_NOM_BT,   ReadPreferenceString("GO_SRC",  #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_BT_SRC,   ReadPreferenceString("MAJ",     #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_ADD_PL ,  ReadPreferenceString("ADD_PL",  #ERR_PREF_KEY_MISS$))
    GadgetToolTip(#BUTTON_SRC_ADD_ALL,  ReadPreferenceString("ADD_ALL", #ERR_PREF_KEY_MISS$))
    
    ALP_PosSong$ = ReadPreferenceString("TB_POS", #ERR_PREF_KEY_MISS$)
      GadgetToolTip(#BUTTON_TRACK_POS, ALP_PosSong$)
    ALP_Volume$ = ReadPreferenceString("TB_VOL", #ERR_PREF_KEY_MISS$)
      GadgetToolTip(#BUTTON_TRACK_VOL, ALP_Volume$ + Str(Player\volume / 10))
    ALP_Balance$ = ReadPreferenceString("TB_BAL", #ERR_PREF_KEY_MISS$)
      GadgetToolTip(#BUTTON_TRACK_BAL, ALP_Balance$ + Str(Player\balance / 10))
    ClosePreferences()
  Else
    Alert(#ERR_DEF_TITLE$, #ERR_LANG_FILE$ + " " + #ERR_S_DOWN$, #True)
  EndIf

EndProcedure




; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/



; Réajuste la valeur des cases checked
Procedure ShowPopUpMenu()
  Protected i.l
  
  MakePopupMenu()
  
  ; Mode de lecture
  If Player\lecture = #LECT_NORMAL
    SetMenuItemState(#POP_UP, #POP_LECT_NORM, #True)
  Else
    SetMenuItemState(#POP_UP, #POP_LECT_RAND, #True)
  EndIf
  
  ;{
  Select Player\boucle
    Case #REPEAT_NONE
      SetMenuItemState(#POP_UP, #POP_RPT_NONE , #True)
    Case #REPEAT_TRACK
      SetMenuItemState(#POP_UP, #POP_RPT_TRK  , #True)
    Case #REPEAT_ALL
      SetMenuItemState(#POP_UP, #POP_RPT_ALL  , #True)
  EndSelect
  ;}
  
  ; Mode de lecture
  If Player\autoLaunch
    SetMenuItemState(#POP_UP, #POP_AUTO_YES , #True)
  Else
    SetMenuItemState(#POP_UP,#POP_AUTO_NO   , #True)
  EndIf
  
  If Player\muet
    SetMenuItemState(#POP_UP, #POP_VOL_MUTE, #True)
  EndIf
  
  DisplayPopupMenu(#POP_UP,WindowID())

EndProcedure




; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/




Procedure HideShowLinkedButton(gadget.l, etat1.b, etat2.b)

  If IsGadget(gadget)=#False
    ProcedureReturn #False
  EndIf

  SelectElement(mesBt(), gadget)
  If IsGadget(mesBt()\show)
    HideGadget(gadget, etat1)
    HideGadget(mesBt()\show, etat2)
    ProcedureReturn #True
  EndIf

EndProcedure



; Remet tous les boutons non cachés dans leur état normal
;   Affiche l'image 'over' pour le bouton avec l'id "id"
Procedure ImageMAJ(id.l)

  Select Player\etat
    Case #MP3_ETAT_PLAY
      HideShowLinkedButton(#BUTTON_PLAY, #True, #False)
      
    Case #MP3_ETAT_PAUSE
      HideShowLinkedButton(#BUTTON_PAUSE, #True, #False)
    
    Case #MP3_ETAT_STOP
      HideShowLinkedButton(#BUTTON_STOP, #True, #False)
      HideShowLinkedButton(#BUTTON_PLAY, #False, #True)
  EndSelect
  
  ;over = GetDlgCtrlID_(over)
  ForEach mesBt()
    If mesBt()\type = #BT_Image
      If GadgetID(ListIndex(mesBt())) = id
        SetGadgetState(ListIndex(mesBt()), UseImage(mesBt()\over))
      Else
        SetGadgetState(ListIndex(mesBt()), UseImage(mesBt()\out))
      EndIf
    EndIf
  Next

EndProcedure







; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/


; Convertit un texte : 'Chanteur : %SINGER%' en 'Chanteur : Benassi'
Procedure.s ConvertTextForInfo(texte$)
  Protected i.b, pourc.w

  pourc = 80
  If (Player\track >= 0)
    texte$ = ReplaceString(texte$, "%ALP%",       #PROJECT_NAME$)
    texte$ = ReplaceString(texte$, "%MINIALP%",   #SHORT_PROJECT_NAME$)
    texte$ = ReplaceString(texte$, "%SONG%",      RemoveMajIfTooMuch(Player\Tag\title, pourc))
    texte$ = ReplaceString(texte$, "%SINGER%",    RemoveMajIfTooMuch(Player\Tag\artist, pourc))
    texte$ = ReplaceString(texte$, "%ALBUM%",     RemoveMajIfTooMuch(Player\Tag\album, pourc))
    texte$ = ReplaceString(texte$, "%TRACK%",     RemoveMajIfTooMuch(Str(Player\track+1), pourc))
    texte$ = ReplaceString(texte$, "%NEW_LINE%",  #CRLF$)
    texte$ = ReplaceString(texte$, "%ELAPS%",     SetSecToStr(GetSongElapsedTime()))
    texte$ = ReplaceString(texte$, "%TTL%",       SetSecToStr(Player\temps - GetSongElapsedTime()))
    texte$ = ReplaceString(texte$, "%DURATION%",  SetSecToStr(Player\temps))
    For i = 1 To 5
      texte$ = ReplaceString(texte$, "%INFO"+Str(i)+"%",  GetPrefString("INFO_SONG", Str(i)))
    Next i
    ProcedureReturn texte$
  Else
    ProcedureReturn "" 
  EndIf

EndProcedure


Procedure.s SplitLine(texte.s, maxSize.l)
  Protected ch1.s, ch2.s

  For i = 1 To CountString(texte, #CRLF$)+1
    ch1 = StringField(texte, i, #CRLF$)
    ch2 = ch1
    While TextLength(ch2) > maxSize
      SetMid(@ch2, Len(ch2), 0)
    Wend
    texte = ReplaceString(texte, ch1, ch2)
  Next i
  ProcedureReturn texte

EndProcedure


; Affichage des infos sur la chanson jouée
Procedure UpdateTitleInfo()
  Protected ch$, i.b, *skin.SkinALP
  Dim ch.s(3)
  *skin = *allInfoALP\Skin
  
  For i = 0 To 2
    ch(i) = ConvertTextForInfo(*skin\info[i])
  Next i
  
  ; Affichage principal
    For i = 0 To 2
      If ch(i) <> *allInfoALP\info[i]
        *allInfoALP\info[i] = ch(i)
        If StartDrawing(WindowOutput())
          DrawingFont(UseFont(#FONT_INFO+1))
          ch(i) = SplitLine(ch(i), GadgetWidth(#BUTTON_LABEL1+i))
          StopDrawing()
          SetGadgetText(#BUTTON_LABEL1+i, ch(i))
        EndIf
      ;Else
      ;  ch(i) = ""
      EndIf
    Next i
  
  ;For i = 0 To 2
    ;If ch(i) <> ""
      ;SetGadgetText(#BUTTON_LABEL1+i, ch(i))
    ;EndIf
  ;Next i
  
  ; Nom de la fenêtre
  ch$ = ConvertTextForInfo(*skin\info[3])
  If ch$ = ""
    ch$ = #PROJECT_NAME$
  EndIf
  If ch$ <> GetWindowTitle(#WIN_MAIN)
    SetWindowTitle(#WIN_MAIN, ch$)
  EndIf

EndProcedure








; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/


;- Quit

Procedure QuitALP()
  Protected file.l
  
  If IsWindow(#Win_Main) And IsWindow(#Win_Pl) And IsWindow(#Win_Skin) And IsWindow(#Win_Search) And IsWindow(#Win_Conf)
    
    UnregisterHotKey_(WindowID(#Win_Main),#PB_Shortcut_Mci_Next)
    UnregisterHotKey_(WindowID(#Win_Main),#PB_Shortcut_Mci_Prev)
    UnregisterHotKey_(WindowID(#Win_Main),#PB_Shortcut_Mci_Stop)
    UnregisterHotKey_(WindowID(#Win_Main),#PB_Shortcut_Mci_Play)
    
    If CreatePreferences("tmp"+#EXT_PREF$)
    
      PreferenceGroup("MAIN")
      UseWindow(#Win_Main)
        WritePreferenceLong("posX", WindowX())
        WritePreferenceLong("posY", WindowY())
        WritePreferenceLong("centered", 0)
      
      PreferenceGroup("PLAYLIST")
      UseWindow(#Win_Pl)
        WritePreferenceLong("posX", WindowX())
        WritePreferenceLong("posY", WindowY())
        WritePreferenceLong("centered", 0)
      
      PreferenceGroup("SKIN")
      UseWindow(#Win_Skin)
        WritePreferenceLong("posX", WindowX())
        WritePreferenceLong("posY", WindowY())
        WritePreferenceLong("centered", 0)
      
      PreferenceGroup("SEARCH")
      UseWindow(#Win_Search)
        WritePreferenceLong("posX", WindowX())
        WritePreferenceLong("posY", WindowY())
        WritePreferenceLong("centered", 0)
      
      PreferenceGroup("CONF")
      UseWindow(#Win_Conf)
        WritePreferenceLong("posX", WindowX())
        WritePreferenceLong("posY", WindowY())
        WritePreferenceLong("centered", 0)
      
      PreferenceGroup("INFO")
        WritePreferenceLong("lecture", Player\lecture)
        WritePreferenceLong("repeat",  Player\boucle)
        WritePreferenceLong("auto",    Player\autoLaunch)
        WritePreferenceLong("volume",  Player\volume)
        WritePreferenceLong("balance", Player\balance)
      
      
      PreferenceGroup("DATA")
        WritePreferenceString("lang", ReplaceString(GetFilePart(ALP_Langue$), #EXT_PREF$, ""))
        WritePreferenceString("skin", *allInfoALP\Skin\name)
      
      PreferenceGroup("SCAN")
        WritePreferenceLong("nDays",    *allInfoALP\majBD\nDays)
        WritePreferenceLong("lastScan", *allInfoALP\majBD\lastScan)

      ClosePreferences()
      DeleteFile(#MAIN_PREF$)
      RenameFile("tmp"+#EXT_PREF$, #MAIN_PREF$)
    EndIf
  
    
    SavePlayListBeforeEnding()
    
    
    If *allInfoALP\majBD\threadID
      KillThread(*allInfoALP\majBD\threadID)
    EndIf
    
    
    ALP_BD_Close()
    UnIniConnection()
    
    
    If Player\track > -1 And Player\etat = #MP3_ETAT_PLAY
      StopMusic()
    EndIf
    
    
    If hBrush
      DeleteObject_(hBrush)
    EndIf
    
    
  EndIf

  ;Fin
  End

EndProcedure



;Procedure ClicOnGadget(nGadget.l)
;  If IsGadget(nGadget)
;    SendMessage_(GadgetID(nGadget),#WM_LBUTTONDOWN,0,0)
;    Sleep_(20)
;    SendMessage_(GadgetID(nGadget),#WM_LBUTTONUP,0,0)
;    ProcedureReturn #True
;  EndIf
;EndProcedure



Procedure RestaureALP()

  ShowWindow_(WindowID(#Win_Main),#SW_MINIMIZE)
  Delay(250)
  ShowWindow_(WindowID(#Win_Main),#SW_RESTORE)
  RemoveSysTrayIcon(#SYSTRAY_ICON)

EndProcedure



Procedure ALP_ToSystray()

  HideWindow(#Win_Skin,   #True)
  HideWindow(#Win_PL,     #True)
  HideWindow(#Win_Search, #True)
  HideWindow(#Win_Conf,   #True)
  ShowWindow_(WindowID(#Win_Main), #SW_HIDE)
  AddSysTrayIcon(#SYSTRAY_ICON,     WindowID(#Win_Main), UseImage(#IMG_ICON_ALP))
  SysTrayIconToolTip(#SYSTRAY_ICON, #PROJECT_NAME$)

EndProcedure






; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/





Procedure.l GetBackColorOfButton(nGadget.l, nWin.l, nImg.l)
  Protected pt.Point, ReturnValue.l
  
  If IsImage(nImg)
    UseImage(nImg)
    pt\x = GadgetX(nGadget)
    pt\y = GadgetY(nGadget)
      
    If nWin = #Win_Conf
      If pt\x > ImageWidth() Or pt\y > ImageHeight()
        pt\x - GetScrollPos_(GadgetID(#BUTTON_CF_SCROLL), #SB_HORZ)
        pt\y - GetScrollPos_(GadgetID(#BUTTON_CF_SCROLL), #SB_VERT)
      EndIf
    EndIf
    
    If StartDrawing(ImageOutput())
      ReturnValue = Point(pt\x, pt\y)
      StopDrawing()
      ProcedureReturn ReturnValue
    EndIf
  Else
    Debug "Erreur Image doesn't exist : " + Str(nImg)
    ProcedureReturn -1
  EndIf

EndProcedure






;{--
;- Window CallBack()
Procedure WindowCallback( WindowID, Message, wParam, lParam )
  Protected id.l, nFont.b, pt.l
 
  If sBrush
    DeleteObject_(sBrush)
    sBrush = 0
  EndIf
  
  result = #PB_ProcessPureBasicEvents
  id = GetDlgCtrlID_(lParam)
  
  Select Message
  
    ;{--
    Case #WM_CTLCOLORSTATIC
      
      nFont = #FONT_sTITLE
      Select lParam
      
        Case GadgetID(#BUTTON_LABEL1)
          nFont = #FONT_INFO
        Case GadgetID(#BUTTON_LABEL2)
          nFont = #FONT_INFO
        Case GadgetID(#BUTTON_LABEL3)
          nFont = #FONT_INFO
        
        Case GadgetID(#BUTTON_PL_TITLE)
          nFont = #FONT_TITLE
        Case GadgetID(#BUTTON_SK_TITLE)
          nFont = #FONT_TITLE
        Case GadgetID(#BUTTON_CF_TITLE)
          nFont = #FONT_TITLE
        Case GadgetID(#BUTTON_SRC_TITLE)
          nFont = #FONT_TITLE
        Case GadgetID(#BUTTON_CF_SRC_LBL)
          nFont = #FONT_sTITLE

        Case GadgetID(#BUTTON_CF_FLD_LBL)
        Case GadgetID(#BUTTON_CF_EXT_LBL)
        Case GadgetID(#BUTTON_CF_LNG_LBL)
        Case GadgetID(#BUTTON_CF_SRC_LBL1)
        Case GadgetID(#BUTTON_CF_SRC_LBL2)
        
        Case GadgetID(#BUTTON_SRC_NOM_LBL)
        Case GadgetID(#BUTTON_SRC_NOM_TEXT)
        Case GadgetID(#BUTTON_SRC_CHK_SONG)
        Case GadgetID(#BUTTON_SRC_CHK_ART)
        Case GadgetID(#BUTTON_SRC_CHK_ALB)
        Case GadgetID(#BUTTON_SRC_RESULT)
        Case GadgetID(#BUTTON_SRC_PROGRESS)
        Case GadgetID(#BUTTON_TRACK_POS)
        Case GadgetID(#BUTTON_TRACK_VOL)
        Case GadgetID(#BUTTON_TRACK_BAL)
        
        Default
          ProcedureReturn result

      EndSelect
      
      SelectElement(mesBt(), id)
      pt = GetBackColorOfButton(id, mesBt()\win, mesBt()\win)
      If pt <> -1
        result = CreateSolidBrush_(pt)
        sBrush = result
        SetBkColor_(wParam, pt)
      EndIf
      
      SetTextColor_(wParam, *allInfoALP\font[nFont]\couleur)
    ; --}    
    
    
    ;{--
    Case #WM_CTLCOLORLISTBOX
      Select lParam
        Case GadgetID(#BUTTON_SK_LISTE)
        Case GadgetID(#BUTTON_PL_LISTE)
        Case GadgetID(#BUTTON_CF_FLD_LIST)
        Case GadgetID(#BUTTON_CF_EXT_LIST)
        Case GadgetID(#BUTTON_CF_LNG_LIST)
        Case GadgetID(#BUTTON_SRC_LIST)
        
        Default
          ProcedureReturn result
    
      EndSelect
      
      
      SelectElement(mesBt(), id)
      pt = GetBackColorOfButton(id, mesBt()\win, mesBt()\win)
      If pt <> -1
        result = CreateSolidBrush_(pt)
        sBrush = result
        SetBkColor_(wParam, pt)
      EndIf
      
      SetTextColor_(wParam, *allInfoALP\font[#FONT_LIST]\couleur)
      
      ;SelectElement(mesBt(), id)
      ;UseImage(mesBt()\win)
      
      ;If StartDrawing(ImageOutput())
      ;  result = CreateSolidBrush_(Point(GadgetX(id)+5, GadgetY(id)+5))
      ;  sBrush = result
      ;  StopDrawing()
      ;Else
      ;  Debug "Can't draw..."
      ;EndIf
      
      ;SetBkMode_(wParam,#TRANSPARENT)
      ;SetTextColor_(wParam,*allInfoALP\font[#FONT_LIST]\couleur)
    ; --}
    
    
    Case #WM_QUERYENDSESSION
      QuitALP()
      ProcedureReturn #True
  
  
  EndSelect

  ProcedureReturn result
 
EndProcedure
; --}




Procedure DefWindowCallback(WindowID.l, Message.l, wParam.l, lParam.l)

  ProcedureReturn #PB_ProcessPureBasicEvents
 
EndProcedure




; IDE Options = PureBasic v3.94 (Windows - x86)
; CursorPosition = 587
; FirstLine = 540
; Folding = -----
