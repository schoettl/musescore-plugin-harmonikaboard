import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: harmonicaButton

    width:  45
    height: 45
    radius: 45

    property alias text: harmonicaButtonText.text

    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: harmonicaButton.clicked()

        Text {
            id: harmonicaButtonText
            anchors.centerIn: parent
            font.pixelSize: 30
            fontSizeMode: Text.Fit
        }
    }
}
