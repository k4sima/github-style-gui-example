import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "CustomElements"

ApplicationWindow {
    id: window
    width: jsonValue["display"]["width"] < minimumWidth ? minimumWidth : jsonValue["display"]["width"]
    height: jsonValue["display"]["height"] < minimumHeight ? minimumHeight : jsonValue["display"]["height"]
    minimumWidth: jsonValue["display"]["_minWidth"]
    minimumHeight: jsonValue["display"]["_minHeight"]
    visible: false
    color: "transparent"

    title: qsTr("GUI Toy")
    flags: Qt.Window | Qt.FramelessWindowHint

    property var jsonValue: undefined

    
    Component.onCompleted: {
        Jsonb.load(Helperb.getEnv("JSON_PATH"))
    }
    

    PaletteLoader{ 
        id:paletteLoader
        target: window
        theme: jsonValue["common"]["theme"]
        data: jsonValue["palette"]
    }

    Connections {
        target: Jsonb
        function onLoaded(value){// JSON data is loaded
            jsonValue = value
            if(!visible) { visible = true } // ロードしたらwindow表示
        }
    }


    function maximizeRestore() {
        if(bg.margin == 0){ 
            window.showNormal()
        }else{
            window.showMaximized()
        }
    }
    onVisibilityChanged:  function() {
        if (visibility==Window.Maximized) {
            bg.margin = 0
            maxBtn.text = maxBtn.chromeRestore
            window_resizeAreas.visible = false
        } else {
            bg.margin = bg.defaultMargin
            maxBtn.text = maxBtn.chromeMaximize
            window_resizeAreas.visible = true
        }
    }

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<< 画面 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    Rectangle { // 
        readonly property int defaultMargin : 10

        color: palette.base
        id: bg
        anchors.fill: parent
        property int margin : defaultMargin
        anchors {
            rightMargin: margin
            leftMargin: margin
            bottomMargin: margin
            topMargin: margin
        }

        /* ---------------------------------- ヘッダー ---------------------------------- */
        Rectangle {
            id: header
            height: 30
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            property string bgColor: palette.dark

            TopMenu { // <<<<<<<<<< 左端 >>>>>>>>>>
                id:topmenu
                // height: parent.height
                onPoppedChanged: if (popped){
                    blackout.fade = true
                    blackout.z = 1 
                }else{
                    blackout.fade = false
                }
            }
            
            Pane { // <<<<<<<<<< 右端 >>>>>>>>>>
                id: titlebar
                anchors {
                    left: topmenu.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                
                padding: 0
                background:Rectangle{
                    color:header.bgColor
                }

                MouseArea {
                    id: window_drag_mouseArea
                    anchors {
                        right: titlebar_Btn.left
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }

                    onDoubleClicked: window.maximizeRestore()
                    DragHandler{
                        onActiveChanged:if(active){
                                window.startSystemMove()
                        }
                    }
                }
                /* -------- ボタン -------- */
                Row { 
                    id: titlebar_Btn
                    height: parent.height
                    anchors.right: parent.right
                    layoutDirection: Qt.RightToLeft

                    IconButton { // 閉じる
                        height: parent.height
                        width: height*1.5
                        palette.mid: "red"
                        text: chromeClose
                        onClicked: window.close()
                    }
                    IconButton { // 最大化
                        id: maxBtn
                        height: parent.height
                        width: height*1.5
                        text: chromeMaximize
                        onClicked: window.maximizeRestore()
                    }
                    IconButton { // 最小化
                        height: parent.height
                        width: height*1.5
                        text: chromeMinimize
                        onClicked: window.showMinimized()
                    }
                }
            }
        }
        Line { // ヘッダー下の区切り線   
            id: headerLine
            anchors { left:parent.left; right:parent.right; top:header.bottom }
        }
        
        /* ---------------------------------- コンテンツ --------------------------------- */
        Item { 
            id: content
            anchors {
                left: parent.left
                right: parent.right
                top: headerLine.bottom
                bottom: parent.bottom
            }
            Content {
                width: parent.width - sideMenu.closeWidth
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
            }

            /* ---- サイドメニュー ---- */
            DrawerMenu { // 
                z: 1
                id: sideMenu
                anchors.fill: parent

                onOpenedChanged: blackout.fade = opened

                MouseArea { // マウスイベントが下にいかないようにする
                    anchors.fill: parent
                    hoverEnabled: true
                }

                SideMenu {anchors.fill: parent}
            }

            /* -------- 暗転用 -------- */
            Blackout { 
                z: 0 // 0でサイドメニューの下、1でサイドメニューの上
                id: blackout
                anchors.fill: parent
                onFadeChanged: if(!fade){ // 暗転終了時
                    if(sideMenu.opened){ sideMenu.opened = false } // サイドメニューが開いていたら閉じる
                    if(topmenu.popped){ topmenu.popped = false } // トップメニューが開いていたら閉じる
                    z = 0 // zを0に戻す
                }
                MouseArea { 
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: if(blackout.fade){ // クリックで暗転を解除
                        blackout.fade = false
                    }
                }
            }
        }

        /* ----- ダイアログ ----- */
        CustomDialog { 
            id: dialog
            onOpened: blackout.fade = true
            onClosed: blackout.fade = false
        }  
    }
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    /* ----ウィンドウの影 ---- */
    Shadow {anchors.fill:bg; source:bg}

    /* -- ウィンドウのリサイズエリア -- */
    WindowResizeArea { 
        id: window_resizeAreas
        objectName: "window_resizeAreas"
        anchors.fill: parent
        targetWindow: window
        margin: bg.margin
        showAreaColor: false
    }
}