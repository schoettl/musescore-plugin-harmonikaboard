import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.2
import MuseScore 3.0

Item {
     id: harmonikaplugin

     // Reference to the plugin, gives access to the main MuseScore plugin API.
    property var mscore: null

    implicitWidth: harmonikaView.implicitWidth
    implicitHeight: harmonikaView.implicitHeight

    QtObject {
        id: compatibility
  
        readonly property bool useApi334: mscore ? (mscore.mscoreVersion > 30303) : false // Cursor.addNote(pitch, addToChord), Cursor.prev()
        readonly property bool useApi350: mscore ? (mscore.mscoreVersion >= 30500) : false // instrument data, range selection
        readonly property bool useApi4: mscore ? (mscore.mscoreVersion >= 40000) : false
    }

     readonly property bool darkMode: Window.window ? Window.window.color.hsvValue < 0.5 : false

    QtObject {
        id: style

        readonly property color textColor: harmonikaplugin.darkMode ? "#EFF0F1" : "#333333"
        readonly property color backgroundColor: harmonikaplugin.darkMode ? "#2C2C2C" : "#e3e3e3"
    }
    property var score: null
    property var cursor: null
    property int cursorLastTick: -1
  

    function findSegment(e) {
        while (e && e.type != Element.SEGMENT)
            e = e.parent;
        return e;
    }
    
    function findSelectedChord() {
        if (!curScore)
            return null;

        var selectedElements = curScore.selection.elements;
        for (var i = 0; i < selectedElements.length; ++i) {
            var e = selectedElements[i];
            if (e.type == Element.NOTE) {
                var chord = e.parent;

                // HACK
                // removeElement(chord) may leave the chord selected,
                // so ensure this chord is really bound to a segment
                // or another chord as a grace note.
                var seg = findSegment(chord);
                var realChord = seg.elementAt(chord.track);

                if (!realChord || realChord.type != Element.CHORD)
                    return null;

                if (chord.is(realChord))
                    return chord;

                var grace = realChord.graceNotes;
                for (var i = 0; i < grace.length; ++i) {
                    if (grace[i].is(chord))
                        return chord;
                }

                return null;
            }
        }
    }

    function toggleNote(pitch) {
        if (!curScore)
            return;

        var chord = findSelectedChord();
        var existingNote = null;

        if (chord) {
            var chordNotes = chord.notes;

            for (var i = 0; i < chordNotes.length; ++i) {
                var chordNote = chordNotes[i];
                if (chordNote.pitch == pitch) {
                    existingNote = chordNote;
                    break;
                }
            }
        }
             

        curScore.startCmd();

        if (existingNote) {
            removeElement(existingNote);
        } else {
            var cursor = curScore.newCursor();
            cursor.inputStateMode = Cursor.INPUT_STATE_SYNC_WITH_SCORE;

            var addToChord = (chord != null);
            cursor.addNote(pitch, addToChord);

            cursor.prev(); // return cursor to the chord's position
        }

        curScore.endCmd();
    }

    Row {
        spacing: 10
        leftPadding: 10
         Text {
            font.pixelSize: 13
            fontSizeMode: Text.Fit
            text:
        "                                "     }

        // Pull, the Styrian Accordion //
        // Yellow keyboard, Pull //

        Rectangle {
            width: 770
            height: 280
            color: "gainsboro"

            Text {
                id: pullText
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "Bovenkant                                         Opentrekken                                Onderkant"                                    
            }
          
            Column {
                anchors.top: pullText.bottom
                leftPadding: 10

                spacing: -6 // determines spacing between rows

                HarmonicaButtonRow {
                    leftPadding: 60
                    rowText: "4de rij"

                    model: ListModel {
                        ListElement { color: "lightcoral"; text: "Eb'"; pitch: 57 }
                        ListElement { color: "violet"; text: "F'"; pitch: 60 }
                        ListElement { color: "dodgerblue";  text: "A'"; pitch: 64 }
                        ListElement { color: "lightskyblue";  text: "C''"; pitch: 67 }
                        ListElement { color: "lightcoral"; text: "Eb''"; pitch: 71 }
                        ListElement { color: "violet";  text: "F''"; pitch: 74 }
                        ListElement { color: "dodgerblue";  text: "A''"; pitch: 77 }
                        ListElement { color: "lightskyblue";  text: "C'''"; pitch: 81 }
                        ListElement { color: "lightcoral"; text: "Eb'''"; pitch: 84 }
                        ListElement { color: "limegreen";  text: "G'''"; pitch: 88 }
                    }

                    onButtonClicked: toggleNote(pitch)
                }
           
                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "              1       2      3      4       5      6      7       8       9     10"
              }
               
                HarmonicaButtonRow {
                    leftPadding: 40
                    rowText: "3de rij"

                    model: ListModel {
                        ListElement { color: "moccasin"; text: "Bb"; pitch: 55 }
                        ListElement { color: "lightskyblue"; text: "C'"; pitch: 59 }
                        ListElement { color: "lightcoral"; text: "E'"; pitch: 62 }
                        ListElement { color: "limegreen"; text: "G'"; pitch: 65 }
                        ListElement { color: "moccasin"; text: "Bb'"; pitch: 69 }
                        ListElement { color: "lightskyblue"; text: "C''"; pitch: 72 }
                        ListElement { color: "lightcoral"; text: "E''"; pitch: 76 }
                        ListElement { color: "limegreen"; text: "G''"; pitch: 79 }
                        ListElement { color: "moccasin"; text: "Bb''"; pitch: 83 }
                        ListElement { color: "gold"; text: "D'''"; pitch: 86 }
                        ListElement { color: "lightcoral"; text: "E'''"; pitch: 89 }
                    }

                    onButtonClicked: toggleNote(pitch)
                }
                
                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "           1      2      3      4       5      6      7       8       9     10     11"
              }
               
                HarmonicaButtonRow {
                    leftPadding: 20
                    rowText: "2de rij"

                    model: ListModel {
                        ListElement { color: "violet"; text: "F"; pitch: 53 }                        
                        ListElement { color: "limegreen"; text: "G"; pitch: 57 }
                        ListElement { color: "moccasin"; text: "B"; pitch: 60 }
                        ListElement { color: "gold"; text: "D'"; pitch: 64 }
                        ListElement { color: "violet"; text: "F'"; pitch: 67 }
                        ListElement { color: "limegreen"; text: "G'"; pitch: 71 }
                        ListElement { color: "moccasin"; text: "B'"; pitch: 74 }
                        ListElement { color: "gold"; text: "D''"; pitch: 77 }
                        ListElement { color: "violet"; text: "F''"; pitch: 81 }
                        ListElement { color: "dodgerblue"; text: "A''"; pitch: 84 }
                        ListElement { color: "moccasin"; text: "B''"; pitch: 88 }
                        ListElement { color: "gold"; text: "D'''"; pitch: 91 }
                    }

                    onButtonClicked: toggleNote(pitch)
                }

                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "        1      2       3      4      5      6      7       8      9     10     11     12"
              }
              
                HarmonicaButtonRow {
                    leftPadding: 0
                    rowText: "1st rij"

                    model: ListModel {
                        ListElement { color: "dodgerblue"; text: "Ab'"; pitch: 52 }
                        ListElement { color: "gold"; text: "Db''"; pitch: 55 }
                        ListElement { color: "violet"; text: "F#"; pitch: 59 }
                        ListElement { color: "dodgerblue"; text: "A"; pitch: 62 }
                        ListElement { color: "lightskyblue"; text: "C'"; pitch: 65 }
                        ListElement { color: "lightcoral"; text: "E'"; pitch: 69 }
                        ListElement { color: "violet"; text: "F#'"; pitch: 72 }
                        ListElement { color: "dodgerblue"; text: "A'"; pitch: 76 }
                        ListElement { color: "lightskyblue"; text: "C''"; pitch: 79 }
                        ListElement { color: "lightcoral"; text: "E''"; pitch: 83 }
                        ListElement { color: "violet"; text: "F#''"; pitch: 86 }
                        ListElement { color: "dodgerblue"; text: "A''"; pitch: 89 }
                        ListElement { color: "lightskyblue"; text: "C'''"; pitch: 93 }                        
                    }

                    onButtonClicked: toggleNote(pitch)
                }
                
                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "    1      2       3      4       5      6      7       8      9     10     11    12    13"
              }
            }
        }

        // Pushing, the Styrian Accordion //
        // Green Keyboard Push //

        Rectangle {
            width: 770
            height: 280
            color: "gainsboro"

            Text {
                id: pushText
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "Bovenkant                                           Dichtduwen                                 Onderkant"
            }
            
            Column {
                anchors.top: pushText.bottom
                leftPadding: 10

                spacing: -6 // determines spacing between rows

                HarmonicaButtonRow {
                    leftPadding: 60
                    rowText: "4de rij"

                    model: ListModel {
                        ListElement { color: "moccasin"; text: "Bb"; pitch: 57 } 
                        ListElement { color: "gold"; text: "D'"; pitch: 60 } 
                        ListElement { color: "violet"; text: "F'"; pitch: 64 }
                        ListElement { color: "moccasin"; text: "Bb'"; pitch: 67 }
                        ListElement { color: "gold"; text: "D''"; pitch: 71 }
                        ListElement { color: "violet"; text: "F''"; pitch: 74 }
                        ListElement { color: "moccasin"; text: "Bb''"; pitch: 77 }
                        ListElement { color: "gold"; text: "D'''"; pitch: 81 }
                        ListElement { color: "violet"; text: "F'''"; pitch: 84 }
                        ListElement { color: "moccasin"; text: "Bb'''"; pitch: 88 }
                    }

                    onButtonClicked: toggleNote(pitch)                 
                }
                
                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "              1       2      3      4       5      6      7       8       9     10"
              }

                HarmonicaButtonRow {
                    leftPadding: 40
                    rowText: "3de rij"

                    model: ListModel {
                        ListElement { color: "violet"; text: "F"; pitch: 55 }
                        ListElement { color: "dodgerblue"; text: "A"; pitch: 59 }
                        ListElement { color: "lightskyblue"; text: "C'"; pitch: 62 }
                        ListElement { color: "violet"; text: "F'"; pitch: 65 }
                        ListElement { color: "dodgerblue"; text: "A'"; pitch: 69 }
                        ListElement { color: "lightskyblue"; text: "C''"; pitch: 72 }
                        ListElement { color: "violet"; text: "F''"; pitch: 76 }
                        ListElement { color: "dodgerblue"; text: "A''"; pitch: 79 }
                        ListElement { color: "lightskyblue"; text: "C'''"; pitch: 83 }
                        ListElement { color: "violet"; text: "F'''"; pitch: 86 }
                        ListElement { color: "dodgerblue"; text: "A'''"; pitch: 89 }
                    }

                    onButtonClicked: toggleNote(pitch) 
                }
                
                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "           1      2      3      4       5      6      7       8       9     10     11"
              }

                HarmonicaButtonRow {
                    leftPadding: 20
                    rowText: "2de rij"

                    model: ListModel {
                        ListElement { color: "lightskyblue"; text: "C"; pitch: 53 }
                        ListElement { color: "lightcoral"; text: "E"; pitch: 57 }
                        ListElement { color: "limegreen"; text: "G"; pitch: 60 }
                        ListElement { color: "lightskyblue"; text: "C'"; pitch: 64 }
                        ListElement { color: "lightcoral"; text: "E'"; pitch: 67 }
                        ListElement { color: "limegreen"; text: "G'"; pitch: 71 }
                        ListElement { color: "lightskyblue"; text: "C''"; pitch: 74 }
                        ListElement { color: "lightcoral"; text: "E''"; pitch: 77 }
                        ListElement { color: "limegreen"; text: "G''"; pitch: 81 }
                        ListElement { color: "lightskyblue"; text: "C'''"; pitch: 84 }
                        ListElement { color: "lightcoral"; text: "E'''"; pitch: 88 }
                        ListElement { color: "limegreen"; text: "G'''"; pitch: 91 }
                    }

                    onButtonClicked: toggleNote(pitch)
                }
                
                Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "        1      2       3      4      5      6      7       8      9     10     11     12"
              }

                HarmonicaButtonRow {
                    leftPadding: 0
                    rowText: "1st rij"

                    model: ListModel {
                        ListElement { color: "dodgerblue"; text: "Ab'"; pitch: 52 }
                        ListElement { color: "gold"; text: "Db''"; pitch: 55 }
                        ListElement { color: "gold"; text: "D"; pitch: 59 }
                        ListElement { color: "limegreen"; text: "G"; pitch: 62 }
                        ListElement { color: "moccasin"; text: "B"; pitch: 65 }
                        ListElement { color: "gold"; text: "D'"; pitch: 69 }
                        ListElement { color: "limegreen"; text: "G'"; pitch: 72 }
                        ListElement { color: "moccasin"; text: "B'"; pitch: 76 }
                        ListElement { color: "gold"; text: "D''"; pitch: 79 }
                        ListElement { color: "limegreen"; text: "G''"; pitch: 83 }
                        ListElement { color: "moccasin"; text: "B''"; pitch: 86 }
                        ListElement { color: "gold"; text: "D'''"; pitch: 89 }
                        ListElement { color: "limegreen"; text: "G'''"; pitch: 93 }
                    }

                    onButtonClicked: toggleNote(pitch)
                    
                 }
                 
                 Text{
                leftPadding: 90
                font.pixelSize: 20
                fontSizeMode: Text.Fit
                text: "    1      2       3      4       5      6      7       8      9     10     11    12    13"
              }
            }
          }  
        }
      }

       

             
  
                   
                    
    
   
 
       