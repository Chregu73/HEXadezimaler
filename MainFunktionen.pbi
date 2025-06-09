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
#IntelHex_DATA                    = $ffffcc
#IntelHex_CHKSUM                  = $9999ff

;Tabellenspalten
#Spalte_RECORD_MARK               = 0
#Spalte_RECLEN                    = 1
#Spalte_LOAD_OFFSET               = 2
#Spalte_RECTYP                    = 3
#Spalte_DATA                      = 4
#Spalte_CHKSUM                    = 5

#LF$                              = Chr(#LF)
;#CRLF$                             intern schon definiert!
#IntelHex_Leere_Zeile$            = ":"+#LF$+"00"+#LF$+"0000"+#LF$+"01"+#LF$+""+#LF$+"FF"

Procedure SpaltenFaerben()
  For i.l = 0 To CountGadgetItems(#ListView)-1
    SetGadgetItemColor(#ListView, i.l, #PB_Gadget_BackColor,
                       #IntelHex_RECORD_MARK, #Spalte_RECORD_MARK)
    SetGadgetItemColor(#ListView, i.l, #PB_Gadget_BackColor,
                       #IntelHex_RECLEN, #Spalte_RECLEN)
    SetGadgetItemColor(#ListView, i.l, #PB_Gadget_BackColor,
                       #IntelHex_LOAD_OFFSET, #Spalte_LOAD_OFFSET)
    SetGadgetItemColor(#ListView, i.l, #PB_Gadget_BackColor,
                       #IntelHex_RECTYP, #Spalte_RECTYP)
    SetGadgetItemColor(#ListView, i.l, #PB_Gadget_BackColor,
                       #IntelHex_DATA, #Spalte_DATA)
    SetGadgetItemColor(#ListView, i.l, #PB_Gadget_BackColor,
                       #IntelHex_CHKSUM, #Spalte_CHKSUM)
  Next i.l
EndProcedure

Procedure Zeichne_Listview(breite, hoehe, s0, s1, s2, s3, s4, s5)
  ListIconGadget(#ListView, 5, 5, breite, hoehe, "ZN/SC", s0,
                 #PB_ListIcon_GridLines |
                 #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#ListView, #Spalte_RECLEN, "BC", s1)
  AddGadgetColumn(#ListView, #Spalte_LOAD_OFFSET, "Adresse", s2)
  AddGadgetColumn(#ListView, #Spalte_RECTYP, "Typ", s3)
  AddGadgetColumn(#ListView, #Spalte_DATA, "Datenfeld", s4)
  AddGadgetColumn(#ListView, #Spalte_CHKSUM, "PS", s5)
  SetGadgetItemAttribute(#ListView, 0, #PB_ListIcon_ColumnAlignment,
                         #PB_ListIcon_Right, #Spalte_RECORD_MARK)
  SetGadgetItemAttribute(#ListView, 0, #PB_ListIcon_ColumnAlignment,
                         #PB_ListIcon_Center, #Spalte_RECLEN)
  SetGadgetItemAttribute(#ListView, 0, #PB_ListIcon_ColumnAlignment,
                         #PB_ListIcon_Right, #Spalte_LOAD_OFFSET)
  SetGadgetItemAttribute(#ListView, 0, #PB_ListIcon_ColumnAlignment,
                         #PB_ListIcon_Center, #Spalte_RECTYP)
  SetGadgetItemAttribute(#ListView, 0, #PB_ListIcon_ColumnAlignment,
                         #PB_ListIcon_Left, #Spalte_DATA)
  SetGadgetItemAttribute(#ListView, 0, #PB_ListIcon_ColumnAlignment,
                         #PB_ListIcon_Center, #Spalte_CHKSUM)
  ListViewFont = LoadFont(#PB_Any, "Courier New", 8)
  If ListViewFont
    SetGadgetFont(#ListView, FontID(ListViewFont))
  EndIf
EndProcedure

Procedure Speichere_Preferences()
  OpenPreferences("HEXadezimaler.ini")
  WritePreferenceInteger("Fensterposition X", WindowX(Window_0))
  WritePreferenceInteger("Fensterposition Y", WindowY(Window_0))
  WritePreferenceInteger("Fenstergroesse X", WindowWidth(Window_0,
                                                         #PB_Window_InnerCoordinate))
  WritePreferenceInteger("Fenstergroesse Y", WindowHeight(Window_0,
                                                          #PB_Window_InnerCoordinate))
  WritePreferenceInteger("Spalte 0", GetGadgetItemAttribute(#ListView, 0,
                                                            #PB_ListIcon_ColumnWidth,
                                                            #Spalte_RECORD_MARK))
  WritePreferenceInteger("Spalte 1", GetGadgetItemAttribute(#ListView, 0,
                                                            #PB_ListIcon_ColumnWidth,
                                                            #Spalte_RECLEN))
  WritePreferenceInteger("Spalte 2", GetGadgetItemAttribute(#ListView, 0,
                                                            #PB_ListIcon_ColumnWidth,
                                                            #Spalte_LOAD_OFFSET))
  WritePreferenceInteger("Spalte 3", GetGadgetItemAttribute(#ListView, 0,
                                                            #PB_ListIcon_ColumnWidth,
                                                            #Spalte_RECTYP))
  WritePreferenceInteger("Spalte 4", GetGadgetItemAttribute(#ListView, 0,
                                                            #PB_ListIcon_ColumnWidth,
                                                            #Spalte_DATA))
  WritePreferenceInteger("Spalte 5", GetGadgetItemAttribute(#ListView, 0,
                                                            #PB_ListIcon_ColumnWidth,
                                                            #Spalte_CHKSUM))
  ClosePreferences()
EndProcedure

Procedure Listview_Anpassen(breite, hoehe)
  ResizeGadget(#ListView, 5, 5, breite, hoehe)
EndProcedure

Procedure LoadFile(EventType)
  zeile.s
  datei.s = OpenFileRequester("Bitte Datei zum Laden auswählen", "", "", 0)
  Dim text.s(5)
  If datei.s
    zeilennummer.l = 0
    ClearGadgetItems(#ListView)
    If ReadFile(0, datei.s)
      OpenWindow(100, 0, 0, 200, 70, "Lade Datei...",
                 #PB_Window_WindowCentered | #PB_Window_Tool, WindowID(Window_0))
      TextGadget(101, 20, 10, 160, 20, "Lade Zeile:")
      TextGadget(102, 20, 30, 160, 20, "0", #PB_Text_Right | #PB_Text_Border)
      While Eof(0) = 0
        zeile.s = ReadString(0, #PB_Ascii)
        text.s(#Spalte_RECORD_MARK) = Mid(zeile.s, 1, 1)
        text.s(#Spalte_RECLEN)      = Mid(zeile.s, 2, 2)
        text.s(#Spalte_LOAD_OFFSET) = Mid(zeile.s, 4, 4)
        text.s(#Spalte_RECTYP)      = Mid(zeile.s, 8, 2)
        text.s(#Spalte_DATA)        = Mid(zeile.s, 10) ;bis zum Zeilenende lesen
        text.s(#Spalte_CHKSUM)      = Right(text.s(#Spalte_DATA), 2) ;hintersten 2 Zeichen
        text.s(#Spalte_DATA)        = Mid(text.s(#Spalte_DATA), 1,
                                          StringByteLength(text.s(#Spalte_DATA), #PB_Ascii)-2)
        zeilennummer.l + 1
        SetGadgetText(102, Str(zeilennummer.l))
        AddGadgetItem(#ListView, -1, Str(zeilennummer.l) + " " +
                                     text.s(#Spalte_RECORD_MARK) + #LF$ +
                                     text.s(#Spalte_RECLEN)      + #LF$ +
                                     text.s(#Spalte_LOAD_OFFSET) + #LF$ +
                                     text.s(#Spalte_RECTYP)      + #LF$ +
                                     text.s(#Spalte_DATA)        + #LF$ +
                                     text.s(#Spalte_CHKSUM))
      Wend
      CloseFile(0)
      SetGadgetText(101, "Färbe Spalten...")
      SpaltenFaerben()
      CloseWindow(100)
   EndIf
  EndIf
  FreeArray(text.s())
EndProcedure

Procedure SafeFile(EventType)
  If datei.s
    zeilennummer.l = 0
    If CreateFile(0, datei.s)
      OpenWindow(100, 0, 0, 200, 70, "Speichere Datei...",
                 #PB_Window_WindowCentered | #PB_Window_Tool, WindowID(Window_0))
      TextGadget(101, 20, 10, 160, 20, "Schreibe Zeile:")
      TextGadget(102, 20, 30, 160, 20, "0", #PB_Text_Right | #PB_Text_Border)
      For i.l = 0 To CountGadgetItems(#ListView)-1
        text.s = ":" +
           GetGadgetItemText(#ListView, zeilennummer.l, #Spalte_RECLEN) +
           GetGadgetItemText(#ListView, zeilennummer.l, #Spalte_LOAD_OFFSET) +
           GetGadgetItemText(#ListView, zeilennummer.l, #Spalte_RECTYP) +
           GetGadgetItemText(#ListView, zeilennummer.l, #Spalte_DATA) +
           GetGadgetItemText(#ListView, zeilennummer.l, #Spalte_CHKSUM)
        If text.s = ":"
          Break
        EndIf
        WriteStringN(0, text.s)
        zeilennummer.l + 1
        SetGadgetText(102, Str(zeilennummer.l) + " / " + CountGadgetItems(#ListView))
      Next i.l
    EndIf
    CloseFile(0)
    CloseWindow(100)
  Else
    SaveAsFile(0)
  EndIf
EndProcedure

Procedure SaveAsFile(EventType)
  datei.s = SaveFileRequester("Bitte Datei zum Speichern auswählen", "", "", 0)
  If datei.s
    SafeFile(0)
  EndIf
EndProcedure

Procedure NeueTabelle(EventType)
  datei.s = ""
  ClearGadgetItems(#ListView)
  AddGadgetItem(#ListView, -1, "1 "+#IntelHex_Leere_Zeile$)
  SpaltenFaerben()
EndProcedure

Procedure NeuDurchnummerieren(Event)
  For zeile.l = 0 To CountGadgetItems(#ListView)-1
    SetGadgetItemText(#ListView, zeile.l, Str(zeile.l+1)+" :", #Spalte_RECORD_MARK)
  Next zeile.l
EndProcedure

Procedure ZeileLoeschen(Event)
  RemoveGadgetItem(#ListView, GetGadgetState(#ListView))
  NeuDurchnummerieren(0)
EndProcedure

Procedure ZeileEinfuegen(Event)
  AddGadgetItem(#ListView, GetGadgetState(#ListView)+1,  "1 "+#IntelHex_Leere_Zeile$)
  NeuDurchnummerieren(0)
  SpaltenFaerben()
EndProcedure

Procedure.i GetSelectedColumn(WindowID.i, ListIconID.i)
  Protected SelectedColumn.i
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ; ------------------------------------------------
      Protected ColumnList.i
      Protected ColumnObject.i
      Protected Iter.i
      Protected Path.i
      Protected TreeStore.i
      If gtk_tree_view_get_cursor_(GadgetID(ListIconID), @Path.i, @ColumnObject.i)
        TreeStore.i = gtk_tree_view_get_model_(GadgetID(ListIconID))
        If gtk_tree_model_get_iter_(TreeStore.i, @Iter.i, Path.i)
          If Path.i <> 0 And ColumnObject.i <> 0
            ColumnList.i = gtk_tree_view_get_columns_(GadgetID(ListIconID))
            SelectedColumn.i = g_list_index_(ColumnList.i, ColumnObject.i)
            g_list_free_(ColumnList.i)
          EndIf
        EndIf
      EndIf
    CompilerCase #PB_OS_MacOS ; ------------------------------------------------
      Protected CursorLocation.NSPoint
      CursorLocation\x = WindowMouseX(WindowID)
      CursorLocation\y = WindowHeight(WindowID) - WindowMouseY(WindowID)
      CocoaMessage(@CursorLocation, GadgetID(ListIconID),
        "convertPoint:@", @CursorLocation, "fromView:", 0)
      SelectedColumn.i = CocoaMessage(0, GadgetID(ListIconID),
        "columnAtPoint:@", @CursorLocation)
    CompilerCase #PB_OS_Windows ; ----------------------------------------------
      Protected CursorLocation.POINT
      Protected HitInfo.LVHITTESTINFO
      GetCursorPos_(CursorLocation)
      MapWindowPoints_(0, GadgetID(ListIconID), CursorLocation, 1)             
      Hitinfo\pt\x = CursorLocation\x
      HitInfo\pt\y = CursorLocation\y
      SendMessage_(GadgetID(ListIconID), #LVM_SUBITEMHITTEST, 0, HitInfo)
      SelectedColumn.i = HitInfo\iSubItem                       
  CompilerEndSelect
  ProcedureReturn SelectedColumn.i
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
  ProcedureReturn Bool((Char >= "0" And Char <= "9") Or (UCase(Char) >= "A" And
                                                         UCase(Char) <= "F"))
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
    MessageRequester("Fehler", "Ungültige Hex-Sequenz: Ungerade Anzahl von Zeichen. '" +
                               HexString + "'")
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
  text.s = ":" +
           GetGadgetItemText(#ListView, zeile.l, #Spalte_RECLEN) +
           GetGadgetItemText(#ListView, zeile.l, #Spalte_LOAD_OFFSET) +
           GetGadgetItemText(#ListView, zeile.l, #Spalte_RECTYP) +
           GetGadgetItemText(#ListView, zeile.l, #Spalte_DATA) +
           GetGadgetItemText(#ListView, zeile.l, #Spalte_CHKSUM)
  text.s = CalculateIntelHexChecksum(text.s)
  If (Not text.s = "") And (spalte.l = #Spalte_CHKSUM)
    SetGadgetItemText(#ListView, zeile.l, text.s, #Spalte_CHKSUM)
  EndIf
EndProcedure

Procedure PruefeTypGeaendert(zeile.l, Typ.s)
  ;Prüfen ob bei geandertem Datentyp:
  ;wenn Typ=0,2...5 => Datensatzlänge = Datenfeld
  ;wenn Typ=1       => Datensatzlänge=0 und Adresse="0000"
  If typ.s = "01"
    If (GetGadgetItemText(#ListView, zeile.l, #Spalte_RECLEN) <> "00") Or
       (GetGadgetItemText(#ListView, zeile.l, #Spalte_DATA) <> "")
      If MessageRequester("Achtung",
                          "Datensatzlänge ist nicht Null, automatisch anpassen?",
                          #PB_MessageRequester_YesNo |
                          #PB_MessageRequester_Warning) = #PB_MessageRequester_Yes
        SetGadgetItemText(#ListView, zeile.l, "00", #Spalte_RECLEN)
        SetGadgetItemText(#ListView, zeile.l, "0000", #Spalte_LOAD_OFFSET)
        SetGadgetItemText(#ListView, zeile.l, "", #Spalte_DATA)
      EndIf 
    EndIf
  Else ;Typ=0,2...5
    If (GetGadgetItemText(#ListView, zeile.l, #Spalte_RECLEN) = "00") Or
       (GetGadgetItemText(#ListView, zeile.l, #Spalte_DATA) = "")
      MessageRequester("Achtung",
                       "Datensatzlänge ist Null!" + #CRLF$ +
                       "Bitte RECLEN und DATA auf richtige Länge überprüfen!",
                       #PB_MessageRequester_Ok | #PB_MessageRequester_Warning)
    EndIf
  EndIf
EndProcedure  

Procedure.s DatenfeldPruefen(zeile.l, TestString.s)
  TestString.s = UCase(TestString.s)
  DatenLaenge.l = Val("$"+GetGadgetItemText(#ListView, zeile.l, #Spalte_RECLEN))*2 ;1Byte=2Zeichen
  
  If Len(TestString.s) <> (DatenLaenge.l)
    MessageRequester("Achtung",
                     "Datensatzlänge entspricht nicht der erwarteten Länge!" + #CRLF$ +
                     "Bitte DATA auf richtige Länge überprüfen!" + #CRLF$ +
                     "Erwartete Länge: " + Str(DatenLaenge.l) + #CRLF$ +
                     "Effektive Länge: " + Str(Len(TestString.s)),
                     #PB_MessageRequester_Ok | #PB_MessageRequester_Warning)
    ;TestString.s = "" ;Leerer String zurück zum nichts ändern
  EndIf
  Fehler.l = 0
  For i = 0 To Len(TestString.s)-1
    HexNibble.s = Mid(TestString.s, i+1, 1)
    If Not IsHexDigit(Mid(HexNibble.s, 1, 1))
      Fehler.l+1
    EndIf
  Next
  If Fehler.l
    MessageRequester("Achtung",
                     "Datensatz enthält " + Str(Fehler.l) +
                     " ungültige(s) Zeichen!" + #CRLF$ +
                     "Gültige Zeichen sind: 0...9 und A...F" + #CRLF$ +
                     "Kleinbuchstaben werden automatisch in Grossbuchstaben umgewandelt!",
                     #PB_MessageRequester_Ok | #PB_MessageRequester_Warning)
    ;TestString.s = "" ;Leerer String zurück zum nichts ändern
  EndIf
  ProcedureReturn TestString.s
EndProcedure

Procedure.s InputRequesterS(spalte.l, zeile.l, wert.s, pos_x.u , pos_y.u)
  #InputRequesterSWID = 99
  If OpenWindow(#InputRequesterSWID, pos_x.u - 30 , pos_y.u + 10 , 360, 290,
                "", #PB_Window_Tool | #PB_Window_SystemMenu |
                    #PB_Window_SizeGadget | #PB_Window_TitleBar)
    StickyWindow(#InputRequesterSWID, #True)
    DisableWindow(Window_0, #True)
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
      Case #Spalte_RECORD_MARK ;Zeilennummer und Startcode
        SetWindowTitle(#InputRequesterSWID, "Zeilennummer & Satzbeginn")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetColor(976, #PB_Gadget_BackColor, #IntelHex_RECORD_MARK)
        SetGadgetText(989, "Zeilennummer (" + RTrim(RTrim(wert.s, ":")) +
                           ~") und Startcode (:)\r\n" +
                           ~"Intel-Bezeichnung: RECORD MARK\r\n" +
                           "Nicht bearbeitbar!")
      Case #Spalte_RECLEN ;Datenlänge, Länge der Nutzdaten als zwei Hexadezimalziffern
        SetWindowTitle(#InputRequesterSWID, "Datenlänge")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetColor(976, #PB_Gadget_BackColor, #IntelHex_RECLEN)
        SetGadgetText(989, ~"Intel-Bezeichnung: RECLEN\r\n" +
                           ~"Byte count\r\n" + 
                           ~"Länge der Nutzdaten als zwei Hexadezimalziffern\r\n" +
                           "Datenlänge: 0x" + wert.s + ~" HEX\r\n" +
                           "Dezimal: " + Val("$" + wert.s) + " Bytes")
        SetGadgetText(976, wert.s)
      Case #Spalte_LOAD_OFFSET ;Adresse
        SetWindowTitle(#InputRequesterSWID, "Ladeadresse")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetColor(976, #PB_Gadget_BackColor, #IntelHex_LOAD_OFFSET)
        SetGadgetText(989, ~"Intel-Bezeichnung: LOAD OFFSET\r\n" +
                           ~"16-Bit-Adresse (Big-Endian)\r\n"+
                           "0x" + wert.s + " HEX")
        SetGadgetText(976, wert.s)
      Case #Spalte_RECTYP ;Datensatztyp
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
      Case #Spalte_DATA ;Datenfeld
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
        SetGadgetColor(976, #PB_Gadget_BackColor, #IntelHex_DATA)
        SetGadgetText(989, ~"Intel-Bezeichnung: INFO or DATA\r\n" +
                           "Nutzdaten (RECLEN x 2 Zeichen)")
        SetGadgetText(976, wert.s)
      Case #Spalte_CHKSUM ;Prüfsumme
        SetWindowTitle(#InputRequesterSWID, "Prüfsumme")
        For x.a = 0 To 5
          ;CheckBoxen verstecken:
          HideGadget(980 + x.a, 1)
        Next x.a
        SetGadgetColor(976, #PB_Gadget_BackColor, #IntelHex_CHKSUM)
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
        ;Rechte Maustaste gedrückt:
        Case #WM_RBUTTONDOWN
          ;Popup-Menu nur anzeigen, wenn Spalte 4 (Datenfeld)
          If spalte.l = 4
            DisplayPopupMenu(99, WindowID(#InputRequesterSWID))
          EndIf
        ;Popup-Menu, Return oder Escape gedrückt im Requester:
        Case #PB_Event_Menu
          Select EventMenu()
            ;1+2 nur bei Spalte 4:
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
            Case 10 ;Return gedrückt, ohne Plausibilitätsprüfung
              If Not GetMenuItemState(99, 1)
                SetGadgetText(976, ConvertEscapedAsciiToRawHex(GetGadgetText(976)))
              EndIf
              lResult.s = GetGadgetText(976)
              lQuit = #True
            Case 99 ;Escape gedrückt
              lQuit = #True
          EndSelect
        ;Checkbox geändert, OK oder Cancel gedrückt:
        Case #PB_Event_Gadget
          Select EventGadget()
            Case 980 To 987 ;Checkbox geändert
              For x.a = 0 To 5
                If GetGadgetState(980 + x.a) = #PB_Checkbox_Checked
                  lResult.s = "0" + Str(x.a)
                EndIf
              Next x.a
            Case 991 ;OK gedrückt
              Select spalte.l
                Case #Spalte_RECLEN
                  lResult.s = GetGadgetText(976)
                Case #Spalte_LOAD_OFFSET
                  lResult.s = GetGadgetText(976)
                Case #Spalte_RECTYP
                  PruefeTypGeaendert(zeile.l, lResult.s)
                Case #Spalte_DATA
                  If Not GetMenuItemState(99, 1)
                    SetGadgetText(976, ConvertEscapedAsciiToRawHex(GetGadgetText(976)))
                  EndIf
                  ;Plausibilitätsprüfung:
                  lResult.s = GetGadgetText(976)
                  lResult.s = DatenfeldPruefen(zeile.l, lResult.s)
                Case #Spalte_CHKSUM
                  Pruefsumme_Berechnen(spalte.l, zeile.l)
                  text.s = ""
                EndSelect
              lQuit = #True
            Case 998 ;Cancel gedrückt
              lResult.s = "" ;nichts ändern
              lQuit = #True
          EndSelect
      EndSelect
    Until lQuit
    ;Popup-Menu wieder freigeben:
    If IsMenu(99)
      FreeMenu(99)
    EndIf
    RemoveKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_All)
    CloseWindow(#InputRequesterSWID)
  EndIf
  DisableWindow(Window_0, #False) ;Enabled das Hauptfenster wieder
  SetActiveWindow(Window_0) ;und setzt den Fokus drauf
  BringWindowToTop_(Window_0) ;kommt aber erst hier wieder in den Vordergrund
  ProcedureReturn lResult.s
EndProcedure

Procedure Listview_Rechtsklick(klick_art)
  zeile.l = GetGadgetState(#ListView) ;Zeile
  spalte.l = GetSelectedColumn(Window_0, #ListView) ;Spalte
  text.s = GetGadgetItemText(#ListView, zeile.l, spalte.l)
  text.s = InputRequesterS(spalte.l, zeile.l, text.s, DesktopMouseX(), DesktopMouseY())
  If Not text.s = ""
    SetGadgetItemText(#ListView, zeile.l, text.s, spalte.l)
  EndIf
EndProcedure

; Findet einen Zielstring im Quellstring, ignoriert dabei die Sequenz "\x" im Quellstring.
; Gibt die Startposition des Zielstrings zurück (1-basiert), oder 0, wenn nicht gefunden.
;
; SourceString$: Der String, in dem gesucht werden soll.
; SearchString$: Der String, der gesucht werden soll.
; StartPosition: Die Position im SourceString, ab der gesucht werden soll (optional, Standard ist 1).
;
Procedure.i FindStringIgnoringBackslashX(SourceString.s, SearchString.s, StartPosition = 1)
  Protected SourceLen = Len(SourceString)
  Protected SearchLen = Len(SearchString)
  Protected CurrentSourcePos = StartPosition
  Protected TempSourceChar.s
  Protected MatchFound = #False
  ; Grundlegende Prüfungen
  If SearchLen = 0 : ProcedureReturn StartPosition : EndIf ; Leerer Suchstring ist immer gefunden
  If SourceLen = 0 : ProcedureReturn 0 : EndIf ; Leerer Quellstring kann nichts enthalten
  If StartPosition < 1 : StartPosition = 1 : EndIf ; Startposition muss mindestens 1 sein
  If StartPosition > SourceLen : ProcedureReturn 0 : EndIf ; Startposition außerhalb des Strings
  ; Hauptsuchschleife
  While CurrentSourcePos <= SourceLen
    TempSourceChar = Mid(SourceString, CurrentSourcePos, 1)
    ; Prüfen, ob wir bei "\x" sind
    If TempSourceChar = "\" And CurrentSourcePos + 1 <= SourceLen And
       Mid(SourceString, CurrentSourcePos + 1, 1) = "x"
      ; "\x" gefunden, überspringe diese beiden Zeichen
      CurrentSourcePos + 2
      Continue ; Springe zum nächsten Schleifendurchlauf
    EndIf
    ; Wenn nicht "\x", versuche eine Übereinstimmung
    If CurrentSourcePos + SearchLen - 1 <= SourceLen
      ; Erstelle einen temporären Substring aus SourceString (ohne "\x")
      ; und vergleiche ihn mit SearchString
      Protected EffectiveSourceChar.s
      Protected SearchIndex = 1
      Protected SourcePtr = CurrentSourcePos
      Protected MatchPossible = #True
      While SearchIndex <= SearchLen And SourcePtr <= SourceLen
        TempSourceChar = Mid(SourceString, SourcePtr, 1)
        If TempSourceChar = "\" And SourcePtr + 1 <= SourceLen And
           Mid(SourceString, SourcePtr + 1, 1) = "x"
          SourcePtr + 2 ; Überspringe "\x"
          Continue
        EndIf
        If Mid(SourceString, SourcePtr, 1) <> Mid(SearchString, SearchIndex, 1)
          MatchPossible = #False
          Break
        EndIf
        SourcePtr + 1
        SearchIndex + 1
      Wend
      If MatchPossible And SearchIndex > SearchLen
        ProcedureReturn CurrentSourcePos ; Übereinstimmung gefunden
      EndIf
    EndIf
    CurrentSourcePos + 1
  Wend
  ProcedureReturn 0 ; Nichts gefunden
EndProcedure

Procedure WeiterSuchen(EventType)
  Protected zelle.s
  If textsuchen.s
    Repeat
      zelle.s = GetGadgetItemText(#ListView, zeilensuchen.l, #Spalte_DATA)
      zelle.s = ConvertHexToEscapedAscii(zelle.s)
      zeilensuchen.l + 1
    Until FindStringIgnoringBackslashX(zelle.s, textsuchen.s) Or
          (zeilensuchen.l > CountGadgetItems(#ListView))
    If zeilensuchen.l > CountGadgetItems(#ListView)
      MessageRequester("Warnung", "String nicht gefunden!")
    Else
      MessageRequester("Gefunden", "String gefunden in Zeile " + Str(zeilensuchen.l))
      SetGadgetState(#ListView, zeilensuchen.l-1) ; Zeile ins Blickfeld holen
      ;funktioniert noch nicht:
      SetGadgetItemState(#ListView, zeilensuchen.l-1, #PB_ListIcon_Selected) ;Zeile selektieren
    EndIf
  EndIf
EndProcedure

Procedure Suchen(EventType)
  textsuchen.s = InputRequester("Textsuche", "Zu suchende Phrase eingeben:",
                                "", 0, Window_0)
  If textsuchen.s
    zeilensuchen.l = 0
    WeiterSuchen(0)
  EndIf
EndProcedure

Procedure Hilfe(Event)
  RunProgram("https://github.com/Chregu73/HEXadezimaler/blob/main/README.md")
EndProcedure

Procedure Ueber(Event)
  MessageRequester("Über",
                   "HEXadezimaler Version " + #Version$ + #CRLF$ +
                   "Einfaches Programm zum Editieren von Intel-HEX-Dateien" + #CRLF$ +
                   #Datum$ + " von Chregu Müller" + #CRLF$ +
                   "eMail: chregu@vtxmail.ch",
                   #PB_MessageRequester_Ok | #PB_MessageRequester_Info)
EndProcedure

Procedure Beenden(EventType)
  Event = #PB_Event_CloseWindow
EndProcedure

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 193
; FirstLine = 176
; Folding = -----
; EnableXP
; DPIAware