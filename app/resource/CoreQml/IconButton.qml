import QtQuick
import QtQuick.Controls

Button {
    id: root
    // hovered background color: palette.mid
    // background color: palette.button (?)

    // text(icon) color: palette.buttonText
    // hovered text(icon) color: palette.midlight


    FontLoader { source: "qrc:/font/Segoe Fluent Icons.ttf" }

    readonly property string chromeClose: String.fromCodePoint(0xE8bb)
    readonly property string chromeMinimize: String.fromCodePoint(0xE921)
    readonly property string chromeMaximize: String.fromCodePoint(0xE922)
    readonly property string chromeRestore: String.fromCodePoint(0xE923)
   
    readonly property string settings: String.fromCodePoint(0xE713)
    readonly property string save: String.fromCodePoint(0xE74E)
    readonly property string saveAs: String.fromCodePoint(0xE792)
    readonly property string fileExplorer: String.fromCodePoint(0xEC50)
    readonly property string exploitProtection: String.fromCodePoint(0xF8a6)
    
    readonly property string chevronDown: String.fromCodePoint(0xE70D)
    readonly property string chevronUp: String.fromCodePoint(0xE70E)
   
    
    //readonly property string color: String.fromCodePoint(0xE790) 
    //readonly property string wifi: String.fromCodePoint(0xE701)
    
    // font
    font.family: "Segoe Fluent Icons"
    property real font_scale: 0.3

    // color animation
    property int duration: 120
    property int easing: Easing.Linear

    // color
    property alias color: contentitem.color
    property alias background_color: background.color
    property alias background_opacity: background.opacity

    property alias radius: background.radius

    Component.onCompleted: {
        contentItem.font.fontSizeMode = Text.Fit
        contentItem.font.pointSize = height*font_scale
    }

    contentItem: IconLabel {
        id: contentitem
        spacing: root.spacing
        mirrored: root.mirrored
        display: root.display

        icon: root.icon
        text: root.text
        font: root.font
        color: Color.blend(root.checked || root.highlighted ? root.palette.brightText : root.palette.midlight,
                                                                    root.palette.buttonText,  root.hovered ? root.down ? 0.7 : 1.0 : 0.0)

        Behavior on color {
            ColorAnimation { duration:root.duration; easing.type:root.easing }
        }                                                              
    }

    background: Rectangle {
        id: background
        implicitWidth: 100
        implicitHeight: 40
        visible: !root.flat || root.down || root.checked || root.highlighted
        color: Color.blend(root.checked || root.highlighted ? root.palette.dark : root.palette.button,
                                                                    root.palette.mid,  root.hovered ? root.down ? 0.7 : 1.0 : 0.0)
        border.color: root.palette.highlight
        border.width: root.visualFocus ? 2 : 0

        Behavior on color {
            ColorAnimation { duration:root.duration; easing.type:root.easing }
        }  
    }
}

