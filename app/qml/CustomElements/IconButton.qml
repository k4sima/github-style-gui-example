import QtQuick
import QtQuick.Controls

Button {
    id: iconButton
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
    
    //readonly property string color: String.fromCodePoint(0xE790) 
    //readonly property string wifi: String.fromCodePoint(0xE701)
    

    font.family: "Segoe Fluent Icons"

    property real font_scale: 0.3

    property alias color: contentitem.color
    property alias background_color: background.color

    property alias radius: background.radius

    Component.onCompleted: {
        contentItem.font.fontSizeMode = Text.Fit
        contentItem.font.pointSize = height*font_scale
    }

    contentItem: IconLabel {
        id: contentitem
        spacing: iconButton.spacing
        mirrored: iconButton.mirrored
        display: iconButton.display

        icon: iconButton.icon
        text: iconButton.text
        font: iconButton.font
        color: Color.blend(iconButton.checked || iconButton.highlighted ? iconButton.palette.brightText : iconButton.palette.midlight,
                                                                    iconButton.palette.buttonText,  iconButton.hovered ? iconButton.down ? 0.7 : 1.0 : 0.0)
    }

    background: Rectangle {
        id: background
        implicitWidth: 100
        implicitHeight: 40
        visible: !iconButton.flat || iconButton.down || iconButton.checked || iconButton.highlighted
        color: Color.blend(iconButton.checked || iconButton.highlighted ? iconButton.palette.dark : iconButton.palette.button,
                                                                    iconButton.palette.mid,  iconButton.hovered ? iconButton.down ? 0.7 : 1.0 : 0.0)
        border.color: iconButton.palette.highlight
        border.width: iconButton.visualFocus ? 2 : 0
    }
}

