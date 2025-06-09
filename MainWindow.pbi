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
  #MenuNeuDurchnummerieren
  #MenuSuchen
  #MenuWeitersuchen
  #MenuHilfe
  #MenuUeber
  #ListView
EndEnumeration

#MenuAktiviert = 0
#MenuDesaktiviert = 1
;#TAB$

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
Declare NeuDurchnummerieren(Event)
Declare Hilfe(Event)
Declare Ueber(Event)

Procedure OpenWindow_0(x, y, breite, hoehe)
  Global Window_0 = OpenWindow(#PB_Any, x, y, breite, hoehe, "HEXadezimaler V" + #Version$,
                               #PB_Window_SystemMenu |
                               #PB_Window_SizeGadget)
  CreateMenu(0, WindowID(Window_0))
  MenuTitle("Datei")
  MenuItem(#MenuNeu, "Neu" + #TAB$ + "Strg+N")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_N, #MenuNeu)
  MenuItem(#MenuOeffnen, "Öffnen..." + #TAB$ + "Strg+O")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_O, #MenuOeffnen)
  MenuItem(#MenuSpeichern, "Speichern" + #TAB$ + "Strg+S")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_S, #MenuSpeichern)
  MenuItem(#MenuSpeichernUnter, "Speichern unter..." + #TAB$ + "Strg+Alt+S")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_Alt |
                                #PB_Shortcut_S, #MenuSpeichernUnter)
  MenuItem(#MenuExportieren, "Exportieren..." + #TAB$ + "Strg+E")
  DisableMenuItem(0, #MenuExportieren, #MenuDesaktiviert)
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_E, #MenuExportieren)
  MenuBar()
  MenuItem(#MenuBeenden, "Beenden" + #TAB$ + "Alt+F4")
  MenuTitle("Bearbeiten")
  MenuItem(#MenuZeileLoeschen, "Zeile Löschen" + #TAB$ + "Entf")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Delete, #MenuZeileLoeschen)
  MenuItem(#MenuZeileEinfuegen, "Zeile unterhalb einfügen" + #TAB$ + "Einfg")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Insert, #MenuZeileEinfuegen)
  MenuItem(#MenuNeuDurchnummerieren, "Neu Durchnummerieren")
  MenuBar()
  MenuItem(#MenuSuchen, "Suchen..." + #TAB$ + "Strg+F")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_Control | #PB_Shortcut_F, #MenuSuchen)
  MenuItem(#MenuWeitersuchen, "Weitersuchen" + #TAB$ + "F3")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_F3, #MenuWeitersuchen)
  MenuTitle("Hilfe")
  MenuItem(#MenuHilfe, "Hilfe..." + #TAB$ + "F1")
  AddKeyboardShortcut(Window_0, #PB_Shortcut_F1, #MenuHilfe)
  MenuItem(#MenuUeber, "Über")
EndProcedure

Procedure Window_0_Events(event)
  Select event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
    Case #PB_Event_SizeWindow
      Listview_Anpassen(WindowWidth(Window_0)-10, WindowHeight(Window_0)-30)
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
        Case #MenuNeuDurchnummerieren
          NeuDurchnummerieren(EventMenu())
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
; CursorPosition = 61
; FirstLine = 31
; Folding = -
; EnableXP
; DPIAware