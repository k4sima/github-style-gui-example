import QtQuick
import QtQuick.Controls

MenuBar {
    property bool popped : false

    height: parent.height

    delegate: MenuBarItem { 
        implicitHeight: parent.height
        onTriggered: popped = true
    }
    background: Rectangle {
        implicitHeight: parent.height
        color: parent.palette.button
    }
}