import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import ".."

Row {
    id: root

    property alias text: textField.text 
    property alias subText: textField.placeholderText

    property real textWidth: parent.width - button.width

    TextField {
        id: textField

        width: textWidth
    
        Connections {
            target: filetext_fileDialog
            function onAccepted() {
                text = filetext_fileDialog.filePath
            }
        }
    }

    
    IconButton {
        id: button

        width: height
        height: textField.height
        text: fileExplorer
        background_color: "transparent"

        onClicked: filetext_fileDialog.openFileDialog({fileMode: FileDialog.OpenFile}) 
    }

    CustomFileDialog {id: filetext_fileDialog}
}