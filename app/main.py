# --------------------------------- type hint -------------------------------- #
from typing import Type, Iterable, Callable
# ---------------------------------------------------------------------------- #
from pathlib import Path
import sys
import os
import time
import importlib.util as imut

from PySide6.QtGui import QGuiApplication, QIcon, QColor
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QThread, QObject, Signal, Slot, Property, QtMsgType, qInstallMessageHandler


from .element_util import Progress
from . import resource  # resource.py (resource.qrc)

# ---------------------------------- logging --------------------------------- #
from logging import getLogger
log = getLogger(__name__)
# ---------------------------------------------------------------------------- #


CURRENT_DIR = Path(__file__).parent


def qt_message_handler(mode, context, message):  # qml message handler
    if mode == QtMsgType.QtWarningMsg:
        log.warning(message)
    elif mode == QtMsgType.QtCriticalMsg:
        log.critical(message)
    elif mode == QtMsgType.QtFatalMsg:
        log.fatal(message)
    elif mode == QtMsgType.QtInfoMsg:
        log.info(message)
    elif mode == QtMsgType.QtDebugMsg:
        log.debug(message)
    elif mode == QtMsgType.QtSystemMsg:
        log.debug(message)


class WorkerThread():
    def __init__(self) -> None:
        self.thread = QThread()
        self.thread.start()

    def stop(self) -> None:
        self.thread.quit()
        self.thread.wait()

    def to_thread(self, obj) -> Type[QObject]:  # return QObject
        obj.moveToThread(self.thread)
        return obj


def backend_load(dir_name: str):  # set context properties from (dir_name) directory

    for f in Path(CURRENT_DIR, dir_name).glob("[A-Z]*b.py"):
        if f.stem[0].islower(): continue

        mod_name = ".".join(__name__.split(".")[:-1] + [dir_name, f.stem])
        spec = imut.spec_from_file_location(mod_name, f)
        mod = imut.module_from_spec(spec)
        spec.loader.exec_module(mod)

        if hasattr(mod, f"{f.stem}_async"):
            cls_async = workerThread.to_thread(getattr(mod, f"{f.stem}_async")())
            globals()[f"{f.stem}_async"] = cls_async  # push to global namespace

            cls = getattr(mod, f.stem)(cls_async)
        else:
            cls = getattr(mod, f.stem)()
        globals()[f.stem] = cls  # push to global namespace

        yield cls


def run() -> None:
    # push to main namespace
    global workerThread

    qInstallMessageHandler(qt_message_handler)  # qml message handler

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    app.aboutToQuit.connect(engine.deleteLater)  # 終了時のContextPropertyの参照エラー対策
    app.setWindowIcon(QIcon(":/icon/app.ico"))

    workerThread = WorkerThread()

    for prop in backend_load("backend"):
        engine.rootContext().setContextProperty(prop.__class__.__name__, prop)

    engine.load(Path(CURRENT_DIR, "qml/main.qml"))

    if not engine.rootObjects(): sys.exit(-1)
    ret = app.exec()
    workerThread.stop()
    sys.exit(ret)
