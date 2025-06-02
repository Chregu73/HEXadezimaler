Global zeilennummer.l, zeilensuchen.l, textsuchen.s, datei.s

#WM_RBUTTONDOWN = 516

XIncludeFile "MainWindow.pbf" ;Einbinden der ersten Fenster-Definition
XIncludeFile "Listview.pbi"
XIncludeFile "MainFunktionen.pbi"

OpenWindow_0() ;Öffnet das erste Fenster. Dieser Prozedurname ist immer 'Open' gefolgt vom Fensternamen.
Zeichne_Listview()

;Die Ereignis-Prozedur, wie diese in der Eigenschaft 'Ereignis-Prozedur' jedes Gadgets definiert wurde.
Procedure OkButtonEvent(EventType)
  Debug "OkButton event"
EndProcedure

Procedure CancelButtonEvent(EventType)
  Debug "CancelButton event"
EndProcedure

Procedure TrainCalendarEvent(EventType)
  Debug "TrainCalendar event"
EndProcedure

;Die übliche Haupt-Ereignisschleife, die einzige Änderung ist der automatische Aufruf der
;für jedes Fenster generierten Ereignis-Prozedur.
Repeat
  Event = WaitWindowEvent()

  Select EventWindow()
    Case Window_0
      Window_0_Events(Event) ;Dieser Prozedurname ist immer der Fenstername gefolgt von '_Events'

    If Event = #WM_RBUTTONDOWN
      Listview_Rechtsklick()  ;im ListView
    EndIf

  EndSelect
  
Until Event = #PB_Event_CloseWindow ;Beenden, wenn eines der Fenster geschlossen wird.
Vernichte_Listview()

; IDE Options = PureBasic 6.20 (Windows - x86)
; CursorPosition = 33
; Folding = -
; EnableXP
; DPIAware