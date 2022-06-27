# Top layer for launching GUI App

from app import run

from argparse import ArgumentParser
# ---------------------------------- logging --------------------------------- #
from logging import getLogger, FileHandler
from rich.logging import RichHandler

log = getLogger("app")
log.addHandler(RichHandler(markup=False, show_path=False, rich_tracebacks=True))
# log.addHandler(FileHandler("app.log"))
# ---------------------------------------------------------------------------- #


if __name__ == "__main__":
    par = ArgumentParser()
    par.add_argument("-l", "--log-level", help="set logging level", type=str, default="INFO",
                     choices=["NOTSET", "DEBUG", "INFO", "WARING", "ERROR", "CRITICAL"])
    args = par.parse_args()
    log.setLevel(args.log_level)

    run()
