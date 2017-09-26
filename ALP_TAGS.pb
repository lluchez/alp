; Author : KarLKoX
; Mail   : KarLKoX@ifrance.com (for bugs/suggestions)
; Infos  : Read/Write Tags 1.x/2.x
;          Get mp3 infos from header (vbr supported)
; Version:
;  1.0 : (29/09/03)
;      - Initial Release




Structure ID3TagV1Tag
     tag.s
     title.s
     artist.s
     album.s
     year.s
     comments.s
     genre.s
     track.s
EndStructure
     
Structure ID3TagV2Tag
     title.s
     artist.s
     album.s
     year.s
     genre.s
     comments.s
     composer.s
     orig_artist.s
     copyright.s
     url.s
     encoded_by.s
     track.s
EndStructure
         
Structure ID3TagV23Header
     tag.b[3]                      ; 3 car ----
     version.b                     ; 1 car      \
     revision.b                    ; 1 car        10 bytes = One Frame Header
     flag.b                        ; 1 car      /
     size.b[4]                     ; 4 car ____/
EndStructure     

Structure ID3TagV2Flags
     desynchronisation.b
     compression.b
     experimentation.b
     unknown.b
EndStructure
     
Structure ID3TagV23Frame
     identifiant.b[4]
     size.b[4]
     flag.w
     datas.s
EndStructure

Structure MP3INFO
     fileSize.s
     headerPosition.s
     mpegVersion.s
     layerVersion.s
     protectionBit.s
     bitrate.s
     vbr.s
     samplerate.s
     padding.s
     privateBit.s
     channelMode.s
     modeExtension.s               ; not used
     copyright.s
     original.s
     emphasis.s
     length.s
     numOfFrames.s
EndStructure

#MAX_FRAME_DEPENDENCY         = 10
#SKIP_FIRST_FRAMES            = 1

; mp3 frame structure
Structure frame
     stereo.l
     jsbound.l
     single.l
     mpegVersion.l
     lsf.l
     mpeg25.l
     lay.l
     error_protection.l
     bitrate_index.l
     sampling_frequency.l
     padding.l
     extension.l
     mode.l
     mode_ext.l
     copyright.l
     original.l
     emphasis.l
     framesize.l                   ; computed framesize, WITHOUT first header dword */
EndStructure

#FRAMES_FLAG                  = $0001
#BYTES_FLAG                   = $0002
#TOC_FLAG                     = $0004
#VBR_SCALE_FLAG               = $0008

#NUMTOCENTRIES                = 100
#FRAMES_AND_BYTES             = #FRAMES_FLAG | #BYTES_FLAG

Structure VBRTAGDATA
     h_id.l                             ; from MPEG header, 0=MPEG2, 1=MPEG1
     samprate.l                         ; determined from MPEG header
     flags.l                            ; from Vbr header data
     frames.l                           ; total bit stream frames from Vbr header data
     bytes.l                            ; total bit stream bytes from Vbr header data
     vbr_scale.l                        ; encoded vbr scale from Vbr header data
     toc.b[#NUMTOCENTRIES]              ; may be NULL if toc not desired
     headersize.l                       ; size of VBR header, in bytes 
     enc_delay.l                        ; encoder delay
     Enc_padding.l                      ; encoder paddign added at end of stream
     is_vbr.l
EndStructure


Dim TagsV2.s(12)

Dim m_freqs.s(9)
Dim m_mpeg1layer1.s(16)
Dim m_mpeg1layer2.s(16)
Dim m_mpeg1layer3.s(16)
; Mpeg 2 Layer 2 use the same tab than Mpeg 2 Layer 3
Dim m_mpeg2layer3.s(16)


Global m_tagV2Info.ID3TagV2Tag
Global m_tagV1Info.ID3TagV1Tag
Global m_mp3infos.MP3INFO
; list of frames
NewList frameArray.ID3TagV23Frame()



Declare   ProcessFlags(flags.b, *m_flags.ID3TagV2Flags)
Declare   ReadFrame(*m_frame.ID3TagV23Frame)
Declare   ReadFrames(*tag.ID3TagV23Header, *m_numberOfFrames.l)
Declare   ByteToLong(byteArray.l)
Declare.s ByteToString(*byteArray.b, m_length.l)
Declare.s CopyByteToString(*byteArray.b, m_firstPart.l, m_endPart.l)
Declare   searchMp3Header(m_startPosition.l)
Declare.s padString(theString.s, dummy.b)
Declare   id3v2_calc_size()
Declare.b HasTagV1(fichier.s)
Declare.b HasTagV2(fichier.s)
Declare   InitTagV2()

Declare WriteTagV2(fichier.s, bRemove.b, *TagV2ToWrite.ID3TagV2Tag)

Declare CompleteTagWithFileName(*tag.ID3TagV2Tag, file$)
Declare ClearTagV1Data(*tag.ID3TagV1Tag)
Declare ClearTagV2Data(*tag.ID3TagV2Tag)
Declare DebugTagV2(*tag.ID3TagV2Tag)
Declare DebugTagV1(*tag.ID3TagV1Tag)
Declare TagIsEmpty(*tag.ID3TagV2Tag)



InitTagV2()
  
; READ
#READ_INPUT_FILE_TAG          = 10
#READ_OUTPUT_FILE_TAG         = 11

; WRITE
#WRITE_INPUT_FILE_TAG         = 12
#WRITE_OUTPUT_FILE_TAG        = 13


;---- InitTagV2
; Purpose: initialise the array of ID to check
; Require: nothing
; Return : nothing
Procedure InitTagV2()
    
    TagsV2(0) = "TIT2"
    TagsV2(1) = "TPE1"
    TagsV2(2) = "TALB"
    TagsV2(3) = "TYER"
    TagsV2(4) = "TCON"
    TagsV2(5) = "COMM"
    TagsV2(6) = "TCOM"
    TagsV2(7) = "TOPE"
    TagsV2(8) = "TCOP"
    TagsV2(9) = "WXXX"
    TagsV2(10) = "TENC"
    TagsV2(11) = "TRCK"
    
EndProcedure


;---- HasTagV2
; Purpose: Check if a Tag V2.x exists
; Require: fichier ==> input file
; Return : #TRUE if the tag exists
;          #FALSE otherwise
Procedure.b HasTagV2(fichier.s)
  Protected m_tag.s
  Protected hOrgFile.l
    
     ;UseFile(#WRITE_INPUT_FILE_TAG)
     m_tag = Space(3)
     ReadData(@m_tag, 3)

     If UCase(m_tag) = "ID3"
         ProcedureReturn #True
     Else
         ProcedureReturn #False
     EndIf
    
EndProcedure


Procedure.l GetTailleTagV2(fichier.s)
  Protected m_taille.l
  Dim m_byte.b(3)

    FileSeek(6)    
    ReadData(@m_byte(), 3)

    m_taille = (m_byte(0) << 21) | (m_byte(1) << 14) | (m_byte(2) << 7) | m_byte(3)
    ;m_taille.l = 0
    ;For Byte.l = 3 To 0 Step -1
    ; m_taille + (ReadByte() << (7*Byte))
    ;Next 
    ; Add the size of the frame header    
    m_taille = m_taille + 10    
    
EndProcedure


;---- ReadTagV2
; Purpose: Read a IDTag V2.x (up to 2.3)
; Require: fichier ==> input file
; Return : fill the m_tagV2Infostructure if the tag exist
Procedure.b ReadTagV2(fichier.s)
  Protected m_tag.ID3TagV23Header
  Protected m_flags.ID3TagV2Flags
  Protected m_frames.l
  Protected m_fr.ID3TagV23Frame
  Protected m_compteur.l : m_numFrames.l
  Protected m_taille.l
  Protected hOrgFile.l
  Protected m_identifiant.s

     hOrgFile = ReadFile(#READ_INPUT_FILE_TAG, fichier)    
     UseFile(#READ_INPUT_FILE_TAG)
     If hOrgFile = 0 
          ;MessageRequester("Error", "An error occured while opening " + fichier, 0)
          ProcedureReturn #False
     EndIf
    
     ; InitTagV2()
     ReadData(@m_tag, SizeOf(ID3TagV23Header))
     
     ; the size is coded on 7 bits, needed to for not be confused with a synchsignal
     ;m_taille = (m_tag\size[0] << 21) | (m_tag\size[1] << 14) | (m_tag\size[2] << 7) | m_tag\size[3]
     m_taille.l = 0
     For Byte.l = 3 To 0 Step -1
       m_taille + (ReadByte() << (7*Byte))
     Next 
     
     ; revisions are compatible between them but
     ; version aren't, so we must check this     
     If m_tag\version <> 3
        ;MessageRequester("Error", "Tag version is different than 2.3", 0)
        CloseFile(#READ_INPUT_FILE_TAG)
        ProcedureReturn #False
     EndIf
    
     ProcessFlags(m_tag\flag, @m_flags)
    
     If m_flags\unknown
        ;MessageRequester("Error", "Unkown flag detected !", 0)
        CloseFile(#READ_INPUT_FILE_TAG)
        ProcedureReturn #False
     EndIf
    
     ReadFrames(m_tag, @m_numFrames)
    
     ; Reset the list index before the first element.    
     ;; ResetList(frameArray())               
     ;; For m_compteur = 0 To m_numFrames - 1
     While FirstElement(frameArray())

        ;; NextElement(frameArray())
        m_identifiant = Space(4)
        m_identifiant = Chr((frameArray()\identifiant[0])) + Chr((frameArray()\identifiant[1])) + Chr((frameArray()\identifiant[2]))  + Chr((frameArray()\identifiant[3])) 
        
        ;m_taille = (frameArray()\size[0] << 21) | (frameArray()\size[1] << 14) | (frameArray()\size[2] << 7) | frameArray()\size[3]
        
        a.b=ReadWord()
        c.b=ReadByte()
        d.b=ReadByte()
        m_taille = 256*c+d

        Select m_identifiant
            
            Case "TIT2"
                If (frameArray()\datas)
                        m_tagV2Info\title = frameArray()\datas
                EndIf
            
            Case "TPE1"
                If (frameArray()\datas)
                        m_tagV2Info\artist = frameArray()\datas
                EndIf
            
            Case "TALB"
                If (frameArray()\datas)
                        m_tagV2Info\album = frameArray()\datas
                EndIf
                
            Case "TYER"
                If (frameArray()\datas)
                        m_tagV2Info\year = frameArray()\datas
                EndIf
                
            Case "TCON"
                If (frameArray()\datas)
                        m_tagV2Info\genre = frameArray()\datas
                EndIf
                
            Case "COMM"
                If (frameArray()\datas)
                        m_tagV2Info\comments = frameArray()\datas
                EndIf
                
            Case "TCOM"
                If (frameArray()\datas)
                        m_tagV2Info\composer = frameArray()\datas
                EndIf
                
            Case "TCOP"
                If (frameArray()\datas)
                        m_tagV2Info\copyright = frameArray()\datas
                EndIf
                
            Case "WXXX"
                If (frameArray()\datas) 
                        m_tagV2Info\url = frameArray()\datas
                EndIf
                
            Case "TENC"
                If (frameArray()\datas) 
                        m_tagV2Info\encoded_by = frameArray()\datas
                EndIf
                
            Case "TRCK"
                If (frameArray()\datas)
                        m_tagV2Info\track = frameArray()\datas
                EndIf
                
            Case "TOPE"
                If (frameArray()\datas)
                        m_tagV2Info\orig_artist = frameArray()\datas
                EndIf
                
        EndSelect
        
        DeleteElement(frameArray())

    Wend
    
    CloseFile(#READ_INPUT_FILE_TAG)

    ProcedureReturn #True

EndProcedure


;---- ProcessFlags
; Purpose: test the flag 
; Require: flag ==> the flag to test
;          a pointer To a ID3TagV23Header Structure
; Return : nothing but fill the pointer with the correct flag
Procedure ProcessFlags(flags.b, *m_flags.ID3TagV2Flags)

    If (flags & $80) = $80
        *m_flags\desynchronisation = #True
    Else
        *m_flags\desynchronisation = #False
    EndIf
    
    If (flags & $40) = $40
        *m_flags\desynchronisation = #True
    Else
        *m_flags\desynchronisation = #False
    EndIf

    If (flags & $20) = $20
        *m_flags\desynchronisation = #True
    Else
        *m_flags\desynchronisation = #False
    EndIf

    If (flags & $1F) > 0
        *m_flags\unknown           = #True
    Else
        *m_flags\unknown           = #False
    EndIf

EndProcedure

;---- ReadFrames
; Purpose: Read all frame
; Require: a pointer to a ID3TagV23Header structure
; Return : the number of frames read
Procedure.l ReadFrames(*tag.ID3TagV23Header, *m_numberOfFrames.l)
  Protected m_frames.l ;ID3TagV23Frame
  Protected m_taille.l
  Protected m_taille2.l
  Protected m_index.l
  Protected m_identifiant.s

    ; 1 based
    m_index = 1
    
    m_taille = 0
    m_taille2 = ByteToLong(@*tag\size)

    While m_taille < m_taille2

        ; read ONE frame
        ReadFrame(@frame.ID3TagV23Frame)
        
        m_taille3 = (frame\size[0] << 21) | (frame\size[1] << 14) | (frame\size[2] << 7) | frame\size[3]  

        ; i found some weird mp3 with a frameSize = 0, so check this
        If m_taille3 = 0 
          m_taille = m_taille2
        EndIf
        
        ; check the IDentifier
        m_identifiant.s = Space(4)
        m_identifiant = Chr(frame\identifiant[0]) + Chr(frame\identifiant[1]) + Chr(frame\identifiant[2]) + Chr(frame\identifiant[3])

        If m_identifiant <> "NULL"
            ; ok, it seems to be a valid frame, make a copy to the list of frames
            AddElement(frameArray())
            frameArray()\identifiant[0] = frame\identifiant[0]
            frameArray()\identifiant[1] = frame\identifiant[1]
            frameArray()\identifiant[2] = frame\identifiant[2]
            frameArray()\identifiant[3] = frame\identifiant[3]
            
            frameArray()\size[0] = frame\size[0]
            frameArray()\size[1] = frame\size[1]
            frameArray()\size[2] = frame\size[2]
            frameArray()\size[3] = frame\size[3]

            
            frameArray()\flag= frame\flag
            frameArray()\datas= frame\datas

            m_index = m_index + 1
            
        EndIf
            ; size of frame += size of the current frame + size of the frame header 
            m_taille + m_taille3 + 10
    Wend
    
    ; return number of frame
    PokeL(*m_numberOfFrames, m_index)

EndProcedure


;---- ReadFrame
; Purpose: Read ONE frame
; Require: a pointer to a ID3TagV23Frame structure
; Return : a filled frame
Procedure ReadFrame(*m_frame.ID3TagV23Frame)
  Protected b_Continuer.b
  Protected m_taille.l
  Protected m_identifiant.s

     ReadData(@*m_frame\identifiant, 4)
     ReadData(@*m_frame\size, 4)
    
     m_taille = (*m_frame\size[0] << 21) | (*m_frame\size[1] << 14) | (*m_frame\size[2] << 7) | *m_frame\size[3]    
     If m_taille = 0 
          ProcedureReturn 
     EndIf

     b_Continuer = #False

    ; 12 ID
     For m_compteur = 0 To 11
          m_identifiant = Space(4)
          m_identifiant = Chr(*m_frame\identifiant[0]) + Chr(*m_frame\identifiant[1]) + Chr(*m_frame\identifiant[2]) + Chr(*m_frame\identifiant[3])
          ; check if the current m_identifiant match one of the ID we are searching for
           If (TagsV2(m_compteur) =  m_identifiant)
              b_Continuer = #True
          EndIf
      Next
    
     If b_Continuer = #True
          ReadData(@*m_frame\flag, 2)
 
          ; bypass the encoding charactere
          ReadByte()

          If (UCase(m_identifiant) =  "COMM") 
               ReadLong()
                
                *m_frame\datas  = Space(m_taille - 5)
                ReadData(@*m_frame\datas, m_taille - 5)
          Else
                ; just in case ...
                If m_taille > 1 
                    If UCase(m_identifiant) = "WXXX"
                        Dim dummy.b(m_taille-1)
                        ReadData(@dummy(), m_taille-1)
                         *m_frame\datas = ByteToString(@dummy(), (m_taille/2)-1)
                    Else
                         *m_frame\datas = Space(m_taille-1)
                         ReadData(@*m_frame\datas, (m_taille - 1))
                    EndIf
               EndIf
          EndIf
     Else
        ; ID not found, add a "NULL" string to inform us
        ;*m_frame\identifiant[0] = Asc("N")
        ;*m_frame\identifiant[1] = Asc("U")
        ;*m_frame\identifiant[2] = Asc("L")
        ;*m_frame\identifiant[3] = Asc("L")
        PokeS(@*m_frame\identifiant, "NULL", 4)
     EndIf
    
    
EndProcedure


;---- CalculateTagSize
; Purpose: Calcul the size of the frame to write
; Require: nothing
; Return : the size of the frame to write
Procedure CalculateTagSize()
     
     ; totalSize = size of each frame + numberOfFrame * 11 ( 11 = sizeOfFrameHeader + 1 byte for the encoding char)
     m_taille.l = 0

     If (m_tagV2Info\title <> "" )
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\title)
     EndIf

     If (m_tagV2Info\artist <> "" )
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\artist)
     EndIf
    
     If (m_tagV2Info\album <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\album)
     EndIf
    
      If (m_tagV2Info\year <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\year)
     EndIf
    
      If (m_tagV2Info\genre <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\genre)
     EndIf
    
      If (m_tagV2Info\comments <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\comments) + 4
     EndIf
    
      If (m_tagV2Info\composer <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\composer)
     EndIf
     
      If (m_tagV2Info\orig_artist <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\orig_artist)
     EndIf
    
     If (m_tagV2Info\copyright <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\copyright)
     EndIf
    
     If (m_tagV2Info\url <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\url) * 2 + 1
     EndIf
    
     If (m_tagV2Info\encoded_by <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\encoded_by)
     EndIf
    
     If (m_tagV2Info\track <> "")
         m_taille + 10 + 1
         m_taille + Len(m_tagV2Info\track)
     EndIf
    
    ProcedureReturn m_taille
    
EndProcedure

;---- WriteV2Chiffre
; Purpose: Write a 32 bits long value, conform to the IDtagV2 spec.
; Require: chiffre ==> the number to write
; Return : nothing
Procedure WriteV2Chiffre(chiffre.l)
  Protected m_tailleAEcrire.l

     chiffre = chiffre + 1
    
     If (chiffre > 268435456)
         MessageRequester("Error", "Can't save : tag size exceed 256 MB ! ", 0)
         ProcedureReturn
     EndIf
    
     ; the number is coded on 7 bits, needed to for not be confused with a synchsignal
     m_tailleAEcrire = ( (chiffre & $FE00000) << 3) | ( (chiffre & $1FC000) << 2)| ( (chiffre & $3F80) << 1) | (chiffre & $7F)
         
     UseFile(#WRITE_OUTPUT_FILE_TAG)
     WriteByte((m_tailleAEcrire & $FF000000) >> 24)
     WriteByte((m_tailleAEcrire & $FF0000) >> 16)
     WriteByte((m_tailleAEcrire & $FF00) >> 8)
     WriteByte(m_tailleAEcrire  & $FF)

    
EndProcedure


;---- WriteTagV2
; Purpose: Write a IDTag V2.x (up to 2.3)
; Require: fichier ==> input file
;          bRemove ==> #TRUE if you only want to delete the tag
;                      #FALSE otherwise
; Return : nothing
Procedure WriteTagV2(fichier.s, bRemove.b, *TagV2ToWrite.ID3TagV2Tag)
  Protected hOrgFile.l
  Protected hNewFile.l
  Protected m_octetsLus.l
  Protected m_calcSize.l
  Protected m_strBuf.s

     hNewFile = CreateFile(#WRITE_OUTPUT_FILE_TAG, GetPathPart(fichier) + "dump.tmp")
     If hNewFile = 0
          ; MessageRequester("WriteTagV2::Error", "Error while creating dump.tmp", 0)
          ; Debug " Erreur de tag V2"
          ProcedureReturn
     EndIf
     UseFile(#WRITE_OUTPUT_FILE_TAG)
    
     ; don't remove the tag ?
     If bRemove = #False
          *m_tagV2Info = *TagV2ToWrite
      
          m_strBuf = Space(3)
          m_strBuf = "ID3"
          WriteData(@m_strBuf, Len(m_strBuf))    
          WriteByte(3)                             ; version
          WriteByte(0)                             ; revision
          WriteByte(0)                             ; flag
    
          ; write the frameSize
          m_calcSize = CalculateTagSize()
          WriteV2Chiffre(m_calcSize)

          ; 4 = sizeof(ID)
          m_strBuf = Space(4)
          If (m_tagV2Info\title <> "")
               m_strBuf = "TIT2"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\title))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\title, Len(m_tagV2Info\title))
          EndIf
    
          If (m_tagV2Info\artist <> "")
               m_strBuf = "TPE1"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\artist))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\artist, Len(m_tagV2Info\artist))
          EndIf

          If (m_tagV2Info\album <> "")
               m_strBuf = "TALB"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\album))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\album, Len(m_tagV2Info\album))
          EndIf
    
          If (m_tagV2Info\year <> "")
               m_strBuf = "TYER"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\year))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\year, Len(m_tagV2Info\year))
          EndIf
    
          If (m_tagV2Info\genre <> "")
               m_strBuf = "TCON"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\genre))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\genre, Len(m_tagV2Info\genre))
          EndIf
    
          If (m_tagV2Info\comments <> "")
               m_strBuf = "COMM"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\comments)+4)
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               language$ = "eng"
               WriteData(@language$, Len(language$)) ; language
               WriteByte(0)
               WriteData(@m_tagV2Info\comments, Len(m_tagV2Info\comments))
          EndIf
    
          If (m_tagV2Info\composer <> "")
               m_strBuf = "TCOM"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\composer))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\composer, Len(m_tagV2Info\composer))
          EndIf
    
          If (m_tagV2Info\orig_artist <> "")
               m_strBuf = "TOPE"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\orig_artist))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\orig_artist, Len(m_tagV2Info\orig_artist))
          EndIf
    
          If (m_tagV2Info\copyright <> "")
               m_strBuf = "TCOP"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\copyright))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\copyright, Len(m_tagV2Info\copyright))
          EndIf
    
          If (m_tagV2Info\url <> "")
               m_strBuf = "WXXX"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\url)*2+1)
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\url, Len(m_tagV2Info\url))
               WriteByte(0)
               WriteData(@m_tagV2Info\url, Len(m_tagV2Info\url))
          EndIf
    
          If (m_tagV2Info\encoded_by <> "")
               m_strBuf = "TENC"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\encoded_by))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\encoded_by, Len(m_tagV2Info\encoded_by))
          EndIf
    
          If (m_tagV2Info\track <> "")
               m_strBuf = "TRCK"
               WriteData(@m_strBuf, Len(m_strBuf))
               WriteV2Chiffre(Len(m_tagV2Info\track))
               WriteWord(0)                         ; flag
               WriteByte(0)                         ; caractere encoding
               WriteData(@m_tagV2Info\track, Len(m_tagV2Info\track))
          EndIf
    
    EndIf  ; end if bRemove
    
     hOrgFile = ReadFile(#WRITE_INPUT_FILE_TAG, fichier)
     If hOrgFile = 0
          ; MessageRequester("WriteTagV2::Error", "Error while reading " + fichier, 0)
          ; Debug "Erreur durant la lecture du tag de " + fichier
          ProcedureReturn
      EndIf
     UseFile(#WRITE_INPUT_FILE_TAG)
     m_fileSize.l = Lof()
     ; Debug "m_fileSize : " + Str(m_fileSize)

     m_taille.l = 0
     If HasTagV2(fichier)
          FileSeek(0)
          ReadData(@m_tagHeader.ID3TagV23Header, SizeOf(ID3TagV23Header))        
          m_taille = (m_tagHeader\size[0] << 21) | (m_tagHeader\size[1] << 14) | (m_tagHeader\size[2] << 7) | m_tagHeader\size[3]  
          m_taille + 10
          ; Debug "m_taille : " + Str(m_taille)
          FileSeek(Loc()+m_taille)
     Else
          ; If there is no Tag and the bRemove is set
          ;If (bRemove = #True)
          ;  CloseFile(WRITE_OUTPUT_FILE_TAG)
          ;  CloseFile(WRITE_INPUT_FILE_TAG)
          ;  ProcedureReturn
          ;EndIf
          FileSeek(Loc()+2)
          m_taille = 2
     EndIf
      
     ; some mp3 doesn't start just after the TagV2
     ; so make a copy of the data we have from the TagV2
     ; to the first Mp3 syncword position
     syncword.l    = searchMp3Header(0) - 1
     UseFile(#WRITE_OUTPUT_FILE_TAG)    
     curPosition.l = Loc()    
     sizeToWrite.l = syncword - curPosition

     If bRemove = false
        If (sizeToWrite > 0)
           Dim tmpBuffer.b(sizeToWrite)
           UseFile(#WRITE_INPUT_FILE_TAG)
           FileSeek(curPosition)    
           ReadData(@tmpBuffer(),  sizeToWrite)
           UseFile(#WRITE_OUTPUT_FILE_TAG)
           WriteData(@tmpBuffer(), sizeToWrite)     
        EndIf
      Else
         UseFile(#WRITE_INPUT_FILE_TAG)   
         FileSeek(m_taille)     
     EndIf
  
     UseFile(#WRITE_INPUT_FILE_TAG)  
     buffer.l = AllocateMemory(m_fileSize - m_taille)
     ReadData(buffer,m_fileSize - m_taille)    
     UseFile(#WRITE_OUTPUT_FILE_TAG)  
     WriteData(buffer, m_fileSize - m_taille)
    
     ;Dim buffer.b(4096)
     ;While (Eof(#WRITE_INPUT_FILE_TAG) = 0)
     ;     UseFile(#WRITE_INPUT_FILE_TAG)
     ;     ReadData(@buffer(),  4096)
     ;     UseFile(#WRITE_OUTPUT_FILE_TAG)
     ;     WriteData(@buffer(), 4096)
     ;Wend
    
     ;m_flushSize = Lof() - Loc()  
     ;Dim buffer.b(m_flushSize)
     ;UseFile(#WRITE_INPUT_FILE_TAG)
     ;ReadData(@buffer(),  m_flushSize)
     ;UseFile(#WRITE_OUTPUT_FILE_TAG)
     ;WriteData(@buffer(), m_flushSize)    
        
    
     CloseFile(#WRITE_INPUT_FILE_TAG)
     CloseFile(#WRITE_OUTPUT_FILE_TAG)
    
     ; Delete the source file
     DeleteFile_(fichier)
     FreeMemory(buffer)
    
    ; Rename the temp file to the source file
     If MoveFileEx_(GetPathPart(fichier) + "dump.tmp", fichier, #MOVEFILE_REPLACE_EXISTING) = 0
          ; MessageRequester("WriteTagV2::Error", "Error while renaming dump.tmp to " + fichier, 0)
          ; Debug "Erreur de TagV2"
          ProcedureReturn 
     EndIf
    
EndProcedure


;---- ReadTagV1
; Purpose: Read a IDTag V1.0/1.1
; Require: fichier ==> input file
; Return : fill the m_tagV1Info structure if the tag exist
Procedure.b ReadTagV1(fichier.s)
  Protected hOrgFile.l
  Dim m_temp.b(128)

     If HasTagV1(fichier) = #False
        ;MessageRequester("Error", "No IdTagV1 found.", 0)
        ProcedureReturn #False
     EndIf
    
     hOrgFile = ReadFile(#READ_INPUT_FILE_TAG, fichier)
     If (hOrgFile = 0)
          ; MessageRequester("ReadTagV1::Error", "Error occured while reading " + fichier, 0)
          ; Debug "Erreur de Tag sur :" + fichier
        ProcedureReturn #False
     EndIf
     FileSeek(Lof()-128)
     ReadData(@m_temp(), 128)
     CloseFile(#READ_INPUT_FILE_TAG)
            
     m_tagV1Info\tag           = PeekS(m_temp(),3)
     m_tagV1Info\title         = PeekS(m_temp()+3,30)
     m_tagV1Info\artist        = PeekS(m_temp()+33,30)
     m_tagV1Info\album         = PeekS(m_temp()+63,30)
     m_tagV1Info\year          = PeekS(m_temp()+93,4)
     m_tagV1Info\comments      = PeekS(m_temp()+97,30)
     ; IdTag V1.1 extension : the last comments byte is the track number
     If Right(m_tagV1Info\comments, 1) <> ""
         m_tagV1Info\track = PeekS(m_temp()+126, 1) ;Right(m_tagV1Info\comments, 1)
     EndIf
     m_tagV1Info\genre = Chr(PeekB(m_temp()+127))

     ProcedureReturn #True
EndProcedure


;---- WriteTagV1
; Purpose: Write a IDtag V1.0/1.1
; Require: fichier ==> input file
;          bRemove ==> #TRUE if you want only to remove the tag
;                      #FALSE otherwise
; Return : nothing
Procedure WriteTagV1(fichier.s, bRemove.b, *theTag.ID3TagV1Tag)
  Protected hOrgFile.l
  Protected m_compteur.l
  Protected m_ID3.s
  Protected m_offset.l

     If HasTagV1(fichier)
       m_offset = 128 
     Else
      m_offset = 0
     EndIf
    
     hOrgFile = OpenFile(#WRITE_INPUT_FILE_TAG, fichier)
     ; Debug hOrgFile 
     If (hOrgFile = 0)
          ; MessageRequester("WriteTagV1::Error", "Error occured while reading " + fichier, 0)
          ; Debug "Erreur de Tag sur :" + fichier
          ProcedureReturn
     EndIf
     
     UseFile(#WRITE_INPUT_FILE_TAG)
     FileSeek(Lof()-m_offset)
     If bRemove = #False
        m_ID3 = Space(3)
        m_ID3 = "TAG"
        WriteData(@m_ID3, 3)
        WriteData(*theTag\title, 30)
        WriteData(*theTag\artist, 30)
        WriteData(*theTag\album, 30)
        WriteData(*theTag\year, 4)
        ; Tag 1.1 extension : write the track
        If (Str(*theTag\track) <> "")
          dummy$ = padString(*theTag\comments, #True)
          WriteData(@dummy$, 28)
          WriteByte(0)
          WriteByte(Val(*theTag\track))
        Else
          WriteData(padString(*theTag\comments, #False), 30)
        EndIf
        WriteByte(Val(*theTag\genre))
     EndIf
    
     CloseFile(#WRITE_INPUT_FILE_TAG)
    
EndProcedure


;---- RemoveTagV1
; Purpose: Remove a IDtagV1
; Require: fichier (input file)
; Return : nothing
Procedure RemoveTagV1(fichier.s)
  Protected hOrgFile.l
  Protected hNewFile.l
  Protected m_taille.l
  Protected m_fileSize.l

    ; before doing anything
    ; check if the tag exists
    If HasTagV1(fichier) = #True
          m_fileSize = -128
    EndIf

     hNewFile = CreateFile(#WRITE_OUTPUT_FILE_TAG, GetPathPart(fichier) + "dump.tmp")
     If (hNewFile = 0)
          ; MessageRequester("RemoveTagV1::Error", "Error occured while creating dump.tmp", 0)
          ; Debug "Erreur de TagV1"
          ProcedureReturn
     EndIf    
     hOrgFile = ReadFile(#READ_INPUT_FILE_TAG, fichier)
     If (hOrgFile = 0)
          ; MessageRequester("RemoveTagV1::Error", "Error occured while reading " + fichier, 0)
          ; Debug "Erreur de Tag sur :" + fichier
          ProcedureReturn
     EndIf     

    ; size of the file to write (- sizeof(idtag), remember)
    m_fileSize + Lof()
    
    Dim m_temp.b(m_fileSize)
    FileSeek(0)
    ReadData(@m_temp(), m_fileSize)
    UseFile(#WRITE_OUTPUT_FILE_TAG)
    WriteData(@m_temp(), m_fileSize)
    CloseFile(#READ_INPUT_FILE_TAG)
    CloseFile(#WRITE_OUTPUT_FILE_TAG)
    
    ; delete the original file
     DeleteFile_(fichier)
    ; Rename the temp file to the original one
    If MoveFileEx_(GetPathPart(fichier) + "dump.tmp", fichier, #MOVEFILE_REPLACE_EXISTING) = 0
        ; MessageRequester("Error", "Error while renaming dump.tmp to " + fichier, 0)
        ; Debug "Erreur de TagV1"
        ProcedureReturn
    EndIf

EndProcedure


;---- HasTagV1
; Purpose: Check if a Tag V1.x exists
; Require: fichier ==> input file
; Return : #TRUE if the tag exists
;          #FALSE otherwise
Procedure HasTagV1(fichier.s)
  Protected hOrgFile.l
  Protected m_tag.s

     hOrgFile = ReadFile(20, fichier)
     If (hOrgFile = 0)
          ; MessageRequester("HasTagV1::Error", "Error occured while reading " + fichier, 0)
          ; Debug "Erreur de Tag sur :" + fichier
          ProcedureReturn
     EndIf     
     FileSeek(Lof()-128)
     m_tag = Space(3)
     ReadData(@m_tag, 3)
     ; Rewind
     FileSeek(0)
     CloseFile(20)
    
     If (m_tag = "TAG")
         ProcedureReturn #True
     Else
         ProcedureReturn #False
     EndIf
    
EndProcedure


Procedure decode_header(*fr.frame, newhead.l)
     ; sync
     If ((newhead & $FFE00000) <> $FFE00000) 
          ProcedureReturn 0
     EndIf
     
     If( newhead & (1<<20) )
          If (newhead & (1 << 19))
               *fr\lsf = 0
          Else
               *fr\lsf = 1
          EndIf               
          *fr\mpeg25 = 0;
     Else
          *fr\lsf = 1;
          *fr\mpeg25 = 1;
     EndIf
     
     *fr\mpegVersion = (newhead >> 19) & 3
     *fr\lay = 4-((newhead>>17)&3)

     If ( ( (newhead >> 10) & $3) = $3)
          ;Debug "Stream Error"
          ProcedureReturn 0
     EndIf    
    
     If(*fr\mpeg25)
          *fr\sampling_frequency = 6 + ( (newhead >> 10) & $3)
     Else
          *fr\sampling_frequency = ( (newhead >> 10) & $3) + (*fr\lsf * 3)
     EndIf
    
     *fr\error_protection = ( (newhead >> 16) & $1) ;^0x1
     *fr\bitrate_index    = ( (newhead >> 12) & $F)
     *fr\padding          = ( (newhead >>  9) & $1)
     *fr\extension        = ( (newhead >>  8) & $1)
     *fr\mode             = ( (newhead >>  6) & $3)
     *fr\mode_ext         = ( (newhead >>  4) & $3)
     *fr\copyright        = ( (newhead >>  3) & $1)
     *fr\original         = ( (newhead >>  2) & $1)
     *fr\emphasis         =    newhead &  $3
     
     ; MPG_MD_MONO
     If (*fr\mode = 3)
          *fr\stereo = 1
     Else
          *fr\stereo = 2
     EndIf     
     
     If (Val(m_freqs(*fr\sampling_frequency)) = 0)
          ProcedureReturn 0
     EndIf

     If (*fr\lay = 1)
          If (Val(m_mpeg1layer1(bitrate_index)) = 0)
               ProcedureReturn 0
          EndIf
        
          *fr\framesize  = Val(m_mpeg1layer1(*fr\bitrate_index)) * 12000
          *fr\framesize / Val(m_freqs(*fr\sampling_frequency))
          *fr\framesize  = ((*fr\framesize+*fr\padding)<<2)-4
          ;*fr\down_sample = 0
          ;*fr\down_sample_sblimit = 32 >> (*fr\down_sample)
          
     EndIf
     
     If (*fr\lay = 2)
          If (Val(m_mpeg1layer2(*fr\bitrate_index)) = 0)
               ProcedureReturn 0
          EndIf
          
          *fr\framesize  = Val(m_mpeg1layer2(*fr\bitrate_index)) * 144000
          *fr\framesize / Val(m_freqs(*fr\sampling_frequency))
          *fr\framesize + *fr\padding - 4
          ;*fr\down_sample=0
          ;*fr\down_sample_sblimit = 32 >> (*fr\down_sample)
                    
     EndIf
     
     If (*fr\lay = 3)
          If (Val(m_mpeg1layer3(*fr\bitrate_index)) = 0)
               ProcedureReturn 0
          EndIf     
          
          If (*fr\bitrate_index = 0)
               *fr\framesize = 0
          Else
               *fr\framesize  = Val(m_mpeg1layer3(*fr\bitrate_index)) * 144000
               *fr\framesize / (Val(m_freqs(*fr\sampling_frequency)) << *fr\lsf)
               *fr\framesize + *fr\padding - 4
               *fr\sampling_frequency = Val(m_freqs(*fr\sampling_frequency))
               
               ;*fr\down_sample=0
               ;*fr\down_sample_sblimit = 32 >> (*fr\down_sample)
          EndIf          
     EndIf
     
     ;Debug "BitRate   : " + m_mpeg1layer3(*fr\bitrate_index)
     ;Debug "Frequency : " + m_freqs(*fr\sampling_frequency)
     ;Debug "FrameSize : " + Str(*fr\framesize)
     
     If (*fr\framesize <= 0)
          ProcedureReturn 0
     EndIf
     
     ProcedureReturn 1

EndProcedure
  
     
Procedure.l ExtractI4(m_buffer.l)     
  Protected m_tmp.l

     m_tmp = PeekB(m_buffer)
     m_tmp << 8
     m_tmp | PeekB(m_buffer+1)
     m_tmp << 8
     m_tmp | PeekB(m_buffer+2)
     m_tmp << 8
     m_tmp | PeekW(m_buffer+3)

     ProcedureReturn m_tmp
EndProcedure


; Code : Freak (from the PureBasic Forum)
Procedure.l PeekLMotorola(address.l)
  !MOV eax, [esp]
  !MOV eax, [eax]
  !BSWAP eax
  ProcedureReturn
EndProcedure 


Procedure.l rv(x.l)
  Protected tmp.l     
 
     tmp = PeekLMotorola(@x)
         
     ProcedureReturn tmp.l

EndProcedure


Procedure.l rev32(d.l)
     ProcedureReturn rv(d)
EndProcedure


Procedure.l get_frame_size(newhead.l)
  Protected stereo.l
  Protected lsf.l
  Protected mpeg25.l
  Protected lay.l
  Protected bitrate_index.l
  Protected sampling_frequency.l
  Protected padding.l
  Protected framesize.l
  Protected mode.l
  Protected down_sample_sblimit.l
  Protected down_sample.l

     ; sync
     If ((newhead & $FFE00000) <> $FFE00000) 
          ProcedureReturn 0
     EndIf     

     If( newhead & (1<<20) )
          ;lsf = (newhead & (1<<19)) ? 0x0 : 0x1
          If (newhead & (1 << 19))
               lsf = 0
          Else
               lsf = 1
          EndIf
          mpeg25 = 0
     Else
          lsf = 1
          mpeg25 = 1
     EndIf
         
     lay = 4-((newhead >> 17) & 3)
     If ( ((newhead>>10) & $3) = $3)
          ;fprintf(stderr,"Stream error\n");
          ProcedureReturn 0
     EndIf
    
     If(mpeg25)
          sampling_frequency = ((newhead>>10) & $3)
     Else
          sampling_frequency = ((newhead>>10) & $3) + (lsf*3);
     EndIf
     
     bitrate_index  = ( (newhead >>12) & $F)
     padding        = ( (newhead >> 9) & $1)
     mode           = ( (newhead >> 6) & $3)
     
     ; MPG_MD_MONO
     If (mode = 3)
          stereo = 1
     Else
          stereo = 2
     EndIf

     If (Val(m_freqs(sampling_frequency)) = 0)
          ProcedureReturn 0
     EndIf
     
     If (lay = 1)
          If (Val(m_mpeg1layer1(bitrate_index)) = 0)
               ProcedureReturn 0
          EndIf
        
          framesize  = Val(m_mpeg1layer1(bitrate_index)) * 12000
          framesize / Val(m_freqs(sampling_frequency))
          framesize  = ((framesize+padding)<<2)-4
          down_sample=0
          down_sample_sblimit = 32 >> (down_sample)
          
     EndIf
     
     If (lay = 2)
          If (Val(m_mpeg1layer2(bitrate_index)) = 0)
               ProcedureReturn 0
          EndIf
          
          framesize  = Val(m_mpeg1layer2(bitrate_index)) * 144000
          framesize / Val(m_freqs(sampling_frequency))
          framesize + padding - 4
          down_sample=0
          down_sample_sblimit = 32 >> (down_sample)
                    
     EndIf
     
     If (lay = 3)
          If (Val(m_mpeg1layer3(bitrate_index)) = 0)
               ProcedureReturn 0
          EndIf     
          
          If (bitrate_index = 0)
               framesize = 0
          Else
               framesize  = Val(m_mpeg1layer3(bitrate_index)) * 144000
               framesize / (Val(m_freqs(sampling_frequency)) << lsf)
               framesize + padding - 4
               down_sample=0
               down_sample_sblimit = 32 >> (down_sample)
          EndIf          
     EndIf
     
     If (framesize <= 0)
          ProcedureReturn 0
     EndIf
     
     ProcedureReturn framesize + 4                                
         
EndProcedure


Procedure get_frame_size_rev(h.l)

     ProcedureReturn get_frame_size(rev32(h))     

EndProcedure


Procedure.f get_samples_per_frame(h.l)
  #VER_MPEG1  = 3     
  #VER_MPEG2  = 2
  #VER_MPEG25 = 0

     ver.l = (h & $1800) >> 11
     v.f
     Select ver
          Case #VER_MPEG1
               v = 576 * 2
          Case #VER_MPEG2
          Case #VER_MPEG25
               v = 576
          Default
               v = 0
     EndSelect

     ProcedureReturn v              
EndProcedure


Procedure test_header(h.l)
  Protected fr.frame

  RtlZeroMemory_(@fr, SizeOf(frame))
  ProcedureReturn decode_header(@fr, rev32(h))
 
EndProcedure


Procedure test_header2(h.l, prev.l)
  Protected fr1.frame
  Protected fr2.frame
 
 RtlZeroMemory_(@fr2, SizeOf(frame))

 If (decode_header(@fr1, rev32(prev)) <= 0 )
     ProcedureReturn 0
 EndIf

 If (decode_header(@fr2, rev32(h)) <= 0)
     ProcedureReturn 0
 EndIf

 If (fr1\mpeg25 = fr2\mpeg25) And (fr1\sampling_frequency = fr2\sampling_frequency) And (fr1\stereo = fr2\stereo)
     ProcedureReturn #True
 Else
     ProcedureReturn #False
 EndIf

EndProcedure


Procedure id3v2_calc_size()
  Dim tmp.b(10)

     ReadData(@tmp(), 10)
     ; check id3-tag
     id.s = PeekS(tmp(), 3)
     If UCase(id) <> "ID3"
          FileSeek(0)
          ProcedureReturn 0
     EndIf

     ; Read flags
     Unsynchronisation.l = PeekB(tmp()+5) & $80
     ExtHeaderPresent.l  = PeekB(tmp()+5) & $40
     ExperimentalFlag.l  = PeekB(tmp()+5) & $20
     FooterPresent.l     = PeekB(tmp()+5) & $10

     If (PeekB(tmp()+5) & $F)     
          FileSeek(0)
          ProcedureReturn 0
     EndIf

     If ( ( PeekB(tmp()+6) | PeekB(tmp()+7) | PeekB(tmp() + 8) | PeekB(tmp() + 9) ) & $80 )
          FileSeek(0)
          ProcedureReturn 0
     EndIf          

     ; Read HeaderSize (syncsave: 4 * $0xxxxxxx = 28 significant bits)
     retVal.l + PeekB(tmp()+6) << 21
     retVal.l + PeekB(tmp()+7) << 14
     retVal.l + PeekB(tmp()+8) << 7
     retVal.l + PeekB(tmp()+9)
     retVal + 10
     If (FooterPresent) 
          retVal + 10
     EndIf
     
     FileSeek(retVal)
     
     ProcedureReturn retVal     

EndProcedure


Procedure.l GetVbrTag(*pTagData.VBRTAGDATA, *buf.l)
  Protected i.l, head_flags.l
  Protected h_bitrate.l, h_id.l, h_sr_index.l
  Protected enc_delay.l, Enc_padding.l

     ; get Vbr header data
     *pTagData\flags     = 0
     
     ; get selected MPEG header data
     h_id           = (PeekB(*buf+1)  >> 3) & $1
     h_sr_index     = (PeekB(*buf+2)  >> 2) & $3
     h_mode         = (PeekB(*buf+3)  >> 6) & $3
     h_bitrate      = (PeekB(*buf+2)  >> 4) & $F
     
     If (h_id = 1)
          h_bitrate = Val(m_mpeg1layer3(h_bitrate))
     Else
          h_bitrate = Val(m_mpeg2layer3(h_bitrate))
     EndIf
     
     ; check for FFE syncword
     If (PeekB(*buf+4) >> 4) = $E
          ; mpeg 2.5
          *pTagData\samprate = Val(m_freqs(6+h_sr_index))
     Else
          *pTagData\samprate = Val(m_freqs(h_sr_index))
     EndIf

     ; determine offset of header
     If (h_id)
          ; mpeg 1
          If (h_mode <> 3)
               *buf + 32 + 4
          Else
               *buf + 17 + 4
          EndIf
     Else
          ; mpeg 2
          If (h_mode <> 3)
               *buf + 17 + 4
          Else
               *buf + 9 + 4
          EndIf
     EndIf
     
     m_lpstrTag.s = PeekS(*buf, 4)
     ; Debug "m_lpstrTag : " + m_lpstrTag
     
     If (m_lpstrTag <> "Xing") And (m_lpstrTag <> "Info")
          ProcedureReturn 0
     EndIf
     
     *pTagData\is_vbr = #True
     *buf + 4
     
     *pTagData\h_id = h_id
     *pTagData\flags = ExtractI4(*buf)
     *buf + 4
     head_flags = *pTagData\flags
     
     If (head_flags & #FRAMES_FLAG)
          *pTagData\frames = ExtractI4(*buf)
          *buf + 4
     EndIf

     If (head_flags & #BYTES_FLAG)
          *pTagData\bytes = ExtractI4(*buf)
          *buf + 4
     EndIf     
     
     If (head_flags & #TOC_FLAG)
          If (*pTagData\toc <> #NULL)
               For i = 0 To #NUMTOCENTRIES - 1
                    *pTagData\toc[i] = PeekB(*buf+i)
               Next
          EndIf
          *buf + #NUMTOCENTRIES
     EndIf     
     
     *pTagData\vbr_scale = -1
     
     If (head_flags & #VBR_SCALE_FLAG)
          *pTagData\vbr_scale = ExtractI4(*buf)
          *buf + 4
     EndIf
     
     
     *pTagData\headersize = ((h_id+1)*72000*h_bitrate) / *pTagData\samprate
     *buf + 21
     
     enc_delay      = PeekB(*buf) << 4
     enc_delay      + PeekB(*buf + 1) >> 4
     Enc_padding    = (PeekB(*buf + 1) & $F) << 8
     Enc_padding    + PeekB(*buf + 2)
     
     ; check For reasonable values (this may be an old Xing header,
     ; not a INFO tag)
     If (enc_delay<0 And enc_delay > 3000) 
          enc_delay = -1
     EndIf 
     If (Enc_padding<0 And Enc_padding > 3000) 
          Enc_padding = -1
     EndIf

     *pTagData\enc_delay      = enc_delay
     *pTagData\Enc_padding    = Enc_padding
     
     ProcedureReturn 1
     
EndProcedure


Procedure ScanForFrame()
  Protected max.l
  Protected scan_start.l
  Protected retVal.l
  Protected bFrameFound.b
  
  max = $100000
  scan_start = Loc()
  ;Debug "scan_start : " + Str(scan_start)
  retVal = -1
  bFrameFound = #False
  
  ;While (bFrameFound = #FALSE)
  Repeat
     Dim buffer.b(16384)
     
     ReadData(@buffer(), 16384)
     readTo.l = 16384 - 4
     For n.l = 0 To readTo
          header.l = PeekL(buffer() + n)
          If (test_header(header))
               ; curpos = 17522
               curpos.l = Loc()
               ; 4 = sizeof(buffer)
               ; ptr = 1138
               ptr.l = n + curpos - 16384
               header2.l
               ; newpos = 1555
               ; newFrameSize = 417
               newFrameSize = get_frame_size_rev(header)
               newpos = ptr + newFrameSize 
               FileSeek(newpos)
               header2 = ReadLong()
               If (test_header2(header2, header))
                    retVal = ptr
                    ;bFrameFound = #TRUE
                    Goto bFound
               Else
                    FileSeek(curpos)
               EndIf                              
          EndIf
     Next n
     If (Loc() - scan_start > max)
          ;bFrameFound = #TRUE
          Goto bFound
     EndIf
     FileSeek(Loc()-3)
  ;wend
  ForEver
  
  
bFound:
  ProcedureReturn retVal

EndProcedure


Procedure ExtractBits(the_val.l, bits_start.b, bits_len.b)
     retVal.l = ((the_val >> (bits_start - 1)) & ((1 << bits_len) - 1))
     ProcedureReturn retVal
EndProcedure


Procedure InitTab()

     m_mpeg1layer1(0) = "00"
     m_mpeg1layer1(1) = "32"
     m_mpeg1layer1(2) = "64"
     m_mpeg1layer1(3) = "96"
     m_mpeg1layer1(4) = "128"
     m_mpeg1layer1(5) = "160"
     m_mpeg1layer1(6) = "192"
     m_mpeg1layer1(7) = "224"
     m_mpeg1layer1(8) = "256"
     m_mpeg1layer1(9) = "288"
     m_mpeg1layer1(10) = "320"
     m_mpeg1layer1(11) = "353"
     m_mpeg1layer1(12) = "384"
     m_mpeg1layer1(13) = "416"
     m_mpeg1layer1(14) = "448"
     m_mpeg1layer1(15) = "-1"
     
     m_mpeg1layer2(0) = "00"
     m_mpeg1layer2(1) = "32"
     m_mpeg1layer2(2) = "48"
     m_mpeg1layer2(3) = "56"
     m_mpeg1layer2(4) = "64"
     m_mpeg1layer2(5) = "80"
     m_mpeg1layer2(6) = "96"
     m_mpeg1layer2(7) = "112"
     m_mpeg1layer2(8) = "128"
     m_mpeg1layer2(9) = "160"
     m_mpeg1layer2(10) = "192"
     m_mpeg1layer2(11) = "224"
     m_mpeg1layer2(12) = "256"
     m_mpeg1layer2(13) = "320"
     m_mpeg1layer2(14) = "384"
     m_mpeg1layer2(15) = "-1"

     m_mpeg1layer3(0) = "00"
     m_mpeg1layer3(1) = "32"
     m_mpeg1layer3(2) = "40"
     m_mpeg1layer3(3) = "48"
     m_mpeg1layer3(4) = "56"
     m_mpeg1layer3(5) = "64"
     m_mpeg1layer3(6) = "80"
     m_mpeg1layer3(7) = "96"
     m_mpeg1layer3(8) = "112"
     m_mpeg1layer3(9) = "128"
     m_mpeg1layer3(10) = "160"
     m_mpeg1layer3(11) = "192"
     m_mpeg1layer3(12) = "224"
     m_mpeg1layer3(13) = "256"
     m_mpeg1layer3(14) = "320"
     m_mpeg1layer3(15) = "-1"
     
     m_mpeg2layer3(0) = "00"
     m_mpeg2layer3(1) = "8"
     m_mpeg2layer3(2) = "16"
     m_mpeg2layer3(3) = "24"
     m_mpeg2layer3(4) = "32"
     m_mpeg2layer3(5) = "40"
     m_mpeg2layer3(6) = "48"
     m_mpeg2layer3(7) = "56"
     m_mpeg2layer3(8) = "64"
     m_mpeg2layer3(9) = "80"
     m_mpeg2layer3(10) = "96"
     m_mpeg2layer3(11) = "112"
     m_mpeg2layer3(12) = "128"
     m_mpeg2layer3(13) = "144"
     m_mpeg2layer3(14) = "160"
     m_mpeg2layer3(15) = "-1"     
     
     m_freqs(0)     = "44100"
     m_freqs(1)     = "48000"
     m_freqs(2)     = "32000"
     m_freqs(3)     = "22050"
     m_freqs(4)     = "24000"
     m_freqs(5)     = "16000"
     m_freqs(6)     = "11025"
     m_freqs(7)     = "12000"
     m_freqs(8)     = "8000"
          
EndProcedure


Procedure OpenFichier(num.l, nom$)

  If FileSize(nom$)<0
    ProcedureReturn 0
  Else
    ProcedureReturn OpenFile(num, nom$)
  EndIf
  
EndProcedure


Procedure GetMp3Infos(fichier.s)
  Protected first.l
  Protected last.l
  Protected total.l
  Protected header.l
  Protected erreur_fichier.b

    ;ClearTagV1Data(@m_tagV1Info)
    ;ClearTagV2Data(@m_tagV2Info)


     hOrgFile = OpenFichier(#READ_INPUT_FILE_TAG, fichier)
     If (hOrgFile = 0)
          ; MessageRequester("Error", "Error occured while reading " + fichier, 0)
          ; Debug "Erreur de Tag sur :" + fichier
          ProcedureReturn
     EndIf
     
     total = Lof()
     ; Debug "id3v2_calc_size : " + Str(id3v2_calc_size()) 
     
     InitTab()
     first = ScanForFrame()
     If (first < 0)
          FileSeek(0)
          ProcedureReturn 
     EndIf
     
     offset.l = total
     
     Repeat
          delta.l = offset
          If (delta > 16384)
               delta = 16384
          EndIf
          
          toRead.l = delta
          If (offset = delta)
               offset - delta
          Else
               If (delta > 16384 - 3)
                    delta = 16384 - 3
               EndIf
               offset - delta
          EndIf
          
          FileSeek(offset)
          Dim buf.b(toRead)
          ReadData(@buf(), 16384)
          
          For n = toRead - 4 To 0 Step -1
               If (test_header(PeekL(buf() + n)) And get_frame_size_rev(PeekL(buf() + n)) + offset + n <= total)
                    last = n + offset
                    total_bytes.l = last - first + get_frame_size_rev(PeekL(buf()+n))
                    Goto ExitLoop
               EndIf
          Next n
          If (last>=0 And offset=0) 
               Goto ExitLoop
          EndIf
     ForEver   
     
     If (last < 0)
          ProcedureReturn
     EndIf  
     
ExitLoop:
     Dim buf.b(16384)
     vbr_tag.VBRTAGDATA
     
     FileSeek(first)
     ReadData(@buf(), 16384)
     
     header = @buf()
     
     If (GetVbrTag(@vbr_tag, header) And vbr_tag\frames > 0)
         total_frames = vbr_tag\frames
         If (vbr_tag\is_vbr) 
               is_vbr.b = #True
               m_mp3infos\vbr  = "(VBR)"
         EndIf
         cbr_frameSize.l =  Int((last-first) / total_frames)
         ; Debug "VBR total_frames  : " + Str(total_frames)
         ; Debug "VBR cbr_frameSize : " + Str(cbr_framzSize)

     Else
          cbr_frameSize.l = get_frame_size_rev(PeekL(header))
          total_frames = ( (last - first) /  cbr_frameSize ) + 1
     EndIf
     
     If total_frames <= #SKIP_FIRST_FRAMES
          ProcedureReturn 0
     EndIf
     
     fr.frame
     RtlZeroMemory_(@fr, SizeOf(frame))
     If decode_header(@fr, rev32(PeekL(header))) <= 0
          ProcedureReturn 0
     EndIf
     srate.f = fr\sampling_frequency
     frame_time.f = get_samples_per_frame(PeekL(header)) / srate

     If (total_frames>0) 
          total_length.f = ((total_frames - #SKIP_FIRST_FRAMES) * frame_time) 
     Else
          total_length = -1.0
     EndIf
     
     ;total_length = Round(total_length, 1)
     ;Debug "total_length : " + StrF(total_length)
     ;Debug "frametime    : " + StrF(frame_time)
     
     If (total_length >= 0.0)          
          bitrate.l = Round((total_bytes * 8.0 / total_length / 1000.0) +0.5, 0)
          ;bitrate - 1
     Else
          bitrate.l = ((cbr_frameSize * 8) + 0.5) / (1000.0 * frame_time)
          ;bitrate - 1
     EndIf
     
     m_mp3infos\fileSize                = Str(total)
     m_mp3infos\headerPosition          = Str(first)
     Select fr\mpegVersion
          Case 0
               m_mp3infos\mpegVersion   = "2.5"
          Case 2 
               m_mp3infos\mpegVersion   = "2.0"  
          Case 3          
               m_mp3infos\mpegVersion   = "1.0"  
     EndSelect

     m_mp3infos\layerVersion            = Str(fr\lay)
     If (fr\error_protection = 1)
          m_mp3infos\protectionBit      = "No"
     Else
          m_mp3infos\protectionBit      = "Yes"
     EndIf    
     m_mp3infos\bitrate                 = Str(bitrate)
     m_mp3infos\samplerate              = Str(srate)
     If (fr\padding = 1)
          m_mp3infos\padding            = "Yes"
     Else
          m_mp3infos\padding            = "No"
     EndIf               
     If (fr\extension = 1)
          m_mp3infos\privateBit         = "Yes"
     Else
          m_mp3infos\privateBit         = "No"
     EndIf                    
     Select fr\mode
          Case 1
               m_mp3infos\channelMode   = "Joint Stereo"
          Case 2
               m_mp3infos\channelMode   = "Dual Channel"
          Case 3
               m_mp3infos\channelMode   = "Single Channel"
          Default
               m_mp3infos\channelMode   = "Stereo"
     EndSelect     
     ;m_mp3infos\modeExtension           = fr\mode
     If (fr\copyright = 1)
          m_mp3infos\copyright          = "Yes"
     Else
          m_mp3infos\copyright          = "No"
     EndIf
     If (fr\original = 1)
          m_mp3infos\original           = "Yes"
     Else
          m_mp3infos\original           = "No"
     EndIf                    
     Select fr\emphasis
          Case 0
               m_mp3infos\emphasis      = "None"
          Case 1
               m_mp3infos\emphasis      = "50/15ms"
          Case 2
               m_mp3infos\emphasis      = "Unknown"
          Case 3
               m_mp3infos\emphasis      = "CCITT j.17"
          Default 
               m_mp3infos\emphasis      = "Unknown"
     EndSelect     
     m_mp3infos\length                  = Str(Round(total_length,0))
     m_mp3infos\numOfFrames             = Str(total_frames)

     CloseFile(#READ_INPUT_FILE_TAG)
     
EndProcedure


Procedure searchMp3Header(m_startPosition.l)
  Dim m_buffer.b(4)
  Protected readsize.l
     
;     ReadTagV2(fichier)
;     m_startPosition = CalculateTagSize()

 ;    hOrgFile = OpenFile(#READ_INPUT_FILE_TAG, fichier)
 ;    If (hOrgFile = 0)
 ;         MessageRequester("Error", "Error occured while reading " + fichier, 0)
 ;         ProcedureReturn
 ;     EndIf     
     
     If (m_startPosition = 0)
          FileSeek(0)
     Else
          FileSeek(m_startPosition)
     EndIf

     ;While (Eof(#READ_INPUT_FILE_TAG) = 0)
     ;     ReadData(@m_buffer(), 4)
     ;     ;FileSeek(Loc()+(1-4))
     ;     ;syncword.l = ByteToLong(@m_buffer()) ; m_buffer(0) | m_buffer(1) | m_buffer(2) | m_buffer(3)
     ;      If (PeekB(m_buffer()+3) = $FF) 
     ;          Debug "FF trouve"
     ;      
     ;          nextByte.b = PeekB(m_buffer()+1)
     ;          If nextByte > 249 And nextByte < 252
     ;               ProcedureReturn Loc() - 2
     ;          EndIf
     ;     EndIf
     ;Wend
     
          While Asc(Chr(ReadByte())) <> $FF 
               HeaderStart = HeaderStart + 1 
          Wend      
          ProcedureReturn Loc() 
     
;     CloseFile(#READ_INPUT_FILE_TAG)
          
EndProcedure

;---- ByteToLong
; Purpose: convert an array of 4 bytes to a 32 bits long value
; Require: an array of byte
; Return : a converted long value
Procedure.l ByteToLong(*byteArray.l)
  Protected m_tmp.l
  Protected m_idx.b

    m_tmp = 0
    For m_idx = 0 To 3
        m_tmp = m_tmp + PeekB(*byteArray+m_idx) * Pow(2, ((3-m_idx)*7) )
    Next

    ProcedureReturn m_tmp
    
EndProcedure


;---- ByteToString
; Purpose: copy an array of byte to a string
; Require: an array of byte
;          the length of the array
; return : the string withing the array
Procedure.s ByteToString(*byteArray.b, m_length.l)
  Protected m_tmp.s
  Protected m_idx.b
    
    For m_idx = 0 To m_length - 1
           m_tmp = m_tmp + Chr(PeekB(*byteArray+m_idx))
    Next

    ProcedureReturn m_tmp
    
EndProcedure

;---- CopyByteToString
; Purpose: Copy a delimited array of byte to a string
; Require: an array of byte
;          m_fistPart position
;          m_endPart position
; return : the string withing the array from m_firtPart to m_endPart
Procedure.s CopyByteToString(*byteArray.b, m_firstPart.l, m_endPart.l)
Protected m_tmp.s
Protected m_idx.b

     For idx = m_firstPart To m_endPart
            m_tmp = m_tmp + Chr(PeekB(*byteArray+idx))
     Next
    
EndProcedure

Procedure.s padString(theString.s, dummy.b)
Protected m_idx.b
Protected m_lent.l
Protected m_newString.s

     If dummy
          m_len = 28
     Else
          m_len = 30
     EndIf
     
     m_newString = theString
     For m_idx = Len(theString) To m_len
          m_newString + Chr(0)
     Next m_idx
     ;Debug "m_newString.s : " + m_newString.s

     ProcedureReturn m_newString

EndProcedure


;Global BiggerStr$
;BiggerStr$ = Space(300)

Procedure.s GetBiggerLength(s1$, s2$)
  Protected r$

  If Len(s1$) > Len(s2$)
    r$ = s1$
  Else
    r$ = s2$
  EndIf
  
  ;Debug "> " + r$
  ProcedureReturn r$
  
EndProcedure



Procedure.l Get_BiggerLength(pStr1.l, pStr2.l)

  If Len(PeekS(pStr1)) > Len(PeekS(pStr2))
    ProcedureReturn pStr1
  Else
    ProcedureReturn pStr2
  EndIf
  
EndProcedure


Procedure MixTheTags(*v1.ID3TagV1Tag, *v2.ID3TagV2Tag, *out.ID3TagV2Tag)

  *out\title        = GetBiggerLength(*v1\title,    *v2\title)  : SetFirstLetterToMaj(@*out\title)
  *out\artist       = GetBiggerLength(*v1\artist,   *v2\artist) : SetFirstLetterToMaj(@*out\artist)
  *out\album        = GetBiggerLength(*v1\album,    *v2\album)  : SetFirstLetterToMaj(@*out\album)
  ;*out\year         = GetBiggerLength(*v1\year,     *v2\year)   : ;SetFirstLetterToMaj(@
  
  ; -- Les autres lignes ne sont pas nécessaires dans ce prog (-> ptt gain)
  ;*out\genre        = GetBiggerLength(*v1\genre,    *v2\genre)
  ;*out\comments     = GetBiggerLength(*v1\comments, *v2\comments)
  ;*out\composer     = *v2\composer
  ;*out\orig_artist  = *v2\orig_artist
  ;*out\copyright    = *v2\copyright
  ;*out\url          = *v2\url
  ;*out\encoded_by   = *v2\encoded_by
  ;*out\track        = GetBiggerLength(*v1\track, *v2\track)
  
EndProcedure




Procedure ClearTagV1Data(*tag.ID3TagV1Tag)

  ;*tag\tag      = ""
  *tag\title    = ""
  *tag\artist   = ""
  *tag\album    = ""
  ;*tag\year     = ""
  ;*tag\comments = ""
  ;*tag\genre    = ""
  ;*tag\track    = ""
  
EndProcedure


Procedure ClearTagV2Data(*tag.ID3TagV2Tag)

  *tag\title       = ""
  *tag\artist      = ""
  *tag\album       = ""
  ;*tag\year        = ""
  ;*tag\genre       = ""
  ;*tag\comments    = ""
  ;*tag\composer    = ""
  ;*tag\orig_artist = ""
  ;*tag\copyright   = ""
  ;*tag\url         = ""
  ;*tag\encoded_by  = ""
  ;*tag\track       = ""
  
EndProcedure



Procedure DebugPeekTagV2(*tag.ID3TagV2Tag)

  Debug "------- TAG V2 -----------------"
  Debug "title :      " + PeekS(*tag\title)
  Debug "artist :     " + PeekS(*tag\artist)
  Debug "album :      " + PeekS(*tag\album)
  ;Debug "year :       " + PeekS(*tag\year)
  ;Debug "genre :      " + PeekS(*tag\genre)
  ;Debug "comments :   " + PeekS(*tag\comments)
  ;Debug "composer :   " + PeekS(*tag\composer)
  ;Debug "orig_artist: " + PeekS(*tag\orig_artist)
  ;Debug "copyright :  " + PeekS(*tag\copyright)
  ;Debug "url :        " + PeekS(*tag\url)
  ;Debug "encoded_by : " + PeekS(*tag\encoded_by)
  ;Debug "track :      " + PeekS(*tag\track)
  
EndProcedure


Procedure DebugTagV2(*tag.ID3TagV2Tag)

  Debug "------- TAG V2 -----------------"
  Debug "title :      " + (*tag\title)
  Debug "artist :     " + (*tag\artist)
  Debug "album :      " + (*tag\album)
  ;Debug "year :       " + (*tag\year)
  ;Debug "genre :      " + (*tag\genre)
  ;Debug "comments :   " + (*tag\comments)
  ;Debug "composer :   " + (*tag\composer)
  ;Debug "orig_artist: " + (*tag\orig_artist)
  ;Debug "copyright :  " + (*tag\copyright)
  ;Debug "url :        " + (*tag\url)
  ;Debug "encoded_by : " + (*tag\encoded_by)
  ;Debug "track :      " + (*tag\track)
  
EndProcedure


Procedure DebugTagV1(*tag.ID3TagV1Tag)

  Debug "------- TAG V1 -----------------"
  ;Debug "tag :        " + PeekS(*tag\tag)
  Debug "title :      " + PeekS(*tag\title)
  Debug "artist :     " + PeekS(*tag\artist)
  Debug "album :      " + PeekS(*tag\album)
  Debug "year :       " + PeekS(*tag\year)
  ;Debug "genre :      " + PeekS(*tag\genre)
  ;Debug "comments :   " + PeekS(*tag\comments)
  ;Debug "track :      " + PeekS(*tag\track)
  
EndProcedure


Procedure TagIsEmpty(*tag.ID3TagV2Tag)

  If *tag\title = "" And *tag\artist = "" And *tag\album = ""
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf

EndProcedure


;- Data Section
; Here are all data to for the Genre of the song.

;DataSection
;genre: 
;Data.s "Blues" 
;Data.s "Classic Rock" 
;Data.s "Country" 
;Data.s "Dance" 
;Data.s "Disco" 
;Data.s "Funk" 
;Data.s "Grunge" 
;Data.s "Hip-Hop" 
;Data.s "Jazz" 
;Data.s "Metal" 
;Data.s "New Age" 
;Data.s "Oldies" 
;Data.s "Other" 
;Data.s "Pop" 
;Data.s "R&B" 
;Data.s "Rap" 
;Data.s "Reggae" 
;Data.s "Rock" 
;Data.s "Techno" 
;Data.s "Industrial" 
;Data.s "Alternative" 
;Data.s "Ska" 
;Data.s "Death Metal" 
;Data.s "Pranks" 
;Data.s "Soundtrack" 
;Data.s "Euro-Techno" 
;Data.s "Ambient" 
;Data.s "Trip-Hop" 
;Data.s "Vocal" 
;Data.s "Jazz Funk" 
;Data.s "Fusion" 
;Data.s "Trance" 
;Data.s "Classical" 
;Data.s "Instrumental" 
;Data.s "Acid" 
;Data.s "House" 
;Data.s "Game" 
;Data.s "Sound Clip" 
;Data.s "Gospel" 
;Data.s "Noise" 
;Data.s "AlternRock" 
;Data.s "Bass" 
;Data.s "Soul" 
;Data.s "Punk" 
;Data.s "Space" 
;Data.s "Meditative" 
;Data.s "Instrumental Pop" 
;Data.s "Instrumental Rock" 
;Data.s "Ethnic" 
;Data.s "Gothic" 
;Data.s "Darkwave" 
;Data.s "Techno -Industrial" 
;Data.s "Electronic" 
;Data.s "Pop-Folk" 
;Data.s "Eurodance" 
;Data.s "Dream" 
;Data.s "Southern Rock" 
;Data.s "Comedy" 
;Data.s "Cult" 
;Data.s "Gangsta" 
;Data.s "Top 40" 
;Data.s "Christian Rap" 
;Data.s "Pop/Funk" 
;Data.s "Jungle" 
;Data.s "Native American" 
;Data.s "Cabaret" 
;Data.s "New Wave" 
;Data.s "Psychadelic" 
;Data.s "Rave" 
;Data.s "Showtunes" 
;Data.s "TriGenreiler" 
;Data.s "Lo-Fi" 
;Data.s "Tribal" 
;Data.s "Acid Punk" 
;Data.s "Acid Jazz" 
;Data.s "Polka" 
;Data.s "Retro" 
;Data.s "MusiciGenrel" 
;Data.s "Rock & Roll" 
;Data.s "Hard Rock" 
;Data.s "Folk" 
;Data.s "Folk-Rock" 
;Data.s "National Folk" 
;Data.s "Swing" 
;Data.s "Fast Fusion" 
;Data.s "Bebob" 
;Data.s "Latin" 
;Data.s "Revival" 
;Data.s "Celtic" 
;Data.s "Bluegrass" 
;Data.s "Avantgarde" 
;Data.s "Gothic Rock" 
;Data.s "Progressive Rock" 
;Data.s "Psychedelic Rock" 
;Data.s "Symphonic Rock" 
;Data.s "Slow Rock" 
;Data.s "Big Band" 
;Data.s "Chorus" 
;Data.s "Easy Listening" 
;Data.s "Acoustic" 
;Data.s "Humour" 
;Data.s "Speech" 
;Data.s "Chanson" 
;Data.s "Opera" 
;Data.s "Chamber Music" 
;Data.s "Sonata" 
;Data.s "Symphony" 
;Data.s "Booty Bass" 
;Data.s "Primus" 
;Data.s "Porn Groove" 
;Data.s = "Satire" 
;Data.s = "Slow Jam" 
;Data.s "Club" 
;Data.s "Tango" 
;Data.s "Samba" 
;Data.s "Folklore" 
;Data.s "Ballad" 
;Data.s "Power Ballad" 
;Data.s "Rhythmic Soul" 
;Data.s "Freestyle" 
;Data.s "Duet" 
;Data.s "Punk Rock" 
;Data.s "Drum Solo" 
;Data.s "A Capella" 
;Data.s "Euro-House" 
;Data.s "Dance Hall" 
;Data.s "Goa" 
;Data.s "Drum & Bass" 
;Data.s "Club-House" 
;Data.s "Hardcore" 
;Data.s "Terror" 
;Data.s "Indie" 
;Data.s "BritPop" 
;Data.s "Negerpunk" 
;Data.s "Polsk Punk" 
;Data.s "Beat" 
;Data.s "Christian Gangsta Rap" 
;Data.s "Heavy Metal" 
;Data.s "Black Metal" 
;Data.s "Crossover" 
;Data.s "Contemporary Christian" 
;Data.s "Christian Rock" 
;Data.s "Merengue" 
;Data.s "Salsa" 
;Data.s "Thrash Metal" 
;Data.s "Anime" 
;Data.s "JPop" 
;Data.s "Synthpop" 
;End;DataSection 
; ExecutableFormat=Windows
; EOF
