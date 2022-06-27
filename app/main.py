# --------------------------------- type hint -------------------------------- #
from typing import Type, Iterable, Callable
# ---------------------------------------------------------------------------- #
from pathlib import Path
import sys
import os
import time
from datetime import datetime


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


def backend_load():  # set context properties from ./backend
    # ---------------------------------------------------------------------------- #
    global contentb, contentb_async, jsonb, jsonb_async, helperb   # push to main namespace

    from .backend import Contentb, Contentb_async, Jsonb, Jsonb_async, Helperb
    # ---------------------------------------------------------------------------- #

    contentb_async = workerThread.to_thread(Contentb_async())
    contentb = Contentb(contentb_async)

    jsonb_async = workerThread.to_thread(Jsonb_async())
    jsonb = Jsonb(jsonb_async)

    helperb = Helperb()

    return (contentb, jsonb, helperb)


def run() -> None:
    # push to main namespace
    global workerThread

    qInstallMessageHandler(qt_message_handler)  # qml message handler

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    app.aboutToQuit.connect(engine.deleteLater)  # 終了時のContextPropertyの参照エラー対策
    app.setWindowIcon(QIcon(":/icon/waraiotoko.ico"))

    workerThread = WorkerThread()

    for obj in backend_load():
        engine.rootContext().setContextProperty(obj.__class__.__name__, obj)

    engine.load(Path(CURRENT_DIR, "qml/main.qml"))

    if not engine.rootObjects(): sys.exit(-1)
    ret = app.exec()
    workerThread.stop()
    sys.exit(ret)
