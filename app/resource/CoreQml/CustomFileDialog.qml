import QtQuick
import QtQuick.Dialogs
    
FileDialog {
    // defaultSuffix: "png"
    // options: FileDialog.HideNameFilterDetails

    property string filePath: ""

    Component.onCompleted: propertyReset()

    onSelectedFileChanged: {
        if (selectedFile!=null) {
            filePath = Helperb.uriParse(selectedFile)
        }
    }

    onAccepted: { console.info("[filedialog]","onAccepted:",filePath); propertyReset() }
    onRejected: { propertyReset() }

    readonly property var props: {
        "fileMode":FileDialog.OpenFile,
         "currentFolder":Helperb.pathParse(Helperb.currentPath), 
         "nameFilters":["*"] // ["Images (*.png *.jpg *.gif *.svg *.bmp *.webp)"],
    }

    function propertyReset() {
        for(const p in props){
            this[p] = props[p]
        }
    }

    function openFileDialog(properties={}) {
        for(const p in properties) {
            if(props[p]!=undefined) {
                this[p] = properties[p]
            }else{ console.warn("[filedialog] unknown property: "+p) }
        }
        open()
    }
}