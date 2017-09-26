

; Pr chanson précédente, courante, suivante
Enumeration -1
  #ALP_PREV
  #ALP_CUR
  #ALP_NEXT
  #ALP_NEXT_AUTO
EndEnumeration


; Etats des sons
Enumeration 0
  #MP3_ETAT_PLAY
  #MP3_ETAT_STOP
  #MP3_ETAT_PAUSE
EndEnumeration


; Etats de lecture
Enumeration 0
  #LECT_NORMAL
  #LECT_RANDOM
EndEnumeration


; Etats du repeat
Enumeration 0
  #REPEAT_NONE
  #REPEAT_TRACK
  #REPEAT_ALL
EndEnumeration

#ALIAS_TRACK = "morceau"


Declare ALP_Choice(choix.b)
Declare PauseMusic()


; Lance les cmd MCI
Procedure.l Mci(Cde.s)
  *Resultat.l = GlobalAlloc_(#GMEM_FIXED, 256)
  Retour.l = mciSendString_(Cde, *Resultat, 256, 0)
  Player\MciReponse = PeekS(*Resultat)
  GlobalFree_(*Resultat)
  ProcedureReturn Retour
EndProcedure



; Charge dans le 'Lecteur' le tag du fichier 'file$'
Procedure LoadTagFromFile(file$)

  ;GetMp3Infos(file$)
  ClearTagV1Data(m_tagV1Info)
  ClearTagV2Data(m_tagV2Info)
  ReadTagV1(file$)
  ReadTagV2(file$)
  ClearTagV2Data(Player\tag)
  MixTheTags(m_tagV1Info, m_tagV2Info, Player\tag)
  CompleteTagWithFileName(Player\tag, EnleveExtension(GetFilePart(file$)))

EndProcedure



Procedure AjusteVolume()
  Protected lVol.l, rVol.l

  If Player\track > -1
  
    If Player\muet
      lVol = 0
      rVol = 0
    Else
      lVol = Player\volume
      rVol = Player\volume
      If Player\balance < 0
        rVol + Player\balance
      Else
        lVol - Player\balance
      EndIf
    EndIf

    Mci("setaudio "+Player\alias+" right volume to " + Str(rVol))
    Mci("setaudio "+Player\alias+" left  volume to " + Str(lVol))
    
  EndIf

EndProcedure



; Changement de mode de lecture : Rnd => Norm
Procedure SetLectureRndToNormal()
  
  ; Debug ">>"
  ForEach playList()
    If ListIndex(playList()) <= Player\track
      playList()\joue = ListIndex(playList()) + 1
    Else
      playList()\joue = #False
    EndIf
    ; Debug playList()\joue
  Next
  
  Player\lecture = #LECT_NORMAL

EndProcedure




; Lancement de la chanson
Procedure LaunchMusic(num.l)
  Protected etatPL.l, posEx.l, posCur.l
  
  ; Debug num
  If num<=-1 Or num>=CountList(playList())
    ; Debug "Indice hors de la liste"
    ProcedureReturn #False
  EndIf

  ; Debug "Song : " + Str(num)

  ; Num ds la PL de la chanson qui vient d'être arrétée (prev/next)
  posEx = 0
  If Player\track <> - 1
    SelectElement(playList(),Player\track)
    posEx = playList()\joue
  EndIf

  ; Num ds la PL de la chanson qui va être jouée
  SelectElement(playList(),num)
  posCur = playList()\joue

  If posCur = #False
    posCur = posEx + 1
  EndIf


  If FileSize(playList()\nom) = -1
    Debug "Fichier inexistant"
    ProcedureReturn #False
  EndIf
  
  ;If Player\alias = ""
  ;  Player\alias = #ALIAS_TRACK
  ;EndIf
  
  StopMusic()
  If Mci("open "+Chr(34)+playList()\nom+Chr(34)+" alias "+Player\alias) = #False
    Mci("set "+Player\alias+" time format ms")
    Mci("status "+Player\alias+" length")
    Player\temps = Val(Player\MciReponse)
    
    Mci("seek "+Player\alias+" to start")
    ;Delay(200)
    If Mci("play "+Player\alias+" from 2001 notify") = #False
      AjusteVolume()
      ;Delay(200)
      Player\track = num
      Player\etat  = #MP3_ETAT_PLAY
      playList()\joue = posCur
      ;Delay(200)
      ;PauseMusic()
      ;  MessageRequester("", "ok", 0)
      ;PauseMusic()
      ; Chargement du tag
        LoadTagFromFile(playList()\nom)
      ;Delay(200)
      ;Delay(20)
      ;PauseMusic()
      ;Delay(20)
  ;MessageRequester("", "ok", 0)
      ;Mci("play "+Player\alias+" from 1")
      ProcedureReturn #True
    EndIf
  EndIf
  
  Debug "Erreur de lecture"
  ProcedureReturn #False
    
EndProcedure





; Met la musique courrante en pause
Procedure PauseMusic()

  If Player\track < 0
    ; Debug "No Song"
    ProcedureReturn #False
  EndIf
  
  If Player\etat = #MP3_ETAT_PAUSE
    Mci("status "+Player\alias+" position")
    Mci("play "+Player\alias+" from " + Player\MciReponse)
    Player\etat = #MP3_ETAT_PLAY
  ElseIf etatSound = #MP3_ETAT_PLAY
    Mci("pause "+Player\alias+" wait")
    Player\etat = #MP3_ETAT_PAUSE
  EndIf

EndProcedure





; Arrete la musique courante
Procedure StopMusic()

  If Player\track < 0
    ; Debug "No Song"
    ProcedureReturn #False
  EndIf
  
  If Player\etat = #MP3_ETAT_PAUSE Or Player\etat = #MP3_ETAT_PLAY
    If Mci("close "+ Player\alias) = #False
      Player\etat = #MP3_ETAT_STOP
      Player\temps = 0
      ClearTagV2Data(Player\tag)
      ProcedureReturn #True
    EndIf
  EndIf
  
  ProcedureReturn #False
  
EndProcedure





; Donne le temps courant de la chanson
Procedure.l GetSongElapsedTime()

  If Player\track < 0
    ; Debug "No Song"
    ProcedureReturn 0
  EndIf
  
  If Mci("status "+ Player\alias +" position") = #False
    ProcedureReturn Val(Player\MciReponse)
  EndIf
  
  ProcedureReturn 0

EndProcedure





; Renvoi le num de la prochaine chanson à lire. -1 si fin
Procedure ChoiceNextSong(clic.b)
  Protected num.l, plSize.l
  
  plSize = GetNbTrackInPlayList()
  
  ; la PL est vide
  If plSize = #False
    ProcedureReturn -1
  EndIf
  
  ; On regarde si l'indice n'est pas déjà défini
  If clic Or Player\boucle <> #REPEAT_TRACK
    If Player\track >= 0
      SelectElement(playList(), Player\track)
      num = playList()\joue
      ForEach playList()
        If playList()\joue = num + 1
          ; Debug "Already been !"
          ProcedureReturn ListIndex(playList())
        EndIf
      Next
    EndIf
  EndIf
  
  ; Repeat One
  If Player\boucle = #REPEAT_TRACK
    If Player\track >= 0 And clic = #False
      ProcedureReturn Player\track 
    Else
      If Player\lecture = #LECT_NORMAL
        If Player\track + 1 >= plSize
          ProcedureReturn 0
        Else
          ProcedureReturn Player\track + 1
        EndIf
      Else
        Repeat
          num = Random(plSize-1)
          If num <> Player\track Or plSize=1
            ProcedureReturn num
          EndIf
        ForEver
      EndIf
    EndIf
  EndIf
  
  Select Player\lecture
    
    ;{ Lecture en mode NORMAL
    Case #LECT_NORMAL
      num = Player\track + 1
      If num >= plSize
        ForEach playList()
          playList()\joue = #False
        Next
        Select Player\boucle
          Case #REPEAT_NONE
            If clic
              ProcedureReturn 0
            Else
              ProcedureReturn -1
            EndIf
          Default
            ProcedureReturn 0
        EndSelect
      EndIf
      ProcedureReturn num
    ;}
    
    ;{ Lecture en mode ALEATOIRE
    Case #LECT_RANDOM
      If GetPosOfPL() = plSize
        ForEach playList()
          playList()\joue = #False
        Next
        If Player\boucle = #REPEAT_NONE
          If clic = #False
            ProcedureReturn -1
          EndIf
        EndIf
      EndIf
      
      Repeat
        num = Random(plSize-1)
        SelectElement(playList(), num)
        If (playList()\joue = #False And Player\track <> num) Or plSize = 1
          ProcedureReturn num
        EndIf
      ForEver
    ;}
  
  EndSelect

EndProcedure



; Appuie sur le bouton 'Play'
Procedure PlayMusic()

  Select Player\etat
  
    ;{ MP3 déjà en lecture
    Case #MP3_ETAT_PLAY
      ProcedureReturn(#True)
    ;}
    
    ;{ MP3 en Pause
    Case #MP3_ETAT_PAUSE
      PauseMusic()
      ProcedureReturn(#True)
    ;}
    
    ;{ MP3 arrété
    Case #MP3_ETAT_STOP
      ProcedureReturn LaunchMusic(ALP_Choice(#ALP_CUR))
    ;}

  EndSelect


EndProcedure



; Renvoi le MP3 courant à lire
Procedure ChoiceCurrentSong()

  If GetNbTrackInPlayList() = #False
    ProcedureReturn -1
  EndIf

  If Player\track >=0
    ProcedureReturn Player\track
  ElseIf Player\lecture = #LECT_NORMAL
    ProcedureReturn 0
  Else
    ProcedureReturn Random(GetNbTrackInPlayList()-1)
  EndIf

EndProcedure



; Renvoi le MP3 précédent à lire
Procedure ChoicePreviousSong()
  Protected pl.l, num.l
  pl = GetNbTrackInPlayList()

  If pl = #False Or Player\track = -1
    ProcedureReturn -1
  EndIf

  SelectElement(playList(),Player\track)
  
  ;Si on est au son 1
  If playList()\joue = 1
  
    If pl = 1 Or Player\boucle <> #REPEAT_ALL
      ProcedureReturn -1
    Else
      If Player\lecture = #LECT_NORMAL
        ProcedureReturn pl-1
      Else
        Repeat
          num = Random(pl-1)
          If num <> Player\track
            ProcedureReturn num
          EndIf
        ForEver
      EndIf
    EndIf

  Else
  
    num = playList()\joue
    ForEach playList()
      If playList()\joue = num-1
        ProcedureReturn ListIndex(playList())
      EndIf
    Next

  EndIf
  
  Debug "Bug : Rien TROUVE !!!"
  ProcedureReturn -1

EndProcedure



; Action automatique => arrete le MP3 si nécessaire
;                       renvoi le numéro du MP3 à jouer
Procedure ALP_Choice(choix.b)
  Protected num.l

  Select choix
  
    Case #ALP_PREV
      num = ChoicePreviousSong()
    
    Case #ALP_CUR
      num = ChoiceCurrentSong()
    
    Case #ALP_NEXT_AUTO
      num = ChoiceNextSong(#False)
    
    Case #ALP_NEXT
      If Player\etat = #MP3_ETAT_PLAY
        num = ChoiceNextSong(#True)
      Else
        num = ChoiceNextSong(#False)
      EndIf
    
    Default
      Debug "Error"
      ProcedureReturn -1
  
  EndSelect
  
  If num >= 0
    Player\temps = 0
    StopMusic()
  EndIf
  
  ProcedureReturn num
  
EndProcedure



; Donne un nouveau numéro à un item de la PL
Procedure ChangeMusic(num.l)
  Protected num2.l

  If num >= 0
  
    SelectElement(playList(), num)
    ; Si le son n'a pas encore été joué
    If playList()\joue = 0
    
      ; Si un son était déjà sélectionné (son courant)
      If Player\track>=0
        SelectElement(playList(), Player\track)
          num2 = playList()\joue
        SelectElement(playList(), num)
          playList()\joue = num2 + 1
      Else
        playList()\joue = 1
      EndIf
    
    EndIf
    Player\track = num
  
  EndIf

EndProcedure




Procedure SelectMusicByPL(num.l)
  Protected num2.l

  If num<0 Or num >= CountList(playList())
    ProcedureReturn #False
  EndIf

  ; on récupère le # de la chanson courante
  If Player\track >= 0
    SelectElement(playList(), Player\track)
    num2 = playList()\joue
  Else
    num2 = #False
  EndIf


  If Player\lecture = #LECT_NORMAL
    ForEach playList()
      If ListIndex(playList()) < num
        playList()\joue = ListIndex(playList()) + 1
      Else
        playList()\joue = #False
      EndIf
    Next
    Player\track = num-1
    If Player\track = -1
      Player\track = CountList(playList())-1
    EndIf
   
  ; Lecture aléatoire
  Else
    SelectElement(playList(), num)
    ; Si le son n'a pas encore été joué
    If playList()\joue 
      ForEach playList()
        playList()\joue = #False
      Next
    EndIf
  EndIf
  
  ; Player\track = -1
  StopMusic()
  LaunchMusic(num)
  
EndProcedure





Procedure SetMusicPosition(time.l)

  If Player\track < 0
    ProcedureReturn #false
  EndIf
  
  Mci("pause "+Player\alias+" wait")
  Mci("seek "+Player\alias+" To End wait")      ; Go to the end of Song
  Mci("status "+Player\alias+" position wait")
  
  ; Temps indiqué trop important
  If Val(Player\MciReponse) < time
    If Player\etat = #MP3_ETAT_PLAY
      Mci("play "+Player\alias+" from 0")
    EndIf
    ProcedureReturn #False
  EndIf
  
  If Player\etat <> #MP3_ETAT_PLAY
    Mci("pause "+Player\alias+" wait")
    Mci("seek "+Player\alias+" To "+Str(time)+" wait")
  Else
    Mci("play "+Player\alias+" from " + Str(time))
  EndIf
  
  ProcedureReturn #True

EndProcedure


; Chargement d'une playList
Procedure LoadPlayList(name$)
  Protected temps.l
  
  ;name$ = ALP_Dossier$(#FOLDER_PL) + name$
  If FileSize(name$)>0
    If Player\namePL <> ALP_Dossier$(#FOLDER_PL) + #DEF_PL$
      SavePlayList(Player\namePL)
    EndIf
    ClearList(PlayList())
    StopMusic()
    Player\track = -1
    
    name$ = LoadPlayListToLK(name$)
    If name$
      temps = Player\temps
      
      If Player\track > -1
        LaunchMusic(Player\track)
      Else
        PlayMusic()
      EndIf
      If Player\autoLaunch = #False
        PauseMusic()
      EndIf
      SetMusicPosition(temps)
      ; SetGadgetState(#BUTTON_TRACK_POS, GetSongElapsedTime()) !!!
      
      Player\namePL = name$
    Else
      PauseMusic()
    EndIf

  Else
    ;Debug "Fichier introuvable !"    
  EndIf
  
EndProcedure




; ExecutableFormat=Windows
; EOF
