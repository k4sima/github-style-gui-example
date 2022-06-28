import QtQuick

Rectangle { // 追加した親の位置にマージン設定しないと恐らく親コンテンツがズレる

        property bool vertical:false // vertical or horizontal
        property bool invert:false // invert orientation
        property real borderWidth: 1
        
        id:control
        color: palette.shadow
        width: vertical ? borderWidth : undefined
        height: !vertical ? borderWidth : undefined
        
        anchors {
            top: vertical || (!vertical && !invert) ? parent.top : undefined
            bottom: vertical || (!vertical && invert) ? parent.bottom : undefined
            left: !vertical || (vertical && !invert) ? parent.left : undefined
            right: !vertical || (vertical && invert) ? parent.right : undefined
        }
}