
#Class_TrackBar = "msctls_trackbar32"


Procedure.s GetGadgetClass(hGadget.l)
  Protected Class.s
  Class = Space(255)
  GetClassName_(hGadget, @Class, 254)
  ProcedureReturn Class
EndProcedure


Procedure VerticalTrackBar(nBar.l)
  If IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    SetWindowLong_(GadgetID(nBar), #GWL_STYLE, GetWindowLong_(GadgetID(nBar), #GWL_STYLE) | 2)
  EndIf
EndProcedure


Procedure HorizontalTrackBar(nBar.l)
  If IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    SetWindowLong_(GadgetID(nBar), #GWL_STYLE, GetWindowLong_(GadgetID(nBar), #GWL_STYLE) & ~2)
  EndIf
EndProcedure


Procedure.l GetMinTB(nBar.l)
  If IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    ProcedureReturn SendMessage_(GadgetID(nBar), #TBM_GETRANGEMIN, 0, 0)
  EndIf
EndProcedure

Procedure.l GetMaxTB(nBar.l)
  If IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    ProcedureReturn SendMessage_(GadgetID(nBar), #TBM_GETRANGEMAX, 0, 0)
  EndIf
EndProcedure

Procedure SetMinTB(nBar.l, val.l)
  If IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    SendMessage_(GadgetID(nBar), #TBM_SETRANGEMIN, 0, val)
  EndIf
EndProcedure

Procedure SetMaxTB(nBar.l, val.l)
  If IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    SendMessage_(GadgetID(nBar), #TBM_SETRANGEMAX, 0, val)
  EndIf
EndProcedure


Procedure ReplaceTrackBarCursor(nBar.l, nWin.l)
  Protected curPos.Point, curWin.l, style.l

  curWin = WindowID() ; On enregistre la fenetre courante
  GetCursorPos_(curPos)
  
  If IsWindow(nWin) And IsGadget(nBar) And GetGadgetClass(GadgetID(nBar)) = #Class_TrackBar
    UseWindow(nWin)
    style = GetWindowLong_(GadgetID(nBar), #GWL_STYLE)
    If style & 2 ; ---- Verticale ----
      curPos\y = curPos\y - (WindowY() + GadgetY(nBar)+10)
      If GetWindowLong_(WindowID(), #GWL_STYLE) & #WS_POPUP <> #WS_POPUP
        curPos\y - 20; (pr la barre de titre)
      EndIf
      SetGadgetState(nBar, (GetMaxTB(nBar)-(curPos\y * (GetMaxTB(nBar)-GetMinTB(nBar))) / (GadgetHeight(nBar)-20))+GetMinTB(nBar) )
    Else ; --- Horizontale ---
      curPos\x = curPos\x - (WindowX() + GadgetX(nBar)+10)
      SetGadgetState(nBar, ((curPos\x * (GetMaxTB(nBar)-GetMinTB(nBar))) / (GadgetWidth(nBar)-20))+GetMinTB(nBar) )
    EndIf
    UseWindow(GetDlgCtrlID_(curWin)) ; On rend le focus à la fenetre
  Else
    Debug "gad/win not initialized or not a TrackBar"
  EndIf
EndProcedure


; ExecutableFormat=Windows
; Executable=F:\Documents and Settings\Lio\Bureau\TestTrackBar.exe
; EOF
