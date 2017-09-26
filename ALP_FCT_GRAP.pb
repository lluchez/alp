

Procedure ReloadListDirALP()

  ClearList(ALP_LibFolder())
  ClearGadgetItemList(#BUTTON_CF_FLD_LIST)
  LoadLibraryFolder() ; Pas de scan complet
  
  ForEach ALP_LibFolder()
    AddGadgetItem(#BUTTON_CF_FLD_LIST, -1, ALP_LibFolder())
  Next

EndProcedure


Procedure ReloadListExtensionALP()

  ClearList(ALP_Format())
  ClearGadgetItemList(#BUTTON_CF_EXT_LIST)
  LoadExtensionSupported()
  
  ForEach ALP_Format()
    If ALP_Format()\descrip
      AddGadgetItem(#BUTTON_CF_EXT_LIST, -1, ALP_Format()\name + " (" + ALP_Format()\descrip + ")")
    Else
      AddGadgetItem(#BUTTON_CF_EXT_LIST, -1, ALP_Format()\name )
    EndIf
  Next

EndProcedure



Procedure.s GetExtensionPattern()
  Protected filtre$, all$, *ext.Extension, empty.Extension
  
  SortStructuredArray(ALP_Format(), 2, OffsetOf(Extension\descrip), #PB_Sort_String)
  empty\descrip = "ZZZ"
  *ext = empty
  all$ = GetPrefString("OTHER", "ALL_EXT")+"|"
  ForEach ALP_Format()
    all$ = all$ + "*."+LCase(ALP_Format()\name)+";"
    If *ext\descrip = ALP_Format()\descrip
      *ext\name + ";*." + ALP_Format()\name
      DeleteElement(ALP_Format())
    EndIf
    *ext = ALP_Format()
  Next
  
  
  SortList(ALP_Format(), 2)
  filtre$ = ""
  ForEach ALP_Format()
    filtre$ = filtre$ + "|" + ALP_Format()\descrip + " (*."+LCase(ALP_Format()\name)+")|*." + ALP_Format()\name
  Next
  SetMid(@all$, Len(all$), 0)
  
  LoadExtensionSupported()
  all$ + filtre$
  ProcedureReturn all$
EndProcedure 


; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

Procedure DeleteOneFolder()
  Protected folder$, taille.l, liste$

  If GetGadgetState(#BUTTON_CF_FLD_LIST) >=0
    If MessageRequester(GetPrefString("TITLE", "CONFIRM"), GetPrefString("LABEL", "DEL_FOLD"), #MB_OKCANCEL | #MB_ICONINFORMATION) = #True
      folder$ = LCase(GetGadgetText(#BUTTON_CF_FLD_LIST))
      taille = Len(folder$)
      liste$ = "0"
      
      If DatabaseQuery("SELECT numChanson, cheminChanson, cheminChanson2 FROM chanson")
      
        While NextDatabaseRow()
          file$ = GetStrField("cheminChanson") + GetStrField("cheminChanson2")
          
          If LCase(Mid(file$, 1, taille)) = folder$
            ;AddElement(Del()): Del() = file$
            liste$ = liste$ + ", " + Str(GetNumField("numChanson"))
          EndIf
        Wend
        
        ;ForEach Del()
        ;  ExplodeFile(Del(), array)
        ;  If DatabaseQuery("DELETE FROM chanson WHERE cheminChanson = " + ForUpdate(array\chemin1) + " cheminChanson2 = " + ForUpdate(array\chemin1) + " AND nomChanson = " + ForUpdate(array\fichier))
        ;    Debug "Suppr : " + Del()
        ;  Else
        ;    Debug "Impossible de supprimer : " + Del()
        ;  EndIf
        ;Next
        ;ClearList(Del())
        MessageRequester("", "DELETE FROM chanson WHERE numChanson IN(" + liste$ + ")", 0)
        DatabaseQuery("DELETE FROM chanson WHERE numChanson IN(" + liste$ + ")" )

      Else
        Debug "Impossible d'effectuer la requete."
      EndIf
          
      DatabaseQuery("DELETE FROM repertoire WHERE nomRepertoire = " + ForUpdate(folder$) )
      ReloadListDirALP()    
      
    EndIf
  EndIf

EndProcedure



Procedure DeleteOneExtension()

  If GetGadgetState(#BUTTON_CF_EXT_LIST) >=0
    If MessageRequester(GetPrefString("TITLE", "CONFIRM"), GetPrefString("LABEL", "DEL_EXT"), #MB_OKCANCEL | #MB_ICONINFORMATION) = #True
      DatabaseQuery("DELETE FROM extension WHERE nomExtension = " + ForUpdate(StringField(GetGadgetText(#BUTTON_CF_EXT_LIST),1," ")) )
      ReloadListExtensionALP()
    EndIf
  EndIf
              
EndProcedure


; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/


Procedure CompleteConfWin()

  ReloadListDirALP()
  ReloadListExtensionALP()
  
EndProcedure



Procedure SearchMusicFromLib()
  Protected text$, i.l, j.l, field$, req$, tmp$, tmp2$

  If GetGadgetState(#BUTTON_SRC_CHK_SONG) Or GetGadgetState(#BUTTON_SRC_CHK_ART) Or GetGadgetState(#BUTTON_SRC_CHK_ALB)
    text$ = Trim(GetGadgetText(#BUTTON_SRC_NOM_TEXT))
    
    ;If text$ <> ""
      While CountString(text$, "  ")
        text$ = ReplaceString(text$, "  ", " ")
      Wend
      req$ = "SELECT nomChanson, cheminChanson, cheminChanson2 FROM chanson, album, artiste WHERE numAlbum=album AND numArtiste=artiste"
      For i = 1 To CountString(text$, " ")+1
        field$ = StringField(text$, i, " ")
        req$ + " AND("
        For j = 0 To 2
          If GetGadgetState(#BUTTON_SRC_CHK_SONG+j)
            If Right(req$,1)<>"("
              req$ + " OR "
            EndIf
            req$ + "INSTR("+ALP_Field(2-j)\champ+","+ForUpdate(field$)+")"
          EndIf
        Next j
        req$ + ")"
      Next i

      If DatabaseQuery(req$ + " ORDER BY nomChanson")
        ClearList(ALP_FoundBySearch())
        ClearGadgetItemList(#BUTTON_SRC_LIST)
        While NextDatabaseRow()
          tmp$ = GetStrField("nomChanson")
          tmp2$ = GetStrField("cheminChanson") + GetStrField("cheminChanson2") + tmp$
          If FileSize(tmp2$) > 0
            AddGadgetItem(#BUTTON_SRC_LIST, -1, tmp$)
            AddElement(ALP_FoundBySearch()): ALP_FoundBySearch() = tmp2$
          EndIf
        Wend
      Else
        Debug ">> NON <<"
      EndIf
    ;EndIf
  Else
    Alert(GetPrefString("TITLE", "ERR_MSG"), GetPrefString("ERROR", "ERR_NOT_CHECKED"), #False)
  EndIf

EndProcedure





; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/




Procedure UpdateVolTrackBar()

  SetGadgetState(#BUTTON_TRACK_VOL, Player\volume)
  GadgetToolTip(#BUTTON_TRACK_VOL, ALP_Volume$ + Str(Player\volume / 10))
  AjusteVolume()

EndProcedure


Procedure UpdateBalTrackBar()

  SetGadgetState(#BUTTON_TRACK_BAL, Player\balance)
  GadgetToolTip(#BUTTON_TRACK_BAL, ALP_Balance$ + Str(Player\balance / 10))
  AjusteVolume()

EndProcedure

; ExecutableFormat=
; EOF
