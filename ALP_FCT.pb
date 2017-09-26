Declare.l DefWindowCallback(WindowID.l, Message.l, wParam.l, lParam.l)

; Resultat de NextDirectoryEntry()

Enumeration 0
  #DIR_EMPTY
  #DIR_IS_FILE
  #DIR_IS_DIR
EndEnumeration


; Pour la fct ReplaceString() : remplace directement dans la chaine

  #REPL_DIRECT = 2


; /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
; \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/


; MessageRequester
Procedure Alert(title$, msg$, fin.b)
  MessageRequester(title$, msg$, #MB_ICONERROR)
  If fin
    SetWindowCallback(@DefWindowCallback())
    End
  EndIf
EndProcedure


; Enleve l'extension d'un nom de fichier
Procedure.s EnleveExtension(file$)

  If Len(GetExtensionPart(file$))
    ProcedureReturn Left(file$, Len(file$)-(Len(GetExtensionPart(file$))+1))
  Else
    ProcedureReturn file$
  EndIf
  
EndProcedure





;- Scan Folders

Procedure NextDirectory()
  Protected FileType.b, FileName$

  FileType = NextDirectoryEntry()
  If FileType = #DIR_IS_DIR
    FileName$ = DirectoryEntryName()
    If FileName$ = "." Or FileName$ = ".."
      ProcedureReturn(NextDirectory())
    Else
      ProcedureReturn(#DIR_IS_DIR)
    EndIf
  Else
    ProcedureReturn(FileType)
  EndIf

EndProcedure




Procedure NormalizeFolder(adr.l)
  Protected a$
  
  a$ = PeekS(adr)
  ReplaceString(a$, "/", "\", #REPL_DIRECT)
  PathAddBackslash_(a$)

  PokeS(adr, a$)

EndProcedure




Procedure.s SetSecToStr(length.l)
  Protected Seconds.w, ch$

  If length < 1
    ProcedureReturn "0:00"
  EndIf
  length = length / 1000
  ch$ = Str(length / 60)+":"
  Seconds = length % 60
  If Seconds < 10  ; Then seconds will be written as 01, 02, or 03 instead of 1, 2, or 3
    ch$ = ch$ + "0"
  EndIf

  ProcedureReturn ch$ + Str(Seconds)
EndProcedure


;- Fonctions sur les strings

Procedure.b IsTextInUp(texte1$, pourc.l)
  Protected texte2$, nb.l, i.l, tmp.b, lg.l
  
  
  nb = 0
  texte2$ = LCase(texte1$)
  lg = 0
  For i = 0 To Len(texte1$)-1
    tmp = PeekB(@texte2$+i) ; tmp is in Lower
    ; on ignore les espaces, ponctuations caractères spéciaux...
    If Chr(tmp) <> UCase(Chr(tmp))
      lg + 1
      If tmp <> PeekB(@texte1$+i)
        nb + 1
      EndIf
    EndIf
  Next i

  If (nb*100.0 / lg) >= pourc
    ProcedureReturn #True
  EndIf

EndProcedure



Procedure SetMid(pCh.l, pos.l, car.b)
  If pos >= 1 Or pos<=Len(PeekS(pCh))
    PokeB(pCh + pos-1, car)
  EndIf
EndProcedure



Procedure.b GetMid(pCh.l, pos)
  If pos < 1 Or pos>Len(PeekS(pCh))
    ProcedureReturn #False
  EndIf
  ProcedureReturn PeekB(pCh+pos-1)
  
EndProcedure



Procedure.s RemoveMajIfTooMuch(s$, pourc.l)
  
  If Len(s$) > 4
    If IsTextInUp(s$, pourc.l)
      s$ = LCase(s$)
      PokeB( @s$, Asc(UCase(Chr(PeekB(@s$)))) )
      For i = 1 To Len(s$)-1
        If GetMid(@s$,i) = ' '
          SetMid( @s$, i+1, Asc(UCase(Chr(GetMid(@s$,i+1)))) )
        EndIf
      Next i
    EndIf
  EndIf
  ProcedureReturn s$

EndProcedure



Procedure RemoveCurrentGadgetItem(nGadget.l)

  If IsGadget(nGadget)
    ;If GetGadgetState(nGadget) > -1
      RemoveGadgetItem(nGadget, GetGadgetState(nGadget))
    ;EndIf
  EndIf

EndProcedure



Procedure.s CorrectMajExt(ext$)
  Protected i.l, car.b
  
  If Left(ext$,1) = "."
    ext$ = Right(ext$, Len(ext$)-1)
  EndIf
  
  ext$ = UCase(ext$)
  
  For i = 1 To Len(ext$)
    car = GetMid(@ext$, i)
    If (car < '0') Or (car > '9' And car < 'A') Or (car > 'Z')
      ProcedureReturn ""
    EndIf
  Next i

  ProcedureReturn ext$
EndProcedure



Procedure SetFirstLetterToMaj(adrStr.l)
  Protected car1.b, car2.b
  
  PokeB( adrStr, Asc(UCase(Chr(PeekB(adrStr)))) )
  adrStr + 1
  While PeekB(adrStr) <> #Null
    If PeekB(adrStr) = ' ' Or PeekB(adrStr) = '('
      PokeB( adrStr+1, Asc(UCase(Chr(PeekB(adrStr+1)))) )
    EndIf
    adrStr + 1
  Wend

EndProcedure

; ExecutableFormat=
; EOF
