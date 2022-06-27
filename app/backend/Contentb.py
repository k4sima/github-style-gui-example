from ..main import *


class Contentb_async(QObject):  # Other thread 待機する処理を担う
    textChanged = Signal(str)
    progressChanged = Signal(float)

    @Slot(int)
    def bomb(self, v) -> None:
        for i in Progress(range(v), self.progressChanged.emit):
            self.textChanged.emit(str(i))
            time.sleep(1)


class Contentb(QObject):  # GUI thread
    bombSignal = Signal(int)

    def __init__(self, obj, parent=None) -> None:
        super().__init__(parent)

        self._text: str = ""
        self._progress: float = 0

        obj.textChanged.connect(self.setText)
        obj.progressChanged.connect(self.setProgress)
        self.bombSignal.connect(obj.bomb)

    # ---------------------------------------------------------------------------- #
    # ------------------------------ text property ------------------------------- #

    def getText(self) -> str:
        return self._text

    def setText(self, v) -> None:
        self._text = v
        self.textChanged.emit(v)

    textChanged = Signal(str)
    text = Property(str, fget=getText, fset=setText, notify=textChanged)
    # ---------------------------------------------------------------------------- #
    # ------------------------------ progress property ------------------------------ #

    def getProgress(self) -> float:
        return self._progress

    def setProgress(self, v) -> None:
        self._progress = v
        self.progressChanged.emit(v)

    progressChanged = Signal(float)
    progress = Property(float, fget=getProgress, fset=setProgress, notify=progressChanged)
    # ---------------------------------------------------------------------------- #
