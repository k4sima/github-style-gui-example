import QtQuick

Rectangle {
    id: blackout

    property bool fade: false
    property real fade_opacity: 0.4

    property int duration: 200

    state: "disable"

    color: "black"

    enabled: opacity>0 ? true : false


    states: [
        State {
            name: "enable"
            when: fade
            PropertyChanges { 
                target: blackout
                opacity: fade_opacity
            }
        },
        State {
            name: "disable"
            when: !fade
            PropertyChanges { 
                target: blackout
                opacity: 0
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "opacity"
                easing.type: Easing.OutQuad
                duration: duration
            }
        }
    ]
    
    //z:1
}