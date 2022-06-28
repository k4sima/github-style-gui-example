import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:/CoreQml"

Item {
    Rectangle {
        anchors.fill: parent
        color: sideMenu.opened ? palette.dark : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: sideMenu.duration*0.3
            }
        }
    }

    ColumnLayout {
        id: leftMenu
        width: sideMenu.closeWidth
        anchors.bottom: parent.bottom

        // Layout.margins: 0
        
        /*Button{           
            text: "Open"
            Layout.fillWidth: true
            onClicked: sideMenu.opened=true
        }
        Button{             
            text: "Close"
            Layout.fillWidth: true
            onClicked: sideMenu.opened=false
        }*/
        IconButton {      
            width: sideMenu.closeWidth      
            background_color: "transparent"
            
            text: exploitProtection
            Layout.fillWidth: true
            font.pointSize: 50

            onClicked: sideMenu.restore()
        }
    }

    Rectangle {
        color: palette.shadow  

        anchors {
            right: parent.right
            left:leftMenu.right
            top: parent.top
            bottom: parent.bottom
        }   
       
        Label {
            clip: true
            text: "Drawer"
            font.pointSize: 60
        }
    }
}