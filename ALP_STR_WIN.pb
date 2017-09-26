

Structure SkinALP
  name.s
  autor.s
  date.s
  info.s[4]
EndStructure


Structure Bouton
  posX.l
  posY.l
  width.l
  height.l
EndStructure


Structure AnimBt Extends Bouton
  out.l   ; num ImgOut
  over.l  ; num ImgOver
EndStructure


Structure ALP_Bouton Extends AnimBt
  show.l  ; si >=0, est masqué et démasque 'show'
  hide.b  ; pour l'état au lancement (visible ou caché)
  type.b  ; pour savoir si c'est un bouton, un btImg, etc.
  name.s
  win.l   ; numéro de la fenetre
  param1.l
  param2.l
EndStructure


Structure Fenetre
  name.s
  posX.l
  posY.l
  propr.l      ; center, bordless, etc...
EndStructure


Structure Lecteur
  track.l
  etat.b
  temps.l
  alias.s
  MciReponse.s
  autoLaunch.b  ; #True => lance une chanson au chargement de la playList
  lecture.b     ; Normal, random, ...
  boucle.b      ; none, track, all
  tag.ID3TagV2Tag
  namePL.s      ; nom de la PL ('ALP_current.3mu' par défaut)
  volume.w      ; volume (0-1000)
  balance.w     ; (-1000,+1000)
  muet.b
EndStructure


Structure PlayL
  nom.s         ; nom complet de la chanson
  joue.b        ; ordre de lecture : de 1 à lg (0 => pas encore joué)
EndStructure


Structure Font
  police.s
  taille.b
  option.l
  couleur.l
  nFont.l
EndStructure


Structure Scan
  nDays.l
  lastScan.l
  threadID.l
  threadStatut.b
  total.l
  current.l
  font.l
EndStructure


Structure ALP_ALL
  WinMain.Fenetre
  WinPL.Fenetre
  WinSkin.Fenetre
  WinSearch.Fenetre
  WinConfig.Fenetre
  Skin.SkinALP
  font.Font[4]
  info.s[3]
  majBD.Scan
EndStructure


; ExecutableFormat=Windows
; EOF
