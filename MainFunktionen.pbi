;Definitionen für Intel HEX Record-Typen
#IntelHex_DataRecord              = $00
#IntelHex_EndOfFileRecord         = $01
#IntelHex_ExtendedSegmentAddress  = $02
#IntelHex_StartSegmentAddress     = $03
#IntelHex_ExtendedLinearAddress   = $04
#IntelHex_StartLinearAddress      = $05

;Tabellenfarben
#Hintergrundfarbe                 = $ffffff
#IntelHex_RECORD_MARK             = $ccffff
#IntelHex_RECLEN                  = $ccff66
#IntelHex_LOAD_OFFSET             = $ffcccc
#IntelHex_RECTYP                  = $ff9999
#IntelHex_INFO                    = $ffffcc
#IntelHex_CHKSUM                  = $9999ff

Procedure test2(EventType)
  If CreateImage(0, 640, 1)
    StartDrawing(ImageOutput(0))
    
    Line(0, 0, 640, 1, $ffffff) ;Hintergrund
    Line(0, 0, 72, 1, $ccffff)
    Line(72, 0, 32, 1, $ccff66)
    Line(72+32, 0, 64, 1, $ffcccc)
    Line(72+32+64, 0, 40, 1, $ff9999)
    Line(72+32+64+40, 0, 376, 1, $ffffcc)
    Line(72+32+64+40+376, 0, 32, 1, $9999ff)

    StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it !
    If SaveImage(0, "background.bmp", #PB_ImagePlugin_BMP)
      MessageRequester("File created", "background.bmp")
    EndIf
  EndIf
EndProcedure

Procedure LoadFile(EventType)
  zeile.s
  datei.s = OpenFileRequester("Bitte Datei zum Laden auswählen", "", "", 0)
  ;datei.s = "Beispiel.hex"
  If datei.s
    zeilennummer.l = 0
    Loesche_Listview()
    If ReadFile(0, datei.s)
      While Eof(0) = 0
        zeile.s = ReadString(0, #PB_Ascii)
        sc.s = Mid(zeile.s, 1, 1)
        bc.s = Mid(zeile.s, 2, 2)
        ad.s = Mid(zeile.s, 4, 4)
        tp.s = Mid(zeile.s, 8, 2)
        df.s = Mid(zeile.s, 10) ;bis zum Zeilenende lesen
        ps.s = Right(df.s, 2);hintersten 2 Zeichen
        df.s = Mid(df.s, 1, StringByteLength(df.s, #PB_Ascii)-2)
        Neue_Zeile(sc.s, bc.s, ad.s, tp.s, df.s, ps.s)
      Wend
      CloseFile(0)
    EndIf
  EndIf
EndProcedure

Procedure SaveAsFile(EventType)
  datei.s = SaveFileRequester("Bitte Datei zum Speichern auswählen", "", "", 0)
  If datei.s
    zeilennummer.l = 0
    If CreateFile(0, datei.s)
      While 1
        text.s = Zeile_Auslesen(zeilennummer.l)
        If text.s = ""
          Break
        EndIf
        WriteStringN(0, text.s)
        zeilennummer.l = zeilennummer.l + 1
      Wend
    EndIf
    CloseFile(0)
  EndIf
EndProcedure


Procedure.s To_Hexadezimal(inp.s)
  out.s = ""
  For x.a = 1 To Len(inp.s)
    substring.s = Mid(inp.s, x.a, 1)
    substring.s = RSet(Hex(Asc(substring.s)), 2, "0")
    out.s = out.s + substring.s
    Debug out.s
  Next x.a
  ProcedureReturn out.s
EndProcedure

Procedure.s To_ASCII(inp.s)
  out.s = ""
  For x.a = 1 To Len(inp.s)/2
    substring.s = Mid(inp.s, (x.a*2)-1, 2)
    wert.a = Val("$"+substring.s)
    If wert.a > 31
      out.s = out.s + Chr(wert.a)
    EndIf
  Next x.a
  ProcedureReturn out.s
EndProcedure

Procedure.b IsHexDigit(Char.s)
  ; Korrektur: Bool() hinzugefügt
  ProcedureReturn Bool((Char >= "0" And Char <= "9") Or (UCase(Char) >= "A" And UCase(Char) <= "F"))
EndProcedure

Procedure.s CalculateIntelHexChecksum(HexLine.s)
  Protected CalculatedChecksumHex.s
  Protected TotalSum.i = 0
  Protected i.i
  Protected HexByte.s
  Protected ByteValue.i
  ; 1. Überprüfen, ob die Zeile mit ':' beginnt
  If Left(HexLine, 1) <> ":"
    MessageRequester("Fehler", "Zeile beginnt nicht mit ':'", #PB_MessageRequester_Ok)
    ProcedureReturn ""
  EndIf
  ; 2. Die Zeile muss eine gerade Anzahl von Hex-Ziffern nach dem ':' haben,
  ;    und eine Mindestlänge haben (1 (':') + 2 (LL) + 4 (AAAA) + 2 (RR) + 2 (CC) = 11 Zeichen)
  If Mod(Len(HexLine) - 1, 2) <> 0 Or Len(HexLine) < 11
    Debug "DEBUG: Fehler - Ungültige Länge oder ungerade Anzahl Hex-Ziffern."
    ProcedureReturn ""
  EndIf
  ; 3. Iteriere über alle relevanten Hex-Bytes (Byte Count, Address, Record Type, Data)
  ;    Der Index beginnt bei 2, um das ':' zu überspringen.
  ;    Die letzten 2 Zeichen sind die existierende Prüfsumme, die nicht mit einbezogen wird.
  For i = 2 To Len(HexLine) - 2 Step 2
    HexByte = Mid(HexLine, i, 2)
    ; Überprüfen, ob es sich um gültige Hex-Ziffern handelt
    If Not IsHexDigit(Mid(HexByte, 1, 1)) Or Not IsHexDigit(Mid(HexByte, 2, 1))
      Debug "DEBUG: Fehler - Ungültiges Hex-Zeichen: " + HexByte + " an Index " + Str(i)
      ProcedureReturn ""
    EndIf
    ByteValue = Val("$" + HexByte)
    TotalSum + ByteValue
  Next
  ; 4. Berechne das 2er-Komplement der Summe
  Protected FinalChecksumValue.i
  FinalChecksumValue = ( TotalSum & $FF ) ; Nur die unteren 8 Bit der Summe
  FinalChecksumValue = ( $100 - FinalChecksumValue ) & $FF ; Das 2er-Komplement davon, wieder auf 8 Bit maskiert
  ; 5. Konvertiere das Ergebnis in einen 2-stelligen Hex-String
  CalculatedChecksumHex = RSet(Hex(FinalChecksumValue, #PB_Byte), 2, "0")
  ProcedureReturn CalculatedChecksumHex
EndProcedure


; Prozedur zum Konvertieren eines Roh-Hex-Strings (z.B. "7A28A801")
; direkt in einen "escaped" ASCII-String (z.B. "z(\x28)\xA8\x01")
Procedure.s ConvertHexToEscapedAscii(HexString.s)
  Protected ResultString.s
  Protected i.i
  Protected HexByte.s
  Protected ByteValue.b

  If Mod(Len(HexString), 2) <> 0
    MessageRequester("Fehler", "Ungültige Hex-Sequenz: Ungerade Anzahl von Zeichen. '" + HexString + "'")
    ProcedureReturn "" ; Leerer String bei Fehler
  EndIf
  
  For i = 0 To Len(HexString) / 2 - 1
    HexByte = Mid(HexString, i * 2 + 1, 2)
    If Len(HexByte) = 2 And IsHexDigit(Mid(HexByte,1,1)) And IsHexDigit(Mid(HexByte,2,1))
      ByteValue = Val("$" + HexByte)

      ; Logik aus ConvertBinaryToEscapedAscii direkt angewendet
      If ByteValue >= 32 And ByteValue <= 126 ; Printable ASCII characters (Space to Tilde)
        If ByteValue = Asc("\") ; Spezieller Fall: Backslash selbst muss escaped werden
          ResultString + "\\"
        Else
          ResultString + Chr(ByteValue)
        EndIf
      Else ; Nicht-druckbare Zeichen oder Zeichen ausserhalb des Standard-ASCII-Bereichs
        ResultString + "\x" + RSet(Hex(ByteValue, #PB_Byte), 2, "0") ; Als \xXX darstellen
      EndIf
    Else
      MessageRequester("Fehler", "Ungültiges Hex-Zeichen in der Sequenz: '" + HexByte + "'")
      ProcedureReturn "" ; Leerer String bei Fehler
    EndIf
  Next
  ProcedureReturn ResultString
EndProcedure

; NEUE PROZEDUR: ConvertEscapedAsciiToRawHex
; Prozedur zum Konvertieren eines "escaped" ASCII-Strings (z.B. "z(\x28)\xA8\x01")
; direkt in einen Roh-Hex-String (z.B. "7A28A801")
; Die Prozedur (UNVERÄNDERT ZUM LETZTEN MAL!)
Procedure.s ConvertEscapedAsciiToRawHex(EscapedAsciiString.s)
  Protected ResultHex.s
  Protected Index.i, CurrentChar.s, NextChar.s
  Protected ByteValue.b
  Protected Len.i = Len(EscapedAsciiString)

  Index = 1
  While Index <= Len
    CurrentChar = Mid(EscapedAsciiString, Index, 1)
    If CurrentChar = "\"
      If Index + 1 <= Len
        NextChar = Mid(EscapedAsciiString, Index + 1, 1)
        Select NextChar
          Case "\"
            ByteValue = Asc("\")
            ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
            Index + 2

          Case "x", "X"
            If Index + 3 <= Len
              Define HexDigits.s = UCase(Mid(EscapedAsciiString, Index + 2, 2))
              If IsHexDigit(Mid(HexDigits, 1, 1)) And IsHexDigit(Mid(HexDigits, 2, 1))
                ByteValue = Val("$" + HexDigits)
                ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
                Index + 4
              Else
                ByteValue = Asc("\")
                ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
                ByteValue = Asc("x")
                ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
                Index + 2
              EndIf
            Else
              ByteValue = Asc("\")
              ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
              ByteValue = Asc("x")
              ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
              Index + 2
            EndIf

          Default
            ByteValue = Asc("\")
            ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
            ByteValue = Asc(NextChar)
            ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
            Index + 2
        EndSelect
      Else
        ByteValue = Asc("\")
        ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
        Index + 1
      EndIf
    Else
      ByteValue = Asc(CurrentChar)
      ResultHex + RSet(Hex(ByteValue, #PB_Byte), 2, "0")
      Index + 1
    EndIf
  Wend
  ProcedureReturn ResultHex
EndProcedure

Procedure Pruefsumme_Berechnen(spalte.l, zeile.l)
  text.s = Zeile_Auslesen(zeile.l)
  text.s = CalculateIntelHexChecksum(text.s)
  If (Not text.s = "") And (spalte.l = 5)
    *Ascii = Ascii(text.s)
    CallFunction(ListViewLibraryHandle.l, "SetItemText", ListViewHandle.l, *Ascii, 5, zeile.l)
  EndIf
  FreeMemory(*Ascii)
EndProcedure

Procedure.s InputRequesterS(spalte.l, zeile.l, wert.s, pos_x.u , pos_y.u)
  #InputRequesterSWID = 99
  If OpenWindow(#InputRequesterSWID, pos_x.u - 30 , pos_y.u + 10 , 360, 290,
                "", #PB_Window_Tool | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
    AddKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_Return, 10)
    AddKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_Escape, 99)
    ;Gadget:       #   PosX PosY DimX DimY Wert
    OptionGadget(980,  10,  10,  50,  20, "00: ")
    OptionGadget(981,  10,  45,  50,  20, "01: ")
    OptionGadget(982,  10,  80,  50,  20, "02: ")
    OptionGadget(983,  10, 115,  50,  20, "03: ")
    OptionGadget(984,  10, 150,  50,  20, "04: ")
    OptionGadget(985,  10, 200,  50,  20, "05: ")
    TextGadget(  970,  60,  10, 300,  30, "")
    TextGadget(  971,  60,  45, 300,  30, "")
    TextGadget(  972,  60,  80, 300,  30, "")
    TextGadget(  973,  60, 115, 300,  30, "")
    TextGadget(  974,  60, 150, 300,  45, "")
    TextGadget(  975,  60, 200, 300,  30, "")
    StringGadget(976,  10, 210, 340,  20, "")
    EditorGadget(  989,  10,  10, 340, 190, #PB_Editor_ReadOnly | #PB_Editor_WordWrap) ;grosses Textfeld
    ButtonGadget(  991, 220, 258,  60,  23, "OK", #PB_Button_Default)
    ButtonGadget(  998, 290, 258,  60,  23, "Cancel")
    
    Select spalte.l
      Case 0 ;Zeilennummer und Startcode
        SetWindowTitle(#InputRequesterSWID, "Zeilennummer & Satzbeginn")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetText(989, "Zeilennummer (" + RTrim(RTrim(wert.s, ":")) +
                           ~") und Startcode (:)\r\n" +
                           ~"Intel-Bezeichnung: RECORD MARK\r\n" +
                           "Nicht bearbeitbar!")
      Case 1 ;Datenlänge, Länge der Nutzdaten als zwei Hexadezimalziffern
        SetWindowTitle(#InputRequesterSWID, "Datenlänge")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetText(989, ~"Intel-Bezeichnung: RECLEN\r\n" +
                           ~"Byte count\r\n" + 
                           ~"Länge der Nutzdaten als zwei Hexadezimalziffern\r\n" +
                           "Datenlänge: 0x" + wert.s + ~" HEX\r\n" +
                           "Dezimal: " + Val("$" + wert.s) + ~" Bytes\r\n" +
                           "Nicht bearbeitbar!")
      Case 2 ;Adresse
        SetWindowTitle(#InputRequesterSWID, "Ladeadresse")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetText(989, ~"Intel-Bezeichnung: LOAD OFFSET\r\n" +
                           ~"16-Bit-Adresse (Big-Endian)\r\n"+
                           "0x" + wert.s + ~" HEX\r\n" +
                           "Nicht bearbeitbar!")
      Case 3 ;Datensatztyp
        SetWindowTitle(#InputRequesterSWID, "Datensatztyp")
        ;wird vom Gadget verdeckt:
        ;SetWindowColor(#InputRequesterSWID, $ffffcc) 
        ;grosses Textfeld verstecken
        HideGadget(989, 1) ;grosses Textfeld verstecken
        HideGadget(976, 1) ;StringGadget verstecken
        ;OptionGadget entsprechend anwählen:
        SetGadgetState(980 + Val("$" + wert.s), 1)
        ;Text für OptionGadget:
        SetGadgetText(970, ~"Data Record\r\n" +
                           "Nutzdaten")
        SetGadgetText(971, ~"End of File Record\r\n" +
                           "Dateiende (sowie Startadresse bei 8-Bit-Daten)")
        SetGadgetText(972, ~"Extended Segment Address Record\r\n" +
                           "Erweiterte Segmentadresse für nachfolgende Nutzdaten")
        SetGadgetText(973, ~"Start Segment Address Record\r\n" +
                           "Startsegmentadresse (CS:IP Register)")
        SetGadgetText(974, ~"Extended Linear Address Record\r\n" +
                           ~"Erweiterte lineare Adresse, höherwertige 16 Bit der\r\n" +
                           "Adresse für nachfolgende Nutzdaten")
        SetGadgetText(975, ~"Start Linear Address Record\r\n" +
                           "Lineare Startadresse (EIP-Register)")
      Case 4 ;Datenfeld
        SetWindowTitle(#InputRequesterSWID, "Daten")
        If CreatePopupMenu(99)
          MenuItem(1, "Hexadezimal")
          MenuItem(2, "ASCII")
          SetMenuItemState(99, 1, 1)
        EndIf
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetColor(976, #PB_Gadget_BackColor, $ffffcc)
        SetGadgetText(989, ~"Intel-Bezeichnung: INFO or DATA\r\n" +
                           "Nutzdaten (RECLEN x 2 Zeichen)")
        SetGadgetText(976, wert.s)
      Case 5 ;Prüfsumme
        SetWindowTitle(#InputRequesterSWID, "Prüfsumme")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetColor(976, #PB_Gadget_BackColor, $9999ff)
        SetGadgetText(989, ~"Intel-Bezeichnung: CHKSUM\r\n" +
                           ~"Prüfsumme über den Datensatz\r\n" +
                           ~"(ohne Satzbeginn)\r\n" +
                           "OK zum Neuberechnen, Cancel zum Beenden")
        SetGadgetText(976, wert.s)
    EndSelect
    
    lResult.s = ""
    lQuit.l = #False
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          lQuit = #True
        ;Case #PB_Event_RightClick
        Case #WM_RBUTTONDOWN
          DisplayPopupMenu(99, WindowID(#InputRequesterSWID))  
        Case #PB_Event_Menu
          Select EventMenu()
            Case 1 ;Hexadezimal
              If Not GetMenuItemState(99, 1)
                SetGadgetText(976, ConvertEscapedAsciiToRawHex(GetGadgetText(976)))
                SetMenuItemState(99, 1, 1)
                SetMenuItemState(99, 2, 0)
              EndIf
            Case 2 ;ASCII
              If Not GetMenuItemState(99, 2)
                SetGadgetText(976, ConvertHexToEscapedAscii(GetGadgetText(976)))
                SetMenuItemState(99, 1, 0)
                SetMenuItemState(99, 2, 1)
              EndIf
            Case 10 ;Return gedrückt
              If Not GetMenuItemState(99, 1)
                SetGadgetText(976, ConvertEscapedAsciiToRawHex(GetGadgetText(976)))
              EndIf
              lResult = GetGadgetText(976)
              lQuit = #True
            Case 99 ;Escape gedrückt
              lQuit = #True
          EndSelect
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 980 To 987 ;Checkbox geändert
              zahl.a = 0
              For x.a = 0 To 5
                ;If GetGadgetState(980 + x.a) = #PB_Checkbox_Checked
;                  zahl.a = SetBit(zahl.a, x.a)
                ;EndIf
              Next x.a
              wert.s = Str(zahl.a)
            Case 991 ;OK gedrückt
              Select spalte.l
                Case 4
                  If Not GetMenuItemState(99, 1)
                    SetGadgetText(976, ConvertEscapedAsciiToRawHex(GetGadgetText(976)))
                  EndIf
                  lResult = GetGadgetText(976)
                Case 5
                  Pruefsumme_Berechnen(spalte.l, zeile.l)
                  text.s = ""
                EndSelect
              lQuit = #True
            Case 998 ;Cancel gedrückt
              lQuit = #True
          EndSelect
      EndSelect
    Until lQuit
    RemoveKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_All)
    CloseWindow(#InputRequesterSWID)
   EndIf
   ProcedureReturn lResult
EndProcedure

Procedure Listview_Rechtsklick()
  *bereich = AllocateMemory(320)
  Rueckgabewert.l = CallFunction(ListViewLibraryHandle.l, "GetControlParas", *bereich)
  If Rueckgabewert.l = 2 ;Rechtsklick!
    ;0  = Handle des Listview Controls, in dem der Klick stattfand 
    If PeekL(*bereich+0) = ListViewHandle.l ;und es ist das Richtige!
      ;4  = Index der Spalte (nullbasierend), in der der Klick stattfand
      spalte.l = PeekL(*bereich+4)
      ;8  = Index der Zeile (nullbasierend), in der der Klick stattfand 
      zeile.l = PeekL(*bereich+8)
      ;64 = String (kein Zeiger!) mit dem Itemtext (maximal 256 Bytes, abschliessend mit Nullbyte)
      item_text.s = PeekS(*bereich+64, -1, #PB_Ascii)
      ;uns interessiert Spalte #3: CV-Wert und 1. Zeile ist #0
      ;SetItemText(H,T,S,L)    Setzt einen neuen Text als Itemtext ein.
      ;GetItemText(H,T,S,L)    Liest einen Itemtext aus.
      ;H : Long - Handle eines mit CreateListview() erstellten Listview Controls 
      ;T : Zeiger auf einen String mit dem neuen Text (max. 255 Zeichen) /
      ;    Bereich, in den der ausgelesene Text geschrieben wird
      ;S : Long - Index der Spalte von H, in die der neue Text gesetzt werden soll /
      ;    die ausgelesen werden soll (nullbasierend). 
      ;L : Long - Index der Zeile von H, in die der neue Text gesetzt werden soll /
      ;    die ausgelesen werden soll (nullbasierend). 
      ;Ergebnis: Long - Ungleich 0, bei Fehler 0.
      ;holt aus Spalte 1 die CV-Nummer:
      ;CallFunction(ListViewLibraryHandle.l, "GetItemText", ListViewHandle.l, *bereich, 1, zeile.l)
      ;cv_nummer.u = Val(PeekS(*bereich, -1, #PB_Ascii))
      ;nur wenn etwas geändert neu schreiben:
      item_text.s = InputRequesterS(spalte.l, zeile.l, item_text.s, DesktopMouseX(), DesktopMouseY())
      If Not item_text.s = ""
        ;schreibt den neuen Wert in die Zelle in entsprechende Zelle:
        *bereich = Ascii(item_text.s)
        CallFunction(ListViewLibraryHandle.l, "SetItemText", ListViewHandle.l, *bereich, spalte.l, zeile.l)
      EndIf
    EndIf
  EndIf
  FreeMemory(*bereich)
EndProcedure

Procedure WeiterSuchen(EventType)
  Protected zelle.s
  If textsuchen.s
    Repeat
      zelle.s = ZelleAuslesen(4, zeilensuchen.l)
      zelle.s = ConvertHexToEscapedAscii(zelle.s)
      zeilensuchen.l + 1
    Until FindString(zelle.s, textsuchen.s) Or (zeilensuchen.l > AnzahlZeilen())
    If zeilensuchen.l > AnzahlZeilen()
      MessageRequester("Warnung", "String nicht gefunden!")
    Else
      MessageRequester("Gefunden", "String gefunden in Zeile " + Str(zeilensuchen.l))
      ZeileSelektieren(zeilensuchen.l-1)
    EndIf
  EndIf
EndProcedure

Procedure Suchen(EventType)
  textsuchen.s = InputRequester("Textsuche", "Zu suchende Phrase eingeben:", "", 0, Window_0)
  If textsuchen.s
    zeilensuchen.l = 0
    WeiterSuchen(0)
  EndIf
EndProcedure


; IDE Options = PureBasic 6.20 (Windows - x86)
; CursorPosition = 491
; FirstLine = 445
; Folding = ---
; EnableXP
; DPIAware