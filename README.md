# Intel-HEX Editor "HEXadezimaler"

![](HEXadezimaler_W10.png)

Erste rudimentäre Version, erstellt mit PureBasic [PureBasic](https://www.purebasic.com/)\
Für Windows

## Anleitung

HEXadezimaler.exe starten

HEX-File laden mit "Öffnen..."

1. Spalte (ZN/SC): Zeilennummer und Startcode (:)
2. Spalte (BC): Datenlänge
3. Spalte: Adresse
4. Spalte: Datensatztyp
5. Spalte: Datenfeld
6. Spalte (PS): Prüfsumme

Mit Rechtsklick auf eine Zelle können die entsprechenden Daten angezeigt/bearbeitet werden. Momentan wird die Bearbeitung nur im Datenfeld (manuell) und der Prüfsumme (automatisch) unterstützt.

### Datenfeld

Bei Rechtsklick erscheint ein Fenster zum Bearbeiten. Der HEX-Code kann im Eingabefeld bearbeitet und mit "OK" übernommen werden. "Cancel" verlässt das Fenster ohne die Daten zu ändern. Achtung: Eine Validierung findet nicht statt!
Mit Rechtsklick ins Eingabefeld kann die Ansicht zwischen "Hexadezimal" und "Ansii" umgeschaltet werden. Die Ansii-Ansicht ist für nicht-druckbare Zeichen im "Escaped Ascii"-Format: \x[zweistellige Hexadezimalzahl], während druckbare Zeichen normal als Text dargestellt werden.

### Prüfsumme

Bei Rechtsklick erscheint ein Fenster. Mit "OK" wird die Prüfsumme neu berechnet. "Cancel" verlässt das Fenster ohne die Daten zu ändern.

### Suchfunktion

Im Menu "Bearbeiten/Suchen..." kann nach Text gesucht werden. Dazu wird intern im "Escaped Ascii"-Format gesucht und bei Übereinstimmung die entsprechende Zeile markiert. "Weitersuchen" oder "F3" markiert die nächste Fundstelle.

### Speichern

Momentan wird nur "Speichern unter..." unterstützt.
