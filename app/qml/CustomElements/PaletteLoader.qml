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
    

    /*brightText: undefined // windowTextとは異なる色で、強調表示されたボタン、text、windowText、buttonTextのコントラストが低い所に描画する場合に使用
    link: undefined  // リンク文字色
    linkVisited: undefined  //すでにアクセスしたリンク文字色
    windowText: undefined // 文字色
    text: undefined // Baseで使われる文字色。通常、windowTextと同じ。windowおよびbaseとの良好なコントラストが必要
    buttonText: undefined  // ボタン文字色
    light: undefined // highlightよりも明るい
    highlight: undefined // 選択範囲背景色
    highlightedText: undefined // 選択範囲文字色
    midlight: undefined  // buttonとlightの間
    button: undefined // ボタン背景色
    mid: undefined  // buttonとdarkの間
    dark: undefined // highlightよりも暗い
    shadow: undefined  // 非常に暗い色
    window: undefined  // 背景色
    alternateBase: undefined   // 代替の背景色
    base: base_color  // 主にテキスト入力やアイテムビューの背景色。通常は白または別の明るい色
    toolTipText: undefined  // ツールチップの文字色
    toolTipBase: undefined  // ツールチップの背景色*/
}