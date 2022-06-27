from ..main import *
from dotenv import dotenv_values, set_key
from urllib.parse import urlparse


class Helperb(QObject):
    envChanged = Signal(dict)

    def __init__(self, parent=None):
        super().__init__(parent)

    # ------------------------------ check data type ----------------------------- #
    @Slot("QVariant", result=str)
    def isType(self, v) -> str:
        return str(type(v).__name__)

    # ------------------------------- check string ------------------------------- #
    @Slot(str, result=bool)
    def isColor(self, v) -> bool:
        return QColor(v).isValid()

    @Slot(str, result=bool)
    def isFile(self, v) -> bool:
        _p = Path(v)
        return _p.exists() or _p.is_file() or _p.is_dir() or _p.suffix != ""

    # ------------------------------- .env manager ------------------------------- #
    @Slot(str, result="QVariant")
    def getEnv(self, key):
        _p = Path(CURRENT_DIR, ".env")
        value = dotenv_values(_p)[key]
        log.debug(f"getEnv -> [{key}:{value}] ({_p})")
        return value

    @Slot(str, "QVariant")
    def setEnv(self, key, value) -> None:
        _p = Path(CURRENT_DIR, ".env")
        set_key(_p, key, str(value))
        log.debug(f"saveEnv -> [{key}:{value}] ({_p})")

    # ---------------------------- Path and URI parse ---------------------------- #
    @Slot(str, result=str)
    def uriParse(self, uri: str) -> str:
        if os.name == "nt":  # もっといい方法があるかも
            return urlparse(uri).path.strip("/\\")
        else:
            return urlparse(uri).path

    @Slot(str, result=str)
    def pathParse(self, path: str) -> str:
        return Path(path).as_uri()
    # ---------------------------------------------------------------------------- #

    @Slot(str, bool, result=int)
    def file_or_dir_exits(self, file: str, is_file: bool) -> int:
        _f = Path(file)
        if is_file:
            if (not _f.is_file()) or (not _f.exists()):
                print(f"{_f.resolve()} does not exits or is not file")
                return 0
        else:
            if (not _f.is_dir()) or (not _f.exists()):
                print(f"{_f.resolve()} does not exits or is not directory")
                return 0
        return 1

    currentPath = Property(str, fget=lambda self: str(CURRENT_DIR), constant=True)
