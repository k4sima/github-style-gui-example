import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import "qrc:/CoreQml"
import "qrc:/CoreQml/ValueControl"

Item {
    id: root

    property var overlayColors:  {"normal":"transparent","red":"#80ff0000", "green":"#8000ff00", "blue":"#800000ff"}
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        SplitView {
            Layout.fillHeight: true
            Layout.fillWidth: true

            orientation: Qt.Horizontal

            Pane {
                SplitView.minimumWidth: contentWidth
                ColumnLayout {
                    //anchors.fill: parent
                    CheckBox { text: qsTr("E-mail") }
                    CheckBox { text: qsTr("Calendar") }
                    CheckBox { text: qsTr("Contacts") }
                }
            }
            Pane {
                SplitView.minimumWidth: root.width*0.6

                GroupBox {
                    id: testImage
                    clip: true
                    padding: 0

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        bottom: testDialog.top
                    }
                    Row {
                        ColumnLayout {
                            height: testImage.height
                            AnimatedImage {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                opacity: glowSlider.value
                                
                                fillMode: Image.PreserveAspectFit
                                source: "https://github.githubassets.com/images/mona-loading-dark.gif"

                                ColorOverlay {
                                    anchors.fill: parent
                                    source:  parent
                                    color: overlayColors[Object.keys(overlayColors)[colorTumbler.currentIndex]]

                                    Behavior on color {
                                        ColorAnimation { duration:100 }
                                    }   
                                }
                            }
                            Slider {
                                id: glowSlider
                                Layout.fillWidth: true
                                from: 0
                                value: 1
                                to: 1
                            }
                        }

                        Tumbler {
                            id: colorTumbler
                            height: testImage.height
                            model: Object.keys(overlayColors)
                        }

                    }
                }

                GroupBox {
                    id: testDialog
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    clip: true
                    title: qsTr("Open Dialog")

                    RowLayout {
                        anchors.fill: parent
                        spacing: 5
                        GroupBox {
                            title: qsTr("Title")
                            TextField {
                                id: titleField
                                implicitWidth: 70
                                text: "title"
                            }
                        }
                        GroupBox {
                            title: qsTr("Content Text")
                            TextField {
                                id: textField
                                implicitWidth: 70
                                text: "text"
                            }
                        }
                        GroupBox {
                            title: qsTr("Dialog Button")
                            ComboBox {
                                id: comboBox
                                implicitWidth: 80
                                textRole:"text"; valueRole:"value"
                                
                                model: [
                                    { value: Dialog.Ok, text: qsTr("Ok") },
                                    { value: Dialog.Cancel, text: qsTr("Cancel") },
                                    { value: Dialog.Close, text: qsTr("Close") },
                                    { value: Dialog.Apply, text: qsTr("Apply") },
                                    { value: Dialog.Reset, text: qsTr("Reset") },
                                    { value: Dialog.Help, text: qsTr("Help") },
                                    { value: Dialog.Yes, text: qsTr("Yes") },
                                    { value: Dialog.No, text: qsTr("No") },
                                ]
                            }
                        }
                        GroupBox {
                            id: fileTextGropuBox
                            title: qsTr("image")
                            Layout.fillWidth: true
                            FileText {id: fileText; text:"apple.png" }
                        }

                        RoundButton {
                            radius: 5
                                 
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: fileTextGropuBox.height
                            
                            text: "Open"
                            highlighted: true
                            onClicked: dialog.openComponent(dialog_comp, {title:titleField.text,standardButtons:comboBox.currentValue})
                        }
                    }

                    Component {
                        id: dialog_comp

                        Column {   
                            anchors.horizontalCenter: parent.horizontalCenter
                            topPadding:20; bottomPadding:20; leftPadding:100; rightPadding:100
                            spacing: 30
                            
                            Label {
                                id: test_label
                                horizontalAlignment: Text.AlignHCenter
                                width: test_image.width
                                text: textField.text
                                font.pixelSize: 40; font.bold: true
                            }
                            Image {
                                id: test_image
                                width: 200
                                fillMode: Image.PreserveAspectFit
                                Component.onCompleted: source = Helperb.pathParse(Helperb.currentPath + "/" + fileText.text)
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.maximumHeight: root.height*0.3
            Layout.fillWidth: true
            Layout.margins: 5

            Pane {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Label {      
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: Contentb.text
                    font.pointSize: 32
                    fontSizeMode:  Text.Fit
                }
                ProgressBar {
                    width: parent.width
                    anchors.bottom: parent.bottom
     
                    value: Contentb.progress
                }
            }
    

            ColumnLayout {
                Layout.fillHeight: true
                Layout.maximumWidth: root.width*0.4
                Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Button"
                    font.pointSize: 32
                    onClicked: Contentb.text = "Hello World!" // When press the button(signal) -> Change contentb(Content backend) text property
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    SpinBox {
                        id: spinbox       
                        Layout.fillHeight:true
                        Layout.minimumWidth: root.width*0.2
                        font.pointSize: 20
                        from: 0; to: 50
                    }
                    Button{
                        Layout.fillHeight:true
                        Layout.fillWidth: true                   
                        text: "Progress Start"
                        font.pointSize: 14
                        onPressed: Contentb.bombSignal(spinbox.value)
                    }
                }
            }
        }
    }
}