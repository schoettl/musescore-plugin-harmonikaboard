import MuseScore.Dock 1.0 as MUDock

MUDock.DockPanelView {
    id: dockPanelView

    property var root: null
    property var mscore: null
    readonly property var harmonikaboard: harmonikacomponent

    objectName: pluginPanelObjectName
    title: "HarmonikaKeyboard"

    height: harmonikacomponent.implicitHeight
    minimumHeight: root.horizontalPanelMinHeight
    maximumHeight: root.horizontalPanelMaxHeight

    groupName: root.horizontalPanelsGroup

    visible: false

    location: MUDock.Location.Bottom

    dropDestinations: root.horizontalPanelDropDestinations
    navigationSection: root.navigationPanelSec(dockPanelView.location)

    HarmonikaboardComponent {
        id: harmonikacomponent
        anchors.fill: parent
        mscore: dockPanelView.mscore
    }
}
