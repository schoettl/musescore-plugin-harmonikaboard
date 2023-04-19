import QtQuick 2.9
import QtQuick.Controls 2.2

Row {
    id: harmonicaButtonRow

    spacing: 4 // determines spacing between rows

    property alias rowText: rowText.text
    property alias model: repeater.model

    signal buttonClicked(int pitch)

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width:  70
        height: 20

        color: "lightgrey"

        Text {
            id: rowText
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 15
            fontSizeMode: Text.Fit
            text: "4th row"
        }
    }

    // Just a spacer item between the row label and row buttons
    Item {
        width: 20
        height: 45
    }

    Repeater {
        id: repeater

        delegate: HarmonicaButton {
            color: model.color
            text: model.text
            onClicked: harmonicaButtonRow.buttonClicked(model.pitch)
        }
    }
}
