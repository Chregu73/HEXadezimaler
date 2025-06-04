Global zeilennummer.l, zeilensuchen.l, textsuchen.s, datei.s, Event

#WM_RBUTTONDOWN = 516

XIncludeFile "MainWindow.pbf" ;Einbinden der ersten Fenster-Definition
XIncludeFile "Listview.pbi"
XIncludeFile "MainFunktionen.pbi"

OpenWindow_0() ;Öffnet das erste Fenster. Dieser Prozedurname ist immer 'Open' gefolgt vom Fensternamen.
Zeichne_Listview()


;Die übliche Haupt-Ereignisschleife, die einzige Änderung ist der automatische Aufruf der
;für jedes Fenster generierten Ereignis-Prozedur.
Repeat
  Event = WaitWindowEvent()

  Select EventWindow()
    Case Window_0
      Window_0_Events(Event)

    If Event = #WM_RBUTTONDOWN
      Listview_Rechtsklick() ;im ListView
    EndIf

  EndSelect
  
Until Event = #PB_Event_CloseWindow ;Beenden, wenn eines der Fenster geschlossen wird.
Vernichte_Listview()

; IDE Options = PureBasic 6.20 (Windows - x86)
; CursorPosition = 11
; EnableXP
; DPIAware