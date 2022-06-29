import QtQuick

Palette {

    property string theme: ""
    property var data: null

    property QtObject target: null

    onDataChanged: paletteUpdate()
    onThemeChanged: paletteUpdate()
    onTargetChanged: paletteUpdate()
    
    readonly property var colorNames: ["alternateBase","base","brightText","button","buttonText","dark","highlight","highlightedText","light","link","linkVisited","mid","midlight","shadow","text","toolTipBase","toolTipText","window","windowText"]
    function paletteUpdate(){
        if((target!=undefined&&target!=null) && (data!=undefined&&data!=null) && (data[theme]!=undefined&&data[theme]!=null)){
            
            for(const color of colorNames){ if(data[theme][color]??false){
                this[color] = data[theme][color]
            }}
            target.palette = this
            console.info("[PaletteLoader] updated theme:", theme)
        }
    }
}