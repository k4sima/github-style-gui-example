import QtQuick
import QtQuick.Controls

Item {
    default property alias content: cont.children

    property alias color: drawer.color
    property alias border_color: drawer.border.color
    property alias border_width: drawer.border.width

    property bool opened: false

    property bool vertical:true
    property bool invert:false
    property real closeScale: 0.05
    property real openScale: 0.4

    property int duration: 300
    

    state: "close"


    property real closeWidth: vertical ? width*closeScale : height*closeScale
    property real openWidth: vertical ? width*openScale : height*openScale
    Rectangle {
        id: drawer

        color: "transparent"
        border.color: "black"
        border.width: 0

        anchors {
            top: vertical || (!vertical && !invert) ? parent.top : undefined
            bottom: vertical || (!vertical && invert) ? parent.bottom : undefined
            left: !vertical || (vertical && !invert) ? parent.left : undefined
            right: !vertical || (vertical && invert) ? parent.right : undefined
        }

        Item { id:cont; anchors.fill:parent; clip:true }  
    }

   

    function restore() {
        if (opened) {
            opened = false
        } else {
            opened = true
        }
    }

    states: [
        State {
            name: "open"
            when: opened
            PropertyChanges { 
                target: drawer
                width: vertical ? openWidth : undefined
                height: vertical ? undefined : openWidth
            }
        },
        State {
            name: "close"
            when: !opened
            PropertyChanges { 
                target: drawer
                width: vertical ? closeWidth : undefined
                height: vertical ? undefined : closeWidth
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "width,height"
                easing.type: Easing.OutQuad
                duration: duration
            }
        }
    ]
}