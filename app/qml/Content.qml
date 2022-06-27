import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "CustomElements"

Item {
    id: root
    
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
                SplitView.minimumWidth: root.width*0.2
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
                    width: parent.width / 2
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }
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
                    onPressed: Contentb.text = "Hello World!" // When press the button(signal) -> Change contentb(Content backend) text property
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    SpinBox {
                        id: spinbox       
                        Layout.fillHeight:true
                        Layout.minimumWidth: root.width*0.2
                        font.pointSize: 32
                        from: 0; to: 50
                    }
                    Button{
                        Layout.fillHeight:true
                        Layout.fillWidth: true                   
                        text: "Bomb"
                        font.pointSize: 32
                        onPressed: Contentb.bombSignal(spinbox.value)
                    }
                }
            }
        }
    }
}