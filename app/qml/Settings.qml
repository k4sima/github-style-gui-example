import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "qrc:/CoreQml"


ColumnLayout {
    id:root

    property string currentKey: Object.keys(jsonValue)[0]

    property real maximumHeight: 400 //
    property real padding: 20 //

    property string jsonPath_env: "JSON_PATH"

    spacing: 0

    RowLayout  { 
        spacing: 0

        Layout.fillWidth: true

        Component.onCompleted: {
            dialog.standardButtons = Dialog.Apply | Dialog.Cancel
            dialog.standardButton(Dialog.Apply).DialogButtonBox.buttonRole = DialogButtonBox.InvalidRole // 押しても閉じないように

            dialog.standardButton(Dialog.Apply).clicked.connect(function(){
                jsonValue = jsonValue // signal発火(jsonValueを参照してるプロパティが更新される)
            })
        }

        ScrollView { // 左
            id: leftScroll

            rightPadding: root.padding; leftPadding: root.padding
            
            Layout.preferredHeight: maximumHeight
            Layout.fillWidth: true

            ColumnLayout {
                Repeater { 
                    id: leftList
                    anchors.margins: 20
            
                    model: Object.keys(jsonValue)

                    RoundButton {
                        implicitWidth: 124 //
                        Layout.fillWidth: true
                        radius: 8
                        font.pointSize: 10
                        text: modelData
                        flat: !hovered
                        highlighted: currentKey == modelData // 選択されていたらハイライト
                
                        onClicked: {
                            currentKey = modelData
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: 1 // child's borderWidth
            
            Line {vertical: true;invert: true}
        }

        ScrollView { // 右
            id: rightScroll

            rightPadding: root.padding; leftPadding: root.padding

            Layout.preferredHeight: maximumHeight
            Layout.preferredWidth: 400 //
            
            JsonRepeater {
                //layoutDirection: Qt.RightToLeft
                srcValue: jsonValue[currentKey] 

                anchors.fill: parent
                
                onValueChanged: if(value!=null && jsonValue[currentKey]!=value) {
                    jsonValue[currentKey] = value
                }
            }
        }
    }

    Rectangle {
        id: saveField
        height: 32
        Layout.fillWidth: true
        color: palette.base

        Line { /*区切り線*/ }

        Row {
            width: parent.width
            layoutDirection: Qt.RightToLeft

            IconButton {
                height: saveField.height
                width: height
                text: save
                background_color: "transparent"

                onClicked: root.save()
            }
            Label {
                id: json_path
                height: saveField.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: Helperb.getEnv(jsonPath_env)
                color: palette.windowText
            }
        }
    }


    /* ---------------------------------- save ---------------------------------- */
    function save() {
        settings_fileDialog.openFileDialog({
            fileMode: FileDialog.SaveFile, 
            nameFilters: ["JsonFile (*.json)"]
        }) 
    }
    Connections {
        target: settings_fileDialog
        function onAccepted(){ 
            Jsonb.save(settings_fileDialog.filePath, JSON.stringify(jsonValue))
            dialog.close() 
        }
    }
    CustomFileDialog {id: settings_fileDialog }
}

