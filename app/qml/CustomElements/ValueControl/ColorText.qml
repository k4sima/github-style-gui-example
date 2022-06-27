import QtQuick
import QtQuick.Controls

Row {
    id: root

    property alias text: textField.text 
    property alias subText: textField.placeholderText 

    property real textWidth: parent.width - colorRect.width

    TextField { id: textField
        width: textWidth
    }
    
    Rectangle {
        id: colorRect
        width: height
        height: textField.height
        color: text
        
        MouseArea {
            anchors.fill: parent
            onClicked: print("[ColorText] clicked")
        }
    }
    // CustomToolTip{ visible: mouseArea.containsMouse }
}