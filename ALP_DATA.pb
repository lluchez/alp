

DataSection

  Icones_16_16:
    IncludeBinary "ALP_small.ico"


  Images:
    Data.s "back", "playlist", "skin"
    Data.s "search", "conf"
    
    Data.s "view"
    
    Data.s "play_out",    "play_over"
    Data.s "pause_out",   "pause_over"
    Data.s "stop_out",    "stop_over"
    Data.s "open_out",    "open_over"
    Data.s "prev_out",    "prev_over"
    Data.s "next_out",    "next_over"
    Data.s "exit_out",    "exit_over"
    Data.s "reduc_out",   "reduc_over"
    Data.s "sys_out",     "sys_over"
    Data.s "exit2_out",   "exit2_over"
    
    Data.s "pl_out",      "pl_over"
    Data.s "skin_out",    "skin_over"
    Data.s "bd_out",      "bd_over"
    Data.s "conf_out",    "conf_over"
    
    Data.s "pl_n_out",    "pl_n_over"
    Data.s "pl_o_out",    "pl_o_over"
    Data.s "pl_s_out",    "pl_s_over"
    
    Data.s ""



  Boutons:
    Data.s "PLAY"
    Data.l #WIN_MAIN, #IMG_PLAY_OUT,    #IMG_PLAY_OVER, #BT_Image
    Data.s "PAUSE"
    Data.l -1, #IMG_PAUSE_OUT,   #IMG_PAUSE_OVER,       #BT_Image
    Data.s "STOP"
    Data.l -1, #IMG_STOP_OUT,    #IMG_STOP_OVER,        #BT_Image
    Data.s "OPEN"
    Data.l -1, #IMG_OPEN_OUT,    #IMG_OPEN_OVER,        #BT_Image
    Data.s "PREV"
    Data.l -1, #IMG_PREV_OUT,    #IMG_PREV_OVER,        #BT_Image
    Data.s "NEXT"
    Data.l -1, #IMG_NEXT_OUT,    #IMG_NEXT_OVER,        #BT_Image
    Data.s "EXIT"
    Data.l -1, #IMG_EXIT_OUT,    #IMG_EXIT_OVER,        #BT_Image
    Data.s "REDUC"
    Data.l -1, #IMG_REDUC_OUT,   #IMG_REDUC_OVER,       #BT_Image
    Data.s "SYSTRAY"
    Data.l -1, #IMG_SYSTRAY_OUT, #IMG_SYSTRAY_OVER,     #BT_Image
    Data.s "INFO_SONG1"
    Data.l -1, 0, 0, #BT_Label
    Data.s "INFO_SONG2"
    Data.l -1, 0, 0, #BT_Label
    Data.s "INFO_SONG3"
    Data.l -1, 0, 0, #BT_Label
    Data.s "TRACK_POS"
    Data.l -1, 0, 0, #BT_TrackBar
    Data.s "TRACK_VOL"
    Data.l -1, 0, 0, #BT_TrackBar
    Data.s "TRACK_BAL"
    Data.l -1, 0, 0, #BT_TrackBar
    
    Data.s "OPEN_PL"
    Data.l -1, #IMG_PL_OUT,      #IMG_PL_OVER,          #BT_Image
    Data.s "OPEN_SKIN"
    Data.l -1, #IMG_SKIN_OUT,    #IMG_SKIN_OVER,        #BT_Image
    Data.s "OPEN_BD"
    Data.l -1, #IMG_BD_OUT,      #IMG_BD_OVER,          #BT_Image
    Data.s "OPEN_CONF"
    Data.l -1, #IMG_CONF_OUT,    #IMG_CONF_OVER,        #BT_Image
    
    
    Data.s "PL_EXIT"
    Data.l #WIN_PL, #IMG_EXIT2_OUT,      #IMG_EXIT2_OVER, #BT_Image
    Data.s "PL_LIST"
    Data.l -1, 0, 0, #BT_ListView
    Data.s "PL_TITLE"
    Data.l -1, 0, 0, #BT_Label
    Data.s "PL_NEW"
    Data.l -1, #IMG_PL_NEW_OUT,   #IMG_PL_NEW_OVER,     #BT_Image
    Data.s "PL_OPEN"
    Data.l -1, #IMG_PL_OPEN_OUT,   #IMG_PL_OPEN_OVER,   #BT_Image
    Data.s "PL_SAVE"
    Data.l -1, #IMG_PL_SAVE_OUT,   #IMG_PL_SAVE_OVER,   #BT_Image
    
    
    Data.s "SK_EXIT"
    Data.l #WIN_SKIN, #IMG_EXIT2_OUT,      #IMG_EXIT2_OVER, #BT_Image
    Data.s "SK_TITLE"
    Data.l -1, 0, 0, #BT_Label
    Data.s "SK_LIST"
    Data.l -1, 0, 0, #BT_ListView
    Data.s "SK_VIEW"
    Data.l -1, #IMG_SKIN_VIEW,   #IMG_SKIN_VIEW, #BT_Image
    Data.s "SK_OK"
    Data.l -1, 0, 0, #BT_Button
    
    
    Data.s "CF_TITLE"
    Data.l #WIN_CONF, 0, 0, #BT_Label
    Data.s "CF_EXIT"
    Data.l -1, #IMG_EXIT2_OUT,      #IMG_EXIT2_OVER,  #BT_Image
    Data.s "CF_SCROLL"
    Data.l -1, 0, 0, #BT_Scroll
    Data.s "CF_FOLD_LBL"
    Data.l -1, 0, 0, #BT_Label
    Data.s "CF_FOLD_LIST"
    Data.l -1, 0, 0, #BT_ListView
    Data.s "CF_FOLD_NEW"
    Data.l -1, 0, 0, #BT_Button
    Data.s "CF_FOLD_DEL"
    Data.l -1, 0, 0, #BT_Button
    Data.s "CF_EXT_LBL"
    Data.l -1, 0, 0, #BT_Label
    Data.s "CF_EXT_LIST"
    Data.l -1, 0, 0, #BT_ListView
    Data.s "CF_EXT_NEW"
    Data.l -1, 0, 0, #BT_Button
    Data.s "CF_EXT_DEL"
    Data.l -1, 0, 0, #BT_Button
    Data.s "CF_LANG_LBL"
    Data.l -1, 0, 0, #BT_Label
    Data.s "CF_LANG_LIST"
    Data.l -1, 0, 0, #BT_ListView
    Data.s "CF_SRC_LBL"
    Data.l -1, 0, 0, #BT_Label
    Data.s "CF_SRC_LBL1"
    Data.l -1, 0, 0, #BT_Label
    Data.s "CF_SRC_LBL2"
    Data.l -1, 0, 0, #BT_Label
    Data.s "CF_SRC_TEXT"
    Data.l -1, 0, 0, #BT_String
    
    
    Data.s "SRC_EXIT"
    Data.l #WIN_SEARCH, #IMG_EXIT2_OUT,  #IMG_EXIT2_OVER, #BT_Image
    Data.s "SRC_TITLE"
    Data.l -1, 0, 0, #BT_Label
    Data.s "SRC_NOM_LBL"
    Data.l -1, 0, 0, #BT_Label
    Data.s "SRC_NOM_TEXT"
    Data.l -1, 0, 0, #BT_String
    Data.s "SRC_NOM_BT"
    Data.l -1, 0, 0, #BT_Button
    Data.s "SRC_CHK_SONG"
    Data.l -1, 0, 0, #BT_Check
    Data.s "SRC_CHK_ART"
    Data.l -1, 0, 0, #BT_Check
    Data.s "SRC_CHK_ALB"
    Data.l -1, 0, 0, #BT_Check
    Data.s "SRC_RESULT"
    Data.l -1, 0, 0, #BT_Label
    Data.s "SRC_LIST"
    Data.l -1, 0, 0, #BT_ListView
    Data.s "SRC_ADD_PL"
    Data.l -1, 0, 0, #BT_Button
    Data.s "SRC_ADD_ALL"
    Data.l -1, 0, 0, #BT_Button
    Data.s "SRC_BAR"
    Data.l -1, 0, 0, #BT_Progress
    Data.s "SRC_BT_SRC"
    Data.l -1, 0, 0, #BT_Button
    Data.s "SRC_PROGRESS"
    Data.l -1, 0, 0, #BT_Label
    Data.s ""



  TableAndField:
    Data.s "album", "nomAlbum"
    Data.b #TAG_ALBUM
    Data.s "artiste", "nomArtiste"
    Data.b #TAG_SINGER
    Data.s "chanson", "nomChanson"
    Data.b #TAG_SONG

  

  Genre: 
    Data.s "Blues" 
    Data.s "Classic Rock" 
    Data.s "Country" 
    Data.s "Dance" 
    Data.s "Disco" 
    Data.s "Funk" 
    Data.s "Grunge" 
    Data.s "Hip-Hop" 
    Data.s "Jazz" 
    Data.s "Metal" 
    Data.s "New Age" 
    Data.s "Oldies" 
    Data.s "Other" 
    Data.s "Pop" 
    Data.s "R&B" 
    Data.s "Rap" 
    Data.s "Reggae" 
    Data.s "Rock" 
    Data.s "Techno" 
    Data.s "Industrial" 
    Data.s "Alternative" 
    Data.s "Ska" 
    Data.s "Death Metal" 
    Data.s "Pranks" 
    Data.s "Soundtrack" 
    Data.s "Euro-Techno" 
    Data.s "Ambient" 
    Data.s "Trip-Hop" 
    Data.s "Vocal" 
    Data.s "Jazz Funk" 
    Data.s "Fusion" 
    Data.s "Trance" 
    Data.s "Classical" 
    Data.s "Instrumental" 
    Data.s "Acid" 
    Data.s "House" 
    Data.s "Game" 
    Data.s "Sound Clip" 
    Data.s "Gospel" 
    Data.s "Noise" 
    Data.s "AlternRock" 
    Data.s "Bass" 
    Data.s "Soul" 
    Data.s "Punk" 
    Data.s "Space" 
    Data.s "Meditative" 
    Data.s "Instrumental Pop" 
    Data.s "Instrumental Rock" 
    Data.s "Ethnic" 
    Data.s "Gothic" 
    Data.s "Darkwave" 
    Data.s "Techno -Industrial" 
    Data.s "Electronic" 
    Data.s "Pop-Folk" 
    Data.s "Eurodance" 
    Data.s "Dream" 
    Data.s "Southern Rock" 
    Data.s "Comedy" 
    Data.s "Cult" 
    Data.s "Gangsta" 
    Data.s "Top 40" 
    Data.s "Christian Rap" 
    Data.s "Pop/Funk" 
    Data.s "Jungle" 
    Data.s "Native American" 
    Data.s "Cabaret" 
    Data.s "New Wave" 
    Data.s "Psychadelic" 
    Data.s "Rave" 
    Data.s "Showtunes" 
    Data.s "TriGenreiler" 
    Data.s "Lo-Fi" 
    Data.s "Tribal" 
    Data.s "Acid Punk" 
    Data.s "Acid Jazz" 
    Data.s "Polka" 
    Data.s "Retro" 
    Data.s "MusiciGenrel" 
    Data.s "Rock & Roll" 
    Data.s "Hard Rock" 
    Data.s "Folk" 
    Data.s "Folk-Rock" 
    Data.s "National Folk" 
    Data.s "Swing" 
    Data.s "Fast Fusion" 
    Data.s "Bebob" 
    Data.s "Latin" 
    Data.s "Revival" 
    Data.s "Celtic" 
    Data.s "Bluegrass" 
    Data.s "Avantgarde" 
    Data.s "Gothic Rock" 
    Data.s "Progressive Rock" 
    Data.s "Psychedelic Rock" 
    Data.s "Symphonic Rock" 
    Data.s "Slow Rock" 
    Data.s "Big Band" 
    Data.s "Chorus" 
    Data.s "Easy Listening" 
    Data.s "Acoustic" 
    Data.s "Humour" 
    Data.s "Speech" 
    Data.s "Chanson" 
    Data.s "Opera" 
    Data.s "Chamber Music" 
    Data.s "Sonata" 
    Data.s "Symphony" 
    Data.s "Booty Bass" 
    Data.s "Primus" 
    Data.s "Porn Groove" 
    Data.s = "Satire" 
    Data.s = "Slow Jam" 
    Data.s "Club" 
    Data.s "Tango" 
    Data.s "Samba" 
    Data.s "Folklore" 
    Data.s "Ballad" 
    Data.s "Power Ballad" 
    Data.s "Rhythmic Soul" 
    Data.s "Freestyle" 
    Data.s "Duet" 
    Data.s "Punk Rock" 
    Data.s "Drum Solo" 
    Data.s "A Capella" 
    Data.s "Euro-House" 
    Data.s "Dance Hall" 
    Data.s "Goa" 
    Data.s "Drum & Bass" 
    Data.s "Club-House" 
    Data.s "Hardcore" 
    Data.s "Terror" 
    Data.s "Indie" 
    Data.s "BritPop" 
    Data.s "Negerpunk" 
    Data.s "Polsk Punk" 
    Data.s "Beat" 
    Data.s "Christian Gangsta Rap" 
    Data.s "Heavy Metal" 
    Data.s "Black Metal" 
    Data.s "Crossover" 
    Data.s "Contemporary Christian" 
    Data.s "Christian Rock" 
    Data.s "Merengue" 
    Data.s "Salsa" 
    Data.s "Thrash Metal" 
    Data.s "Anime" 
    Data.s "JPop" 
    Data.s "Synthpop" 


EndDataSection


; ExecutableFormat=Windows
; EOF
