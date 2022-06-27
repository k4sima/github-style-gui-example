import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "CustomElements"

TopMenuBar {
    Component.onCompleted: {
        for (var m in menus){
            console.info("[TopMenuBar]", menus[m]["title"])
        }
    }

    /* -------------------------------------------------------------------------- */
    Component {
        id: about_dialog
        Label{
            text: "made by <a href=\"https://github.com/k4sima\">k4sima</a>"
            font.pixelSize: 20; font.bold: true
            padding: 24
            onLinkActivated: (link)=>console.debug("onLinkActivated:", link)
        }
    }

    Component {
        id: settings_dialog
      
        Settings { }
    }
    /* -------------------------------------------------------------------------- */

    Menu { // File
        title: qsTr("File")

        Action { 
            text: qsTr("Settings")
            onTriggered:{ dialog.openComponent(settings_dialog, {title:text}); popped=true }
        }
        MenuSeparator {/*区切り線*/ }
        Action { text: qsTr("Quit"); onTriggered:window.close() }
    }

    Menu { // Help
        title: qsTr("Help")

         Action { 
            text: qsTr("About")
            onTriggered:{ dialog.openComponent(about_dialog, {title:text}); popped=true }
        }
    }
}