# ============================================================
#  Project: Soke
#  File: logger_util.py
#  Author: Ishura
#
#  This file (logger_util.py) is part of the Soke project.
#  Â© 2025 Ishura. All rights reserved.
# ============================================================

# [ Imports ]
import os
import sys

from loguru import logger
from pathlib import Path

# [ Configurables/Setup ]
LOG_DIRECTORY = Path("./logs")
LOG_DIRECTORY.mkdir(parents=True, exist_ok=True)

logger.remove()

# [ Sink (Console) ]
logger.add(
    sys.stdout,
    colorize=True,
    level="DEBUG",
    format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | "
    "<level>{level: <8}</level> | "
    "<cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - "
    "<level>{message}</level>",
)

# [ Sink (File Rotating) ]
logger.add(
    LOG_DIRECTORY / "app.log",
    rotation="10 MB",
    retention="30 days",
    compression="zip",
    enqueue=True,
    encoding="utf-8",
    format="{time:YYYY-MM-DD HH:mm:ss} | {level: <8} | {name}:{function}:{line} - {message}",
)

# [ Sink (JSON) ]
logger.add(
    LOG_DIRECTORY / "structured.json",
    serialize=True,
    rotation="5 MB",
    retention="15 days",
    compression="gz",
)


def log_exceptions(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)

        except Exception:
            logger.exception("Unhandled exception in function '{}'", func.__name__)
            raise

    return wrapper
