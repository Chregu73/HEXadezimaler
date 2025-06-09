# Intel-HEX Editor "HEXadezimaler"

![](HEXadezimaler_W10.png)

Version 1.01, erstellt am 9. Juni 2025 mit [PureBasic](https://www.purebasic.com/)\
Compiliert für Windows x86 und x64. Kann auch für Linux und OS X kompiliert werden!

## Anleitung

HEXadezimaler.exe starten

HEX-File laden mit "Öffnen..."

1. Spalte (ZN/SC): Zeilennummer und Startcode (:)
2. Spalte (BC): Datenlänge
3. Spalte: Adresse
4. Spalte: Datensatztyp
5. Spalte: Datenfeld
6. Spalte (PS): Prüfsumme

Mit Rechtsklick oder Doppelklick auf eine Zelle können die entsprechenden Daten angezeigt/bearbeitet werden. Momentan wird die Bearbeitung der Datenlänge, der Adresse, des Datensatztyps, des Datenfelds (manuell) und der Prüfsumme (automatisch) unterstützt.

### Zeilennummer und Startcode

Die Zeilennummer ist rein informativ und hat keinen Einfluss auf das HEX-File! Der Startcode ist fix und kann nicht geändert werden.

### Datensatztyp

Bei Klick erscheint ein Fenster zum Bearbeiten. Der Typ kann den Checkboxen bearbeitet und mit "OK" übernommen werden. Es findet eine automatische Anpassung der Felder "Datenlänge" und "Datenfeld" statt! "Cancel" verlässt das Fenster ohne die Daten zu ändern.

### Datenfeld

Bei Klick erscheint ein Fenster zum Bearbeiten. Der HEX-Code kann im Eingabefeld bearbeitet und mit "OK" übernommen werden. "Cancel" verlässt das Fenster ohne die Daten zu ändern. Die Eingabe wird validiert!
Mit Rechtsklick ins Eingabefeld kann die Ansicht zwischen "Hexadezimal" und "Ansii" umgeschaltet werden. Die Ansii-Ansicht ist für nicht-druckbare Zeichen im "Escaped Ascii"-Format: \x[zweistellige Hexadezimalzahl], während druckbare Zeichen normal als Text dargestellt werden.

### Prüfsumme

Bei Klick erscheint ein Fenster. Mit "OK" wird die Prüfsumme neu berechnet. "Cancel" verlässt das Fenster ohne die Daten zu ändern.

### Suchfunktion

Im Menu "Bearbeiten/Suchen..." kann nach Text gesucht werden. Dazu wird intern im "Escaped Ascii"-Format gesucht, die Kombination "\x" ausgeblendet und bei Übereinstimmung die entsprechende Zeile ~~markiert~~ angegeben. "Weitersuchen" ~~oder "F3"~~ markiert die nächste Fundstelle.

### Speichern

Bei "Speichern unter..." bitte Dateiendung angeben! "Speichern" überschreibt die Datei ohne Warnung! Die Datei wird immer mit CR/LF am Zeilenende gespeichert!
