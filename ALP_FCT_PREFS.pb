



;- Erreurs generales

#ERR_PREF$              = "-ERR "
#ERR_PREF_NOT_FOUND$    = "-ERR No language file  !"
#ERR_PREF_KEY_MISS$     = "-ERR Config File isn't complete !"
#ERR_DEF_TITLE$         = #SHORT_PROJECT_NAME$ + " - Erreur"
#ERR_S_DOWN$            = "Program is shutting down !"
#ERR_NO_PREF$           = "File '"+#MAIN_PREF$+"' is missing. "+#ERR_S_DOWN$
#ERR_LANG_FILE$         = "Correct language's file is missing."



; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/





;- Preferences

Procedure.s GetStrPrefKey(file$, group$, key$)
  Protected s$

  If OpenPreferences(file$)
    If PreferenceGroup(group$)
      s$ = ReadPreferenceString(key$, #ERR_PREF_KEY_MISS$)
      ClosePreferences()
      ProcedureReturn s$
    EndIf
    ClosePreferences()
  EndIf
  ProcedureReturn(#ERR_PREF_NOT_FOUND$)

EndProcedure


Procedure.s GetPrefString(group$, key$)
  Protected a$
  
  a$ = GetStrPrefKey(ALP_Langue$, group$, key$)
  If ( Left(a$, Len(#ERR_PREF$)) = #ERR_PREF$ )
    ProcedureReturn(ReplaceString(a$, #ERR_PREF$, ""))
  Else
    ProcedureReturn(a$)
  EndIf

EndProcedure


Procedure.s GetPrefStrFromFile(file$, group$, key$)
  Protected a$
  
  a$ = GetStrPrefKey(file$, group$, key$)
  If ( Left(a$, Len(#ERR_PREF$)) = #ERR_PREF$ )
    ProcedureReturn(#ERR_DEF_TITLE$)
  Else
    ProcedureReturn(a$)
  EndIf

EndProcedure


; IDE Options = PureBasic v4.00 - Beta 7 (Windows - x86)
; CursorPosition = 59
; FirstLine = 13
; Folding = -
; EnableThread
