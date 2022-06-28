import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:/CoreQml/ValueControl"

ColumnLayout {
    id: root

    property var srcValue: null // edit this
    property var value: {}

    property var _elements: [] // current outer(GroupBox) array

    property string hoverColor: palette.base
    property int hoverColor_duration: 100

    spacing: 5

    onValueChanged: console.debug("[JsonRepeater]","onValueChanged", JSON.stringify(value))


    onSrcValueChanged: if(srcValue!=undefined && srcValue!=null) {
        while(_elements.length > 0){ // remove all elements
            _elements[0].drop()
        }
        value = srcValue instanceof Object ? JSON.parse(JSON.stringify(srcValue)) : srcValue // 辞書の場合は元が変わらないように複製
        elementsCreate(this) // create elements in root
        console.debug("[JsonRepeater]","Updated _elements:", "("+_elements.length,"count"+")")
    }


    function elementsCreate(at) {
        if(at.value instanceof Object){ // 辞書 or 配列 の場合
            
            for(const i in at.value) {
                if (at.value[i] instanceof Object) {
                    var _comp = multi.createObject(null,{value:at.value[i]}) 
                    elementsCreate(_comp)
                }else{
                    var _comp = single.createObject(null, {value:at.value[i]})
                    
                } 

                _comp.updatedValue.connect(function(v){ // valueが更新されたらatのvalue[i]を更新
                    at.value[i] = v
                    at.valueChanged() // こうしないとsignalが発火しない
                })

                _elements.push(outer.createObject(at, {title:i, contentItem:_comp})) // outer(GroupBox)で包んで_elementsに追加
            }
        }else{  // 単体の場合
            var _comp = single.createObject(null, {value: value})
            _comp.valueChanged.connect(function(){at.value = _comp.value})
            _elements.push(outer.createObject(at, {contentItem: _comp}))  // outer(GroupBox)で包んで_elementsに追加
        }
    }

    Component { // 囲い
        id:outer

        GroupBox {
            implicitWidth: parent.width // fit to parent width

            padding: background.visible ? 10 : 0 // 背景が表示されていたらpaddingを適応
            // bottomInset: -background.border.width

            background: Rectangle {
                visible: contentItem instanceof DynamicValueControl // 子がDynamicValueControlなら背景を表示
      
                color: hoverColor
                opacity: hovered ? 0.4 : 0.2

                Behavior on opacity {
                    NumberAnimation {
                        duration: hoverColor_duration
                        easing.type: Easing.InOutQuad
                    }
                }
             }

             label: Label {
                x: parent.padding; y: parent.padding
                width: availableWidth
                font.bold: contentItem instanceof DynamicValueControl ? false : true
                text: title
             }

            function drop(){ // 削除
                _elements.splice(_elements.indexOf(this), 1)
                this.destroy()
            }
        }
    }

    Component{ // 辞書or配列用
        id: multi

        Column {
            signal updatedValue(var v)
            property var value: {}

            spacing: root.spacing
            anchors.margins: 20

            onValueChanged: updatedValue(value)
        }
    }
    Component { // 最下層
        id: single
        DynamicValueControl {
            signal updatedValue(var v)
            // value:

            onValueChanged: updatedValue(value)   
        }
    }
}