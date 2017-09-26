



; Chargement des données depuis le fichier PREFS du skin
Procedure LoadSkinInfo(*info.ALP_ALL)
  Protected opt.b, i.b

  If OpenPreferences(ALP_Dossier$(#FOLDER_SKIN) + *info\Skin\name + "\" + #SKIN_PREF$)

    If PreferenceGroup("SKIN_INFO")
      *info\Skin\autor      = ReadPreferenceString("autor",   "")
      *info\Skin\date       = ReadPreferenceString("date",    "")
      *info\Skin\info[0]    = ReadPreferenceString("info1",   "")
      *info\Skin\info[1]    = ReadPreferenceString("info2",   "")
      *info\Skin\info[2]    = ReadPreferenceString("info3",   "")
      *info\Skin\info[3]    = ReadPreferenceString("info4",   "")
    EndIf
    
    For i = 0 To 3
      If PreferenceGroup("FONT"+Str(i+1))
        *info\font[i]\police   = ReadPreferenceString("police", #FONT_POLICE)
        *info\font[i]\taille   = ReadPreferenceLong("size",     #FONT_TAILLE)
        *info\font[i]\option   = #PB_Font_HighQuality
        opt = ReadPreferenceLong("bold", 0)
        If opt : *info\font[i]\option | #PB_Font_Bold: EndIf
        opt = ReadPreferenceLong("italic", 0)
        If opt : *info\font[i]\option | #PB_Font_Italic: EndIf
        opt = ReadPreferenceLong("underline", 0)
        If opt : *info\font[i]\option | #PB_Font_Underline: EndIf
        *info\font[i]\couleur  = ReadPreferenceLong("color",   0)
      EndIf
    Next i


    ; informations sur les boutons
    ForEach mesBt()
      If PreferenceGroup(mesBt()\name)
        mesBt()\posX    = ReadPreferenceLong("posX",    0)
        mesBt()\posY    = ReadPreferenceLong("posY",    0)
        mesBt()\width   = ReadPreferenceLong("width",   0)
        mesBt()\height  = ReadPreferenceLong("height",  0)
        mesBt()\show    = ReadPreferenceLong("show",   -1)
        mesBt()\hide    = ReadPreferenceLong("hide",    0)
        mesBt()\param1  = ReadPreferenceLong("param1",  0)
        mesBt()\param2  = ReadPreferenceLong("param2",  0)
      EndIf
    Next

    ClosePreferences() 
  Else
    Debug "Impossible d'ouvrir : " + *info\Skin\name 
  EndIf
   
EndProcedure




; Renvoi #False si le skin est valide
;    >0 sinon
Procedure SkinHasError(skin$)

  ;On vérifie que le dossier existe bien
  If FileSize(ALP_Dossier$(#FOLDER_SKIN) + skin$) <> -2
    ProcedureReturn #PB_SKIN_NOTEXIST
  EndIf
  
  ; On vérifie qu'il y a bien toutes les images
  ForEach mesImg()
    If FindImage(ALP_Dossier$(#FOLDER_SKIN) + skin$ + #SKIN_IMG$, mesImg()) = ""
      ProcedureReturn #PB_SKIN_IMG
    EndIf
  Next
  
  ; Recherche du fichier de configuration
  If FileSize(ALP_Dossier$(#FOLDER_SKIN) + skin$ + "\" + #SKIN_PREF$) = -1
    ProcedureReturn #PB_SKIN_PREF
  EndIf
  
  OpenPreferences(ALP_Dossier$(#FOLDER_SKIN) + skin$ + "\" + #SKIN_PREF$)
  ForEach mesBt()
    If PreferenceGroup(mesBt()\name) = #False
      ProcedureReturn #PB_SKIN_DATA
    EndIf
  Next
  ClosePreferences()
  
  ProcedureReturn #PB_SKIN_OK

EndProcedure



; Renvoi l'index du skin en cour
Procedure SearchSkin(mySkin$)
  Protected FileType.w, name$, ind.w

  ClearGadgetItemList(#BUTTON_SK_LISTE)
  
  ind = -1
  If ExamineDirectory(#PB_ANY, ALP_Dossier$(#FOLDER_SKIN), "*")
    Repeat
      FileType = NextDirectoryEntry()
      If FileType = #DIR_IS_DIR
        name$ = DirectoryEntryName()
        If SkinHasError(name$) = #False
          If name$ = mySkin$
            ind = CountGadgetItems(#BUTTON_SK_LISTE)
          EndIf
          AddGadgetItem(#BUTTON_SK_LISTE, -1, name$)
        EndIf
      EndIf
    Until FileType = 0
    SetGadgetState(#BUTTON_SK_LISTE, ind)
  EndIf
  
  ProcedureReturn ind

EndProcedure




; Repositionnement de l'aperçu du skin
Procedure SetSkinPreview(skinName$)
  Protected nomImg$

  If skinName$
    SelectElement(mesBt(), #BUTTON_SK_VIEW)
  
    If IsImage(mesBt()\out)
      FreeImage(mesBt()\out)
    EndIf
    
    SelectElement(mesImg(), #IMG_SKIN_VIEW)
    nomImg$ = FindImage(ALP_Dossier$(#FOLDER_SKIN) + skinName$ + #SKIN_IMG$, mesImg())

    If nomImg$
      LoadImage(mesBt()\out, ALP_Dossier$(#FOLDER_SKIN) + skinName$ + #SKIN_IMG$ + nomImg$)
      SetGadgetState(#BUTTON_SK_VIEW, mesBt()\out)
      UseImage(mesBt()\out)
      w = ImageWidth()
      h = ImageHeight()
      x = mesBt()\posX + (mesBt()\width -w)/2
      y = mesBt()\posY + (mesBt()\height-h)/2
      ResizeGadget(#BUTTON_SK_VIEW, x, y, w, h)
   EndIf
  EndIf
  
EndProcedure




; On charge les fonts et on les applique
Procedure SetFont(*info.ALP_ALL)

  For i = 0 To 3
    If *info\font[i]\nFont
      CloseFont(1+i)
    EndIf
    *info\font[i]\nFont = LoadFont(1+i, *info\font[i]\police, *info\font[i]\taille, *info\font[i]\option)
  Next i
  
  SetGadgetFont(#BUTTON_LABEL1,   *info\font[#FONT_INFO]\nFont)
  SetGadgetFont(#BUTTON_LABEL2,   *info\font[#FONT_INFO]\nFont)
  SetGadgetFont(#BUTTON_LABEL3,   *info\font[#FONT_INFO]\nFont)
  
  SetGadgetFont(#BUTTON_PL_TITLE, *info\font[#FONT_TITLE]\nFont)
  SetGadgetFont(#BUTTON_PL_LISTE, *info\font[#FONT_LIST]\nFont)
  
  SetGadgetFont(#BUTTON_SK_TITLE, *info\font[#FONT_TITLE]\nFont)
  SetGadgetFont(#BUTTON_SK_LISTE, *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SK_OK,    *info\font[#FONT_LIST]\nFont)
  
  SetGadgetFont(#BUTTON_CF_TITLE,     *info\font[#FONT_TITLE]\nFont)
  SetGadgetFont(#BUTTON_CF_FLD_LBL,   *info\font[#FONT_sTITLE]\nFont)
  SetGadgetFont(#BUTTON_CF_FLD_LIST,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_EXT_LBL,   *info\font[#FONT_sTITLE]\nFont)
  SetGadgetFont(#BUTTON_CF_EXT_LIST,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_LNG_LBL,   *info\font[#FONT_sTITLE]\nFont)
  SetGadgetFont(#BUTTON_CF_LNG_LIST,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_SRC_LBL,   *info\font[#FONT_sTITLE]\nFont)
  SetGadgetFont(#BUTTON_CF_SRC_LBL1,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_SRC_LBL2,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_SRC_TEXT,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_EXT_NEW,   *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_EXT_DEL,   *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_FLD_NEW,   *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_CF_FLD_DEL,   *info\font[#FONT_LIST]\nFont)


  
  SetGadgetFont(#BUTTON_SRC_TITLE,    *info\font[#FONT_TITLE]\nFont)
  SetGadgetFont(#BUTTON_SRC_NOM_LBL,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_NOM_TEXT, *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_NOM_BT,   *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_CHK_SONG, *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_CHK_ART,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_CHK_ALB,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_RESULT,   *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_PROGRESS, *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_ADD_PL,   *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_ADD_ALL,  *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_LIST,     *info\font[#FONT_LIST]\nFont)
  SetGadgetFont(#BUTTON_SRC_BT_SRC,   *info\font[#FONT_LIST]\nFont)
  
EndProcedure




; Retourne #True si le changement/chargement a bien marché
Procedure ChoiceSkin(*info.ALP_ALL)
  Protected head$, msg$, font.l, i.b
  
  Select SkinHasError(*info\Skin\name)
  
    ;{
    Case #PB_SKIN_NOTEXIST
      head$ = GetPrefString("TITLE", "ERR_SKIN")
      msg$ = GetPrefString("ERROR", "ERR_SKIN_NOTEXIST")
      Alert(head$, msg$, #False)
    ;}
    
    ;{
    Case #PB_SKIN_IMG
      head$ = GetPrefString("TITLE", "ERR_SKIN")
      msg$ = GetPrefString("ERROR", "ERR_SKIN_IMG")
      Alert(head$, msg$, #False)
    ;}
    
    ;{
    Case #PB_SKIN_PREF
      head$ = GetPrefString("TITLE", "ERR_SKIN")
      msg$ = GetPrefString("ERROR", "ERR_SKIN_PREF")
      Alert(head$, msg$, #False)
    ;}
    
    
    ;{
    Case #PB_SKIN_DATA
      head$ = GetPrefString("TITLE", "ERR_SKIN")
      msg$ = GetPrefString("ERROR", "ERR_SKIN_DATA")
      Alert(head$, msg$, #False)
    ;}
    
    
    ;{
    Default
      For i = #WIN_MAIN To #Win_CONF
        HideWindow(i, #True)
      Next i
      
      MakeListes()
      LoadImages( ALP_Dossier$(#FOLDER_SKIN) + *info\Skin\name + #SKIN_IMG$ )
      LoadSkinInfo(*info)
      
      ; MainWindow
      MakeWindow(#WIN_MAIN, *info\WinMain, "")
        MakePopupMenu()
        
      ; PlayListeWindow
      MakeWindow(#WIN_PL, *info\WinPL, GetPrefString("WINDOW", "WIN_PL"))
        DragAcceptFiles_(WindowID(), #IMG_WIN_PL)
      
      ; SkinManager
      MakeWindow(#WIN_SKIN, *info\WinSkin, GetPrefString("WINDOW", "WIN_SKIN"))
      
      ; dDataWindow
      MakeWindow(#WIN_SEARCH, *info\WinSearch, GetPrefString("WINDOW", "WIN_SEARCH"))
      
      ; WinConfig
      MakeWindow(#Win_CONF, *info\WinConfig, GetPrefString("WINDOW", "WIN_CONF"))

      
      MakeButtons()
      SetFont(*info)
      UseWindow(#WIN_MAIN)
      HideWindow(#WIN_MAIN, #False)
     
     
     ; Coloration du ScrollAreaGadget
      UseImage(#IMG_WIN_CONF)
      If StartDrawing(ImageOutput())
        handle_fille=FindWindowEx_(GadgetID(#BUTTON_CF_SCROLL),0,"PureScrollAreaChild","")
        If hBrush
          DeleteObject_(hBrush)
        EndIf
        hBrush=CreateSolidBrush_( Point(GadgetX(#BUTTON_CF_SCROLL), GadgetY(#BUTTON_CF_SCROLL)) )
        SetClassLong_(handle_fille,#GCL_HBRBACKGROUND,hBrush)
        StopDrawing()
      EndIf
      
      ProcedureReturn #True
    ;}
    
  EndSelect
    
EndProcedure






Procedure ChangeLanguage(*info.ALP_ALL, lang$)

  lang$ = ALP_Dossier$(#FOLDER_LANG) + lang$ + #EXT_PREF$
  
  If FileSize(lang$) > 0

    ALP_Langue$ = lang$
    SetWindowTitle(#WIN_PL,     GetPrefString("WINDOW", "WIN_PL"))
    SetWindowTitle(#WIN_SKIN,   GetPrefString("WINDOW", "WIN_SKIN"))
    SetWindowTitle(#WIN_SEARCH, GetPrefString("WINDOW", "WIN_SEARCH"))
    SetWindowTitle(#WIN_CONF,   GetPrefString("WINDOW", "WIN_CONF"))
    
    SetBtTag()
    
    ProcedureReturn #True
  Else
    Debug "pb lang file : " + lang$
    ProcedureReturn #False
  EndIf

EndProcedure

; ExecutableFormat=
; EOF
