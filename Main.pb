Global zeilennummer.l, zeilensuchen.l, textsuchen.s, datei.s, Event

#WM_RBUTTONDOWN = 516
#Version$       = "1.01"
#Datum$         = "9. Juni 2025"

XIncludeFile "MainWindow.pbi"
XIncludeFile "MainFunktionen.pbi"

OpenPreferences("HEXadezimaler.ini")
;Öffnet Fenster aus MainWindows.pbi
OpenWindow_0(ReadPreferenceInteger("Fensterposition X", 100),
             ReadPreferenceInteger("Fensterposition Y", 100),
             ReadPreferenceInteger("Fenstergroesse X", 400),
             ReadPreferenceInteger("Fenstergroesse Y", 200))
Zeichne_Listview(WindowWidth(Window_0)-10,
                 WindowHeight(Window_0)-30,
                 ReadPreferenceInteger("Spalte 0", 72),
                 ReadPreferenceInteger("Spalte 1", 32),
                 ReadPreferenceInteger("Spalte 2", 64),
                 ReadPreferenceInteger("Spalte 3", 40),
                 ReadPreferenceInteger("Spalte 4", 376),
                 ReadPreferenceInteger("Spalte 5", 32))
ClosePreferences()
NeueTabelle(0)

Repeat
  Event = WaitWindowEvent()
  Select EventWindow()
    Case Window_0
      Window_0_Events(Event)
      ;If Event = #WM_RBUTTONDOWN
      If EventGadget() = #ListView And EventType() = #PB_EventType_RightClick
        Listview_Rechtsklick(#PB_EventType_RightClick) ;im ListView
      EndIf
      If EventGadget() = #ListView And EventType() = #PB_EventType_LeftDoubleClick
        Listview_Rechtsklick(#PB_EventType_LeftDoubleClick) ;im ListView
      EndIf
      
  EndSelect
Until Event = #PB_Event_CloseWindow ;Beenden, wenn eines der Fenster geschlossen wird.
Speichere_Preferences()
End

; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 38
; EnableXP
; DPIAware
; UseIcon = Hex2.ico
; Executable = HEXadezimaler (x86).exe