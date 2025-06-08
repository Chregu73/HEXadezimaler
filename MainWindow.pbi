Global Window_0

Enumeration FormMenu
  #MenuNeu
  #MenuOeffnen
  #MenuSpeichern
  #MenuSpeichernUnter
  #MenuExportieren
  #MenuBeenden
  #MenuZeileLoeschen
  #MenuZeileEinfuegen
  #MenuSuchen
  #MenuWeitersuchen
  #MenuHilfe
  #MenuUeber
  #ListView
EndEnumeration

#MenuAktiviert = 0
#MenuDesaktiviert = 1

Declare SaveAsFile(Event)
Declare Beenden(Event)
Declare test2(Event)
Declare LoadFile(Event)
Declare WeiterSuchen(Event)
Declare Suchen(Event)
Declare Listview_Anpassen(breite, hoehe)
Declare SafeFile(Event)
Declare NeueTabelle(Event)
Declare ZeileLoeschen(Event)
Declare ZeileEinfuegen(Event)
Declare Hilfe(Event)
Declare Ueber(Event)

Procedure OpenWindow_0(x, y, breite, hoehe)
  Global Window_0 = OpenWindow(#PB_Any, x, y, breite, hoehe, "Hexadezimaler",
                               #PB_Window_SystemMenu |
                               #PB_Window_SizeGadget)
  CreateMenu(0, WindowID(Window_0))
  MenuTitle("Datei")
  MenuItem(#MenuNeu, "Neu" + Chr(9) + "Strg+N")
  MenuItem(#MenuOeffnen, "Öffnen..." + Chr(9) + "Strg+O")
  MenuItem(#MenuSpeichern, "Speichern" + Chr(9) + "Strg+S")
  MenuItem(#MenuSpeichernUnter, "Speichern unter..." + Chr(9) + "Strg+Alt+S")
  MenuItem(#MenuExportieren, "Exportieren..." + Chr(9) + "Strg+E")
  DisableMenuItem(0, #MenuExportieren, #MenuDesaktiviert)
  MenuBar()
  MenuItem(#MenuBeenden, "Beenden" + Chr(9) + "Alt+F4")
  MenuTitle("Bearbeiten")
  MenuItem(#MenuZeileLoeschen, "Zeile Löschen")
  MenuItem(#MenuZeileEinfuegen, "Zeile unterhalb einfügen")
  MenuBar()
  MenuItem(#MenuSuchen, "Suchen..." + Chr(9) + "Strg+F")
  MenuItem(#MenuWeitersuchen, "Weitersuchen" + Chr(9) + "F3")
  MenuTitle("Hilfe")
  MenuItem(#MenuHilfe, "Hilfe..." + Chr(9) + "F1")
  MenuItem(#MenuUeber, "Über" + Chr(9) + "F3")
EndProcedure

Procedure Window_0_Events(event)
  Select event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
    Case #PB_Event_SizeWindow
      Listview_Anpassen(WindowWidth(Window_0)-10,
                        WindowHeight(Window_0)-30)
    Case #PB_Event_Menu
      Select EventMenu()
        Case #MenuNeu
          NeueTabelle(EventMenu())
        Case #MenuOeffnen
          LoadFile(EventMenu())
        Case #MenuSpeichern
          SafeFile(EventMenu())
        Case #MenuSpeichernUnter
          SaveAsFile(EventMenu())
        Case #MenuExportieren
          ;noch nichts
        Case #MenuBeenden
          Beenden(EventMenu())
        Case #MenuZeileLoeschen
          ZeileLoeschen(EventMenu())
        Case #MenuZeileEinfuegen
          ZeileEinfuegen(EventMenu())
        Case #MenuSuchen
          Suchen(EventMenu())
        Case #MenuWeitersuchen
          WeiterSuchen(EventMenu())
        Case #MenuHilfe
          Hilfe(EventMenu())
        Case #MenuUeber
          Ueber(EventMenu())
      EndSelect
    Case #PB_Event_Gadget
      Select EventGadget()
      EndSelect
  EndSelect
  ProcedureReturn #True
EndProcedure

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 34
; Folding = -
; EnableXP
; DPIAware