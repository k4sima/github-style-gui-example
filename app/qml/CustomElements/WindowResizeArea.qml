import QtQuick

Item{
    id:control
    property Window targetWindow

    property int margin: 1 //
    property int topMargin: margin
    property int bottomMargin: margin
    property int leftMargin: margin
    property int rightMargin: margin

    property bool showAreaColor: false

    MouseArea {
        id: resizeLeft
        width: control.leftMargin
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            bottomMargin: control.bottomMargin
            topMargin: control.topMargin
        }

        cursorShape: Qt.SizeHorCursor
        onPressed: targetWindow.startSystemResize(Qt.LeftEdge)

        Rectangle{anchors.fill:parent; color: "#33ff0000"; visible: control.showAreaColor}
    }
    MouseArea {
        id: resizeRight
        width: control.rightMargin
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            bottomMargin: control.bottomMargin
            topMargin: control.topMargin
        }

        cursorShape: Qt.SizeHorCursor
        onPressed: targetWindow.startSystemResize(Qt.RightEdge)

        Rectangle{anchors.fill:parent; color: "#33ff0000"; visible: control.showAreaColor}
    }
    MouseArea {
        id: resizeTop
        height: control.topMargin
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            rightMargin: control.rightMargin
            leftMargin: control.leftMargin
        }

        cursorShape: Qt.SizeVerCursor
        onPressed: targetWindow.startSystemResize(Qt.TopEdge)

        Rectangle{anchors.fill:parent; color: "#33ff0000"; visible: control.showAreaColor}
    }
    MouseArea {
        id: resizeBottom
        height: control.bottomMargin
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            rightMargin: control.rightMargin
            leftMargin: control.leftMargin
        }

        cursorShape: Qt.SizeVerCursor
        onPressed: targetWindow.startSystemResize(Qt.BottomEdge)

        Rectangle{anchors.fill:parent; color: "#33ff0000"; visible: control.showAreaColor}
    }

}