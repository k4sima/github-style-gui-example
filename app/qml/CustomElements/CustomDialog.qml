import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: root
    
    property int duration: 200

    property real maximumWidth: parent.width * 0.9
    property real maximumHeight: parent.height * 0.9

    anchors.centerIn: parent

    //rightInset: -5; leftInset: -5; topInset: -5; bottomInset: -5
    padding: 0

    Component.onCompleted: propertyReset()

    readonly property var props: {
        "standardButtons": Dialog.Close,
         "title": "Dialog",
         //"closePolicy": Popup.CloseOnEscape|Popup.CloseOnPressOutside
    }

    function propertyReset() {
        for(const p in props){
            this[p] = props[p]
        }
    }

    function openComponent(inner_comp, properties={}){ // inner_compを挿入して開く
        inner_comp.createObject(contentItem)

        for(const p in properties) {
            if(props[p]!=undefined) {
                this[p] = properties[p]
            }else{ console.warn("[dialog] unknown property: "+p) }
        }
        open()
    }


    // onAccepted: console.debug("[dialog]","onAccepted")
    // onApplied: console.debug("[dialog]","onApplied")
    // onDiscarded: console.debug("[dialog]","onDiscarded")
    // onHelpRequested: console.debug("[dialog]","onHelpRequested")
    // onRejected: console.debug("[dialog]","onRejected")
    // onReset: console.debug("[dialog]","onReset")


    onOpened: console.debug("[dialog]","onOpened with", contentData[0])
    onClosed: {
        console.debug("[dialog]","onClosed")
        for(const i in contentData){  // contentData内にあるものをすべて削除
            contentData[i].destroy()
            propertyReset()
            console.debug("[dialog]", "contentData", contentData[i], "destroyed")
        }
    }


    // contentItem: // メインコンテンツ

    header: Item{ // ヘッダー
        id: header
        implicitHeight: 50

        RowLayout {
            anchors.margins: 10
            anchors.fill: parent
            layoutDirection: Qt.RightToLeft
        
            IconButton { // 閉じるボタン
                Layout.preferredHeight: header.height*0.6
                Layout.preferredWidth: height

                text: chromeClose
                background_color: "transparent"
                onClicked: root.reject()
            }
        }

        Label {
            anchors.margins: 10
            anchors.left: header.left
            anchors.verticalCenter: parent.verticalCenter

            text: title; visible: title
            font.pointSize: header.height*0.2
            elide: Label.ElideRight
            font.bold: true
        }

        Line {/*区切り線*/ invert:true } 
    }

    footer: DialogButtonBox { // フッター
        //alignment: Qt.AlignVCenter | Qt.AlignHCenter
        background:Rectangle{
            color:"transparent"
            Line {/*区切り線*/ }
        }
    } 

    background: Rectangle { // 背景
        id: dialog_bg
        color: palette.window
        border.color: palette.dark
        radius: 5
        // ドロップシャドウ
        layer.enabled: true
        layer.effect: Shadow{ anchors.fill:dialog_bg; source:dialog_bg } 
    }

    enter: Transition {
        NumberAnimation {
            from:0; to: 1
            properties: "scale"; easing.type: Easing.OutBack; duration: root.duration
        }
    }
    exit: Transition {
        NumberAnimation {
            from:1; to: 0
            properties: "scale"; easing.type: Easing.InOutExpo; duration: root.duration*0.8
        }
    }
}

