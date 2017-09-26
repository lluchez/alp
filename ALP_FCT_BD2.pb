
;- Types de donnees des rows

Enumeration 0
  #ODBC_UNKNOW
  #ODBC_NUMERIC
  #ODBC_STRING
  #ODBC_FLOAT
EndEnumeration


;- Types de donnees de la BD

Dim DatabaseType.s(4) 
  DatabaseType(#ODBC_UNKNOW)  = "Unknown" 
  DatabaseType(#ODBC_NUMERIC) = "Numeric" 
  DatabaseType(#ODBC_STRING)  = "String" 
  DatabaseType(#ODBC_FLOAT)   = "Float" 




;- Types de donnees
;  Puissances de 2

#TAG_ALBUM  = 1
#TAG_SINGER = 2
#TAG_SONG   = 4




;- Recupere un champs apres requete

Procedure FindIndiceField(champ$)
  Protected k.b
  
  For k=0 To DatabaseColumns()-1 
    If DatabaseColumnName(k) = champ$
      ProcedureReturn k
    EndIf
  Next k
  
  For k=0 To DatabaseColumns()-1 
    If UCase(DatabaseColumnName(k)) = UCase(champ$)
      ProcedureReturn k
    EndIf
  Next k
  
  Debug ">> Erreur 1 <<"
  Debug champ$
  head$ = GetPrefString("TITLE", "ERR_MSG")
  msg$ = GetPrefString("ERROR", "ERR_GENERAL")
  Alert(head$, msg$, #True) 
EndProcedure


Procedure.s GetStrField(champ$)
  Protected ind.b, s$
    ind = FindIndiceField(champ$)
    s$ = GetDatabaseString(ind)
    ReplaceString(s$, Chr(34), "'", #REPL_DIRECT)
    ProcedureReturn s$
EndProcedure


Procedure.l GetNumField(champ$)
  Protected ind.b
    ind = FindIndiceField(champ$)
    ProcedureReturn GetDatabaseLong(ind)
EndProcedure


Procedure.f GetFloatField(champ$)
  Protected ind.b
    ind = FindIndiceField(champ$)
    ProcedureReturn GetDatabaseFloat(ind)
EndProcedure


;- Nb Lignes
; !!!! Attention !!! Pointeur BD remis à zéro

Procedure.l BD_Count()
  Protected row.l
  
  row = 0
  

EndProcedure


;- Normalize

Procedure.s Normalize(s$)
  
  ReplaceString(s$, "'", Chr(34), #REPL_DIRECT)
  ProcedureReturn Trim(s$)

EndProcedure


Procedure.s ForUpdate(s$)

  s$ = Normalize(s$)
  ProcedureReturn(" '" + s$ + "' ")

EndProcedure


;- Max from table

Procedure.l GetNewLine(table$, champ$)
  
  If DatabaseQuery("SELECT MAX("+champ$+") as max FROM " + table$)
    If NextDatabaseRow()
      ProcedureReturn(GetNumField("max")+1)
    Else
      ProcedureReturn(1)
    EndIf
  Else
    Debug " -> Erreur dans la recherche du MAX"
    ProcedureReturn(0)
  EndIf

EndProcedure



;- Fct Add - Mod - Alter

Procedure.l FindOrCreateArtiste(art$)
  Protected max.l
    max = 0
    
  If Len(art$)<2
    ProcedureReturn(0)
  EndIf

  If DatabaseQuery("SELECT numArtiste FROM artiste WHERE nomArtiste = " + ForUpdate(art$))
    If NextDatabaseRow()
      ;Debug "  Artist trouvé"
      ProcedureReturn(GetNumField("numArtiste"))
    Else
      ;Debug "  New Artist"
      max = GetNewLine("artiste", "numArtiste")
      If max
        If DatabaseUpdate("INSERT INTO artiste VALUES(" + Str(max) + ", " + ForUpdate(art$) + ")")
          ProcedureReturn max
        Else
          Debug "  !!! Ajout d'artiste impossible"
        EndIf
      EndIf
    EndIf
  Else
    Debug "  !!! Impossible de rechercher l'artiste : " + art$
  EndIf

EndProcedure


Procedure.l FindOrCreateAlbum(alb$)
  Protected max.l
    max = 0

  If Len(alb$)<2
    ProcedureReturn(0)
  EndIf
  
  If DatabaseQuery("SELECT numAlbum FROM album WHERE nomAlbum = " + ForUpdate(alb$))
    If NextDatabaseRow()
      ; Debug "  Album trouvé"
      ProcedureReturn(GetNumField("numAlbum"))
    Else
      ; Debug "  New Album"
      max = GetNewLine("album", "numAlbum")
      If max
        If DatabaseUpdate("INSERT INTO album VALUES(" + Str(max) + ", " + ForUpdate(alb$) + ")")
          ProcedureReturn max
        Else
          Debug "  !!! Ajout d'album impossible"
        EndIf
      EndIf
    EndIf
  Else
    Debug "  !!! Impossible de rechercher l'album : " + alb$
  EndIf

EndProcedure


; Correction des donnees d une chanson

Procedure AlterSong(song$, *tag.ID3TagV2Tag, *info.Chanson)
  Protected art.l, alb.l
  
  art =   FindOrCreateArtiste(*tag\artist)
  alb =   FindOrCreateAlbum(  *tag\album )
  ;Debug *tag\artist + " - " + *tag\album
  ;Debug *tag\album
  If *info\numArtiste <> art Or *info\numAlbum <> alb
    If DatabaseUpdate("UPDATE chanson SET artiste="+Str(art)+", album="+Str(alb)+" WHERE numChanson="+Str(*info\numChanson))
      Debug "Champ MaJ : " + song$
    Else
      Debug "  !!! Erreur lors de la MaJ : " + song$
      ;Debug "UPDATE chanson SET artiste="+Str(art)+", album="+Str(alb)+", anneeChanson="+ ForUpdate(*tag\year)+" WHERE numChanson="+Str(*info\numChanson)
    EndIf
  Else
    ; Debug "  Pas de MaJ nécessaire"
  EndIf

EndProcedure



Procedure ExplodeFile(file$, *array.ExplodedFile)
  Protected path$, l.l
  
  path$ = GetPathPart(file$)
  l = Len(path$)
  *array\fichier = GetFilePart(file$)
  If l > 255
    *array\chemin1 = Left(path$, 255)
    *array\chemin2 = Right(path$, l - 255)
  Else
    *array\chemin1 = path$
    *array\chemin2 = ""
  EndIf
EndProcedure



; Ajout d une musique dans la BD

Procedure AddSongToBD(file$, *tag.ID3TagV2Tag)
  Protected row.Chanson, art.l, alb.l, year.l
  Protected array.ExplodedFile
  
  ExplodeFile(file$, array)
  ;If DatabaseQuery("SELECT * FROM chanson WHERE cheminChanson=" + ForUpdate(GetPathPart(file$)) + " AND nomChanson = " + ForUpdate(GetFilePart(file$)) )
  If DatabaseQuery("SELECT * FROM chanson WHERE cheminChanson=" + ForUpdate(array\chemin1) + " AND cheminChanson2=" + ForUpdate(array\chemin2) + " AND nomChanson = " + ForUpdate(array\fichier) )
    
    If NextDatabaseRow()
      ;Debug " > MAJ : " + GetFilePart(file$)
      row\numChanson      = GetNumField("numChanson")
      row\nomChanson      = GetStrField("nomChanson")
      row\cheminChanson   = GetStrField("cheminChanson")
      row\cheminChanson2  = GetStrField("cheminChanson2")
      row\numArtiste      = GetNumField("artiste")
      row\numAlbum        = GetNumField("album")
      AlterSong(file$, *tag, @row)
    Else
      ;Debug " > New Song : " + GetFilePart(file$)
      art = FindOrCreateArtiste(*tag\artist)
      ;Debug Str(art) + " : " + *tag\artist
      alb = FindOrCreateAlbum(  *tag\album )
      year= Val(*tag\year)
      ;query$ = "INSERT INTO chanson VALUES("+Str(GetNewLine("chanson", "numChanson"))+", "+ForUpdate(GetFilePart(file$))
      ;query$ = query$ + ", "+ForUpdate(GetPathPart(file$))+", "+Str(art)+", "+Str(alb)+")"
      
      query$ = "INSERT INTO chanson VALUES("+Str(GetNewLine("chanson", "numChanson"))+", "+ForUpdate(array\fichier)
      query$ = query$ +", "+ ForUpdate(array\chemin1) +", "+ ForUpdate(array\chemin2) +", "+ Str(art) +", "+ Str(alb)+")"
      
      ; Debug query$
      DatabaseUpdate(query$)
    EndIf

  Else
    Debug "Impossible d'ajouter la chanson : " + file$
  EndIf

EndProcedure



;- Complete Tag

Procedure AddToTag(*tag.ID3TagV2Tag, key.b, value$, force.b)
  ; Force : si 1, on force le changement de valeur,
          ; sinon, on ne modifie que si le champ est vide
  
  Select key
    Case #TAG_ALBUM
      If force Or *tag\album = ""
        *tag\album = value$
      EndIf
      
    Case #TAG_SINGER
      If force Or *tag\artist = ""
        *tag\artist = value$
      EndIf
      
    Case #TAG_SONG
      If force Or *tag\title = ""
        *tag\title = value$
      EndIf
      
  EndSelect
  
EndProcedure



Procedure CompleteTagWithFileName(*tag.ID3TagV2Tag, file$)
  Protected i.w, Done.b, nb.b, nb2.b
  
  If *tag\title <> "" And *tag\artist <> ""
    ProcedureReturn
  EndIf
  
  file$ = EnleveExtension(file$)
  ReplaceString(file$, "_", " ")
    
  ; On stoque dans une LL tous les éléments du nom du fichier
  NewList Part.s()
  For i = 1 To CountString(file$, "-")+1
    AddElement(Part())
    Part() = Trim(StringField(file$, i, "-"))
  Next i

  ; On recherche les éléments évidants depuis la BD
  ResetList(Part())
Label1:
  While NextElement(Part())
  
    Done = #False
    If Val(Part()) > 0 And Val(Part()) < 50
      DeleteElement(Part())
      Goto Label1
    EndIf

    If hasBD
      For i = 0 To ALP_NumField-1
        If Done = #False
          If isDebug
            Debug req$
          EndIf
          If DatabaseQuery(req$)
            If NextDatabaseRow()
                AddToTag(*tag, ALP_Field(i)\value, GetStrField(ALP_Field(i)\champ), #False)
                DeleteElement(Part())
                Break
              EndIf
          Else
            If isDebug
              Debug #ERR_PREF$
            EndIf
          EndIf
        EndIf
      Next i
    EndIf
  
  Wend
  
  
  nb = CountList(Part())
  If nb

  
    ResetList(Part())
    While NextElement(Part())
      If FindString(Part(), "encode",1) Or FindString(Part(), "share",1)
        DeleteElement(Part())
        nb - 1
      EndIf
    Wend 
    ResetList(Part())
    
  EndIf     

  If nb And *tag\artist = ""
    If nb > 1 Or *tag\title <> ""
      FirstElement(Part())
      *tag\artist = Part()
      DeleteElement(Part())
      nb - 1
    EndIf
  EndIf
  

  If nb And *tag\title = ""
    nb2 = nb
    If *tag\artist <> "": nb2 + 1: EndIf
    If *tag\album  <> "": nb2 + 1: EndIf
    
    If nb2 = 1 Or *tag\artist <> ""
      FirstElement(Part())
    Else
      LastElement(Part())
    EndIf
    
    *tag\title = Part()
    DeleteElement(Part())
    nb - 1
  EndIf
  
EndProcedure

; ExecutableFormat=
; EOF
