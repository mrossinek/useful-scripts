#!/usr/bin/python
"""Stock watcher based on yfinance

Created by
Max Rossmannek
2020-05-13

Usage: run python stock_watcher.py
Config:
    library.txt: holds one Yahoo Finance symbol per line
"""
from datetime import datetime, timedelta
import os
import pandas as pd
import yfinance as yf

with open(os.path.expanduser("~/.stocks/library.txt"), "r") as LIBRARY:
    SYMBOLS = LIBRARY.read()

TODAY = datetime.today()
YESTERDAY = TODAY - timedelta(days=1)
TOMORROW = TODAY + timedelta(days=1)
DATA = yf.download(SYMBOLS, start=f"{YESTERDAY:%F}", end=f"{TOMORROW:%F}")
PCLOSE = DATA["Close"].loc[f"{YESTERDAY:%F}"]
CLOSE = DATA["Close"].loc[f"{TODAY:%F}"]

RESULT = pd.DataFrame()
RESULT.insert(0, "Current", CLOSE)
RESULT.insert(1, "Change", CLOSE - PCLOSE)
RESULT.insert(2, "Percent", (CLOSE - PCLOSE) / CLOSE * 100.)

with open(os.path.expanduser("~/.stocks/prices.txt"), "w") as PRICES:
    PRICES.write(RESULT.sort_values(by="Percent", ascending=False).to_string(header=False))
    PRICES.write(f"\n{datetime.now():%d %b %r}")
