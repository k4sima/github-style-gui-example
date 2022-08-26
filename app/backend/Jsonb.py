# --------------------------------- type hint -------------------------------- #
from __future__ import annotations  # < 3.10
# ---------------------------------------------------------------------------- #
from ..main import *
import json


class Jsonb_async(QObject):
    loaded = Signal(dict)
    saved = Signal(str)

    @Slot(str)
    def jsonLoad(self, path: str) -> None:  # json読み込み
        _p = Path(path)
        _p = _p if _p.is_absolute() else Path(CURRENT_DIR, _p)

        with open(_p, "r") as f:
            _value = json.load(f)
        self.loaded.emit(_value)

        log.info(f"jsonLoad -> {_p}")

    @Slot(str, dict)
    def jsonSave(self, path: str, value: dict) -> None:  # json保存
        _p = Path(path)
        _p = _p if _p.is_absolute() else Path(CURRENT_DIR, _p)

        if _p.exists():
            with open(_p, "r") as f:  # update existing json file
                try:
                    _j = json.load(f)
                    _j.update(value)
                    value = _j
                except json.decoder.JSONDecodeError:
                    log.warn(f"{_p} already exists, but can't read as json, so overwriting")

        with open(_p, "w") as f:
            json.dump(value, f, indent=4)
        self.saved.emit(str(_p))

        log.info(f"jsonSave -> {_p}")


# ---------------------------------------------------------------------------- #


class Jsonb(QObject):

    loaded = Signal("QVariant")
    saved = Signal(str)  # (saved path)

    load = Signal(str)  # (load path)
    save = Signal(str, "QVariantMap")  # (save path, json_value)

    def __init__(self, obj, parent=None) -> None:
        super().__init__(parent)

        self.load.connect(obj.jsonLoad)
        obj.loaded.connect(self.loaded.emit)

        self.save.connect(obj.jsonSave)
        obj.saved.connect(self.saved.emit)
