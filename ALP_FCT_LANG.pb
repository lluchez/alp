Declare SetBtTag()

NewList InfoForLang.s()
  AddElement(InfoForLang()): InfoForLang() = "ERROR"
  AddElement(InfoForLang()): InfoForLang() = "TITLE"
  AddElement(InfoForLang()): InfoForLang() = "WINDOW"
  AddElement(InfoForLang()): InfoForLang() = "LABEL"
  AddElement(InfoForLang()): InfoForLang() = "BOUTON"
  AddElement(InfoForLang()): InfoForLang() = "INFO_BULLE"
  AddElement(InfoForLang()): InfoForLang() = "OTHER"
  AddElement(InfoForLang()): InfoForLang() = "POP_UP"



Procedure IsGoodLangFile(file.s)

  If FileSize(file) > 0
    OpenPreferences(file)
    ForEach InfoForLang()
      If PreferenceGroup(InfoForLang()) = #False
        ProcedureReturn #False
      EndIf
    Next
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf

EndProcedure


Procedure.s GetFileLanguage(lang$, def$)

  If IsGoodLangFile(ALP_Dossier$(#FOLDER_LANG) + lang$ + #EXT_PREF$)
    ProcedureReturn ALP_Dossier$(#FOLDER_LANG) + lang$ + #EXT_PREF$
  ElseIf IsGoodLangFile(ALP_Dossier$(#FOLDER_LANG) + def$ + #EXT_PREF$)
    ProcedureReturn ALP_Dossier$(#FOLDER_LANG) + def$ + #EXT_PREF$
  Else
    Alert(#ERR_DEF_TITLE$, #ERR_LANG_FILE$ + " " + #ERR_S_DOWN$, #True)
  EndIf

EndProcedure



Procedure FindFileLanguage()
  Protected numRep.l, i.w, FileType.b, FileName$

  ClearList(ALP_LangFile())
  If ExamineDirectory(#PB_ANY, ALP_Dossier$(#FOLDER_LANG), "*" + #EXT_PREF$)
  
    Repeat
      FileType = NextDirectory()
      If FileType = #DIR_IS_FILE
        FileName$ = DirectoryEntryName()
        If IsGoodLangFile(ALP_Dossier$(#FOLDER_LANG) + FileName$)
          If FileName$ <> #DEF_LANG$ + #EXT_PREF$
            AddElement(ALP_LangFile())
              ALP_LangFile() = FileName$
          EndIf
        EndIf
      EndIf
    Until FileType = 0

    SortList(ALP_LangFile(), 2)
  Else
    Debug "Impossible d'analyser " + ALP_Dossier$(#FOLDER_LANG)
  EndIf

EndProcedure


; Renvoi #True si fichier ok
Procedure ChangeLang(file$)

  If IsGoodLangFile(ALP_Dossier$(#FOLDER_LANG) + file$)
    ALP_Langue$ = ALP_Dossier$(#FOLDER_LANG) + file$
    SetBtTag()
    ProcedureReturn #True
  EndIf

EndProcedure

; ExecutableFormat=
; EOF
