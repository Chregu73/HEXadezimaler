Global ListViewLibraryHandle.l, ListViewHandle.l, ListViewFont.l

ListViewLibraryHandle = OpenLibrary(#PB_Any, "Listview.dll")
;32 bit Library, geht nur mit 32bit Version von PB

Procedure Zeichne_Listview()
  MischFarbe.l = CallFunction(ListViewLibraryHandle.l, "MixRGBs", GetSysColor_(#COLOR_WINDOW), $ffffffff)  
  MischFarbe.l = RGB(233, 231, 227)
  ListViewHandle.l = CallFunction(ListViewLibraryHandle.l, "CreateListview", GadgetID(Frame_0), 0, 0, MischFarbe.l, -1, $00000025)
  CallFunction(ListViewLibraryHandle.l, "EnableEdits", ListViewHandle.l, 1)
  
  ListViewFont.l = LoadFont(#PB_Any, "Lucida Console", 8)
  If ListViewFont.l
    ;Funktioniert (noch) nicht:
    ;Weder die Einte noch die Andere Variante
    ;Debug(SetGadgetFont(ListViewHandle.l, FontID(ListViewFont.l)))
    ;Debug(SetGadgetFont(ListViewHandle.l, ListViewFont.l))
    ;das geht aber:
    SendMessage_(ListViewHandle,#WM_SETFONT,FontID(ListViewFont.l),1)
  EndIf
  
  *Ascii = Ascii("ZN/SC")
  CallFunction(ListViewLibraryHandle.l, "IColumn", ListViewHandle.l, *Ascii, 72, 1)
  *Ascii = Ascii("BC")
  CallFunction(ListViewLibraryHandle.l, "IColumn", ListViewHandle.l, *Ascii, 32, 2)
  *Ascii = Ascii("Adresse")
  CallFunction(ListViewLibraryHandle.l, "IColumn", ListViewHandle.l, *Ascii, 64, 1)
  *Ascii = Ascii("Typ")
  CallFunction(ListViewLibraryHandle.l, "IColumn", ListViewHandle.l, *Ascii, 40, 2)
  *Ascii = Ascii("Datenfeld")
  CallFunction(ListViewLibraryHandle.l, "IColumn", ListViewHandle.l, *Ascii, 376, 0)
  *Ascii = Ascii("PS")
  CallFunction(ListViewLibraryHandle.l, "IColumn", ListViewHandle.l, *Ascii, 32, 2)
  
  ;geht nur eine Spalte:
;   *Ascii = Ascii("100000")
;   CallFunction(ListViewLibraryHandle.l, "RaiseColumns", ListViewHandle.l, *Ascii, 0, RGB($FF, $FF, $CC))
;   *Ascii1 = Ascii("010000")
;   CallFunction(ListViewLibraryHandle.l, "RaiseColumns", ListViewHandle.l, *Ascii1, 0, RGB($66, $FF, $CC))
;   *Ascii = Ascii("001000")
;   CallFunction(ListViewLibraryHandle.l, "RaiseColumns", ListViewHandle.l, *Ascii, 0, RGB($CC, $CC, $FF))
;   *Ascii = Ascii("000100")
;   CallFunction(ListViewLibraryHandle.l, "RaiseColumns", ListViewHandle.l, *Ascii, 0, RGB($00, $00, $FF))
;   *Ascii = Ascii("000010")
;   CallFunction(ListViewLibraryHandle.l, "RaiseColumns", ListViewHandle.l, *Ascii, 0, RGB($CC, $FF, $FF))
;   *Ascii = Ascii("000001")
;   CallFunction(ListViewLibraryHandle.l, "RaiseColumns", ListViewHandle.l, *Ascii, 0, RGB($FF, $99, $99))

  *Ascii = Ascii("background.bmp")
  CallFunction(ListViewLibraryHandle.l, "SetBackImage", ListViewHandle.l, *Ascii, 1)
  *Ascii = Ascii("010110")
  CallFunction(ListViewLibraryHandle.l, "SelectColumnEdits", ListViewHandle.l, *Ascii)

  CallFunction(ListViewLibraryHandle.l, "ShowListview", ListViewHandle.l, 0, 0, 640, 450)
  CallFunction(ListViewLibraryHandle.l, "EnableEdits", ListViewHandle.l, 1+4)
  CallFunction(ListViewLibraryHandle.l, "InitMessages", GadgetID(Frame_0))
  CallFunction(ListViewLibraryHandle.l, "SetColumnAlignment", ListViewHandle.l, 0, 1)
  FreeMemory(*Ascii)
EndProcedure

Procedure Vernichte_Listview()
  ;Muss zuerst stehen, sonst gibt's eine Speicherverletzung,
  ;wenn zuletzt eine Zeile im Listview aktiviert war:
  FreeGadget(Frame_0)   
  CallFunction(ListViewLibraryHandle.l, "ClearListview", ListViewHandle.l)
  CallFunction(ListViewLibraryHandle.l, "EraseListview", ListViewHandle.l)
  ;CallFunction(ListViewLibraryHandle.l, "CloseMessages", GadgetID(Frame_0))
EndProcedure

Procedure Neue_Zeile(sc.s, bc.s, ad.s, tp.s, df.s, ps.s)
  zeilennummer.l + 1
  *Ascii = Ascii(Str(zeilennummer.l) + " " + sc.s)
  *bereich = AllocateMemory(28)
  adresse1.l = *Ascii
  PokeL(*bereich, adresse1.l)
  *Ascii = Ascii(bc.s)
  adresse2.l = *Ascii
  PokeL(*bereich+4, adresse2.l)
  *Ascii = Ascii(ad.s)
  adresse3.l = *Ascii
  PokeL(*bereich+8, adresse3.l)
  *Ascii = Ascii(tp.s)
  adresse4.l = *Ascii
  PokeL(*bereich+12, adresse4.l)
  *Ascii = Ascii(df.s)
  adresse5.l = *Ascii
  PokeL(*bereich+16, adresse5.l)
  *Ascii = Ascii(ps.s)
  adresse6.l = *Ascii
  PokeL(*bereich+20, adresse6.l)
  PokeL(*bereich+24, 0)
  ;ShowMemoryViewer(*bereich, 20)
  CallFunction(ListViewLibraryHandle.l, "SItem", ListViewHandle.l, *bereich, 6)
  FreeMemory(*bereich)
  FreeMemory(*Ascii)
EndProcedure

Procedure Loesche_Listview()
  CallFunction(ListViewLibraryHandle.l, "DeleteAllItems", ListViewHandle.l)
EndProcedure

;Zeile aus ListView auslesen und nur den Intel-HEX-String zurückgeben
Procedure.s Zeile_Auslesen(zeile.l)
  *bereich = AllocateMemory(320)
  CallFunction(ListViewLibraryHandle.l, "GetLineText", ListViewHandle.l, zeile.l, *bereich)
  text.s = PeekS(*bereich, -1, #PB_Ascii)
  text.s = RemoveString(text.s, Chr(9))
  text.s = StringField(text.s, 2, " ")
  FreeMemory(*bereich)
  ProcedureReturn text.s
EndProcedure

Procedure ZelleSchreiben(spalte.l, zeile.l, NeuerText.s)
  *bereich = Ascii(NeuerText.s)
  CallFunction(ListViewLibraryHandle.l, "SetItemText", ListViewHandle.l, *bereich, spalte.l, zeile.l)
  FreeMemory(*bereich)  
EndProcedure

Procedure.s ZelleAuslesen(spalte.l, zeile.l)
  *bereich = AllocateMemory(320)
  CallFunction(ListViewLibraryHandle.l, "GetItemText", ListViewHandle.l, *bereich, spalte.l, zeile.l)
  text.s = PeekS(*bereich, -1, #PB_Ascii)
  ProcedureReturn text.s
EndProcedure

Procedure.l AnzahlZeilen()
  ProcedureReturn CallFunction(ListViewLibraryHandle.l, "GetLines", ListViewHandle.l)
EndProcedure

Procedure ZeileSelektieren(zeile.l)
  ProcedureReturn CallFunction(ListViewLibraryHandle.l, "SelectLine", ListViewHandle.l, zeile.l, 1)
EndProcedure


; IDE Options = PureBasic 6.20 (Windows - x86)
; CursorPosition = 113
; FirstLine = 82
; Folding = --
; EnableXP
; DPIAware