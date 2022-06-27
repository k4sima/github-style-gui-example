import Qt5Compat.GraphicalEffects
    
DropShadow { 
    //anchors.fill: bg // idで指定するのが肝？しらんけど
    //source: bg
    horizontalOffset: 0
    verticalOffset: 0
    radius: 16
    color: "#80000000"
    transparentBorder: true
    z: -1
}