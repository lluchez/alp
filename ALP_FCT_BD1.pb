

#Database           = 1

#ODBC_ADD_DSN       = 1 ; Add Data source 
#ODBC_CONFIG_DSN    = 2 ; Configure (edit) Data source 
#ODBC_REMOVE_DSN    = 3 ; Remove Data source 
#ODBC_DRV_DESC$     = "Microsoft Access Driver (*.mdb)"
#ODBC_DNS$          = "PureBasic_DSN"
#ODBC_DLL_NAME$     = "ODBCCP32.DLL"
#ODBC_STR_CON1$     = "Server=SomeServer; Description=Description For Purebasic MDB-ODBC;DSN=PureBasic_DSN;DBQ="
#ODBC_STR_CON2$     = ";UID=Rings;PWD=Siggi;"




;- Preparation des DNS et des Drivers

Procedure IniConnection(strAttributes.s) 
  Protected lpszDriver.s, MyMemory.l, Lib.l

  Lib = OpenLibrary(#PB_Any,#ODBC_DLL_NAME$) 
  If Lib
    strAttributes = #ODBC_STR_CON1$ + strAttributes + #ODBC_STR_CON2$
    lpszDriver = #ODBC_DRV_DESC$
    MyMemory=AllocateMemory(Len(strAttributes)) 
    CopyMemory(@strAttributes,MyMemory,Len(strAttributes)) 
    For L=1 To Len(strAttributes ) 
      If PeekB(MyMemory +l-1)=Asc(";"):PokeB(MyMemory +l-1,0):  EndIf 
    Next L 
    
    If CallFunction(Lib, "SQLConfigDataSource", 0, #ODBC_ADD_DSN, lpszDriver.s, MyMemory ) 
      NewResult=SQLConfigDataSource_(0,#ODBC_ADD_DSN,lpszDriver.s,MyMemory )
      FreeMemory(MyMemory) 
      CloseLibrary(Lib)
      ProcedureReturn 1
    EndIf
  EndIf 
    ProcedureReturn 0
EndProcedure 


;- UnIni BD Connexion

Procedure UnIniConnection() 
  Result=OpenLibrary(1,#ODBC_DLL_NAME$) 
  If Result 
    lpszDriver.s=#ODBC_DRV_DESC$ 
    strAttributes.s = "DSN=" + #ODBC_DNS$ 
    Result = CallFunction(1, "SQLConfigDataSource", 0,#ODBC_REMOVE_DSN,lpszDriver.s,strAttributes ) 
    CloseLibrary(1) 
    If Result 
      ProcedureReturn #True 
    EndIf
    hasBD = #False
  EndIf 
EndProcedure 


;- Ini de la BD et création de la connexion

Procedure ALP_BD_Ini(quit.b)
  If InitDatabase() = 0 
    head$ = GetPrefString("TITLE", "ERR_MSG")
    msg$ = GetPrefString("ERROR", "ERR_ODBC_INI")
    hasBD = #False
    Alert(head$, msg$, quit)
    ProcedureReturn #False
  EndIf
  
  If IniConnection(#ALP_BD_NAME$)=0
    head$ = GetPrefString("TITLE", "ERR_MSG")
    msg$ = GetPrefString("ERROR", "ERR_ODBC_DRIVERS")
    hasBD = #False
    Alert(head$, msg$, quit)
    ProcedureReturn #False
  EndIf
  
  hasBD = #True
  ProcedureReturn #True
EndProcedure



;- Connexion a la BD

Procedure ALP_BD_Connect(quit.b, user$, pass$)
  If OpenDatabase(#Database, #ODBC_DNS$, user$, pass$)=0
    head$ = GetPrefString("TITLE", "ERR_MSG")
    msg$ = GetPrefString("ERROR", "ERR_BD_NOT_OPEN")
    Alert(head$, msg$, quit)
    hasBD = #False
    ProcedureReturn #False
  EndIf
  
  hasBD = #True
  ProcedureReturn #True
EndProcedure


Procedure ALP_BD_Close()
  CloseDatabase(#DataBase)
  hasBD = #False
EndProcedure


;MeinPointer.l 
;Procedure GetDBHandle() 
;  Shared MeinPointer.l 
;  !EXTRN _PB_DataBase_CurrentObject;_PB_DataBase_CurrentObject 
;  !MOV dword EAX,[_PB_DataBase_CurrentObject] 
;  !MOV dword [v_MeinPointer], EAX 
;  ProcedureReturn MeinPointer 
;EndProcedure 


; ExecutableFormat=Windows
; EOF
