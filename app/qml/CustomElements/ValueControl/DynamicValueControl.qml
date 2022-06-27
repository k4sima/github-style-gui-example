import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: valueControl
    property var value: null

    property string text: ""

    // onValueChanged: { }

    
    Component.onCompleted: if(value!=undefined && value!=null){
        //print(Helperb.isType(value))

        if(Helperb.isType(value)=="bool"){
            boolComp.createObject(this,{checked:value, text:text})

        }else if(Helperb.isType(value)=="str"){
         
            if(Helperb.isColor(value)){
                var color_comp = Qt.createComponent("ColorText.qml")
                if(color_comp.status==Component.Ready) {
                    var color_obj = color_comp.createObject(this,{text:value, subText:text})
                    color_obj.textChanged.connect(function(){ if(valueControl.value!=color_obj.text){
                            valueControl.value=color_obj.text
                     }})
                }
            }else if(Helperb.isFile(value)){
                var file_comp = Qt.createComponent("FileText.qml")
                if(file_comp.status==Component.Ready) {
                    var file_obj = file_comp.createObject(this,{text:value, subText:text})
                    file_obj.textChanged.connect(function(){ if(valueControl.value!=file_obj.text){
                            valueControl.value=file_obj.text
                     }})
                }
            }else{
                strComp.createObject(this,{text:value,placeholderText:text})
            }
        
    
        }else if(Helperb.isType(value)=="int"){
            numComp.createObject(this,{_value:value})
        }else if(Helperb.isType(value)=="float"){
            numComp.createObject(this,{_value:value, isFloat:true})
        }
    }
    
    
    Component {
        id: boolComp
        
        Switch {
            onCheckedChanged: if(value!=checked){ valueControl.value = checked}
        }
    }

    Component {
        id: strComp
        TextField {
            width: parent.width
            onTextChanged: if(value!=text){ valueControl.value = text}
        }
    }


    Component {
        id: numComp
        SpinBox {
            property bool isFloat: false
            property var _value: null
            property var _to: 999999 // 最大

            property int decimals: 2 // floatの最小桁数

            editable: true

            value: isFloat ? _value*100 : _value
            to: isFloat ? _to*100 : _to
            from: 0

            textFromValue: function(value, locale) { return isFloat ? Number(value/100).toLocaleString(locale, 'f', decimals) : Number(value).toLocaleString()}
            valueFromText: function(text, locale) { var _v=Number.fromLocaleString(locale, text); return isFloat?_v*100:_v }
            validator: DoubleValidator {
                bottom: Math.min(from, to)
                top: Math.max(from, to)
            }

            onValueChanged: {
                var _v = isFloat ? value/100 : value
                if(valueControl.value!=_v){ valueControl.value = _v }
            }
        }           
    }
}