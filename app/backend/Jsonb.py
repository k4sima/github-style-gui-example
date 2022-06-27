# --------------------------------- type hint -------------------------------- #
from __future__ import annotations  # < 3.10
# ---------------------------------------------------------------------------- #
from ..main import *
import json


class Jsonb_async(QObject):
    loaded = Signal(dict)
    saved = Signal(str)

    def jsonLoad(self, path: str) -> None:  # json読み込み
        _p = Path(path)
        _p = _p if _p.is_absolute() else Path(CURRENT_DIR, _p)

        with open(_p, "r") as f:
            _value = json.load(f)
        self.loaded.emit(_value)

        log.info(f"jsonLoad -> {_p}")

    def jsonSave(self, path: str, json_str: str) -> None:  # json保存
        _p = Path(path)
        _p = _p if _p.is_absolute() else Path(CURRENT_DIR, _p)

        _json: dict = json.loads(json_str)

        if _p.exists():
            with open(_p, "r") as f:  # update existing json file
                try:
                    _j = json.load(f)
                    _j.update(_json)
                    _json = _j
                except json.decoder.JSONDecodeError:
                    log.warn(f"{_p} already exists, but can't read as json, so overwriting")

        with open(_p, "w") as f:
            json.dump(_json, f, indent=4)
        self.saved.emit(str(_p))

        log.info(f"jsonSave -> {_p}")

# ---------------------------------------------------------------------------- #


class Jsonb(QObject):

    loaded = Signal("QVariant")
    saved = Signal(str)  # (saved path)

    load = Signal(str)  # (load path)
    save = Signal(str, str)  # (save path, json)

    def __init__(self, obj, parent=None) -> None:
        super().__init__(parent)

        self.load.connect(lambda v: obj.jsonLoad(v))
        obj.loaded.connect(lambda v: self.loaded.emit(v))

        self.save.connect(lambda path, v: obj.jsonSave(path, v))
        obj.saved.connect(lambda v: self.saved.emit(v))
