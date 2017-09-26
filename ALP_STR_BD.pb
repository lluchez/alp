


Structure Extension
  name.s    ; Nom, exemple : MP3, WMA, etc
  descrip.s ; Exemple : Windows Media Audio, Fichier MP3
EndStructure


Structure Chanson
  numChanson.l
  nomChanson.s
  cheminChanson.s
  cheminChanson2.s
  numArtiste.l
  numAlbum.l
EndStructure


Structure MainField
  table.s
  champ.s
  value.b
EndStructure



Structure ExplodedFile
  chemin1.s
  chemin2.s
  fichier.s
EndStructure


; ExecutableFormat=
; EOF
