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

# read library
with open(os.path.expanduser("~/.stocks/library.txt"), "r") as LIBRARY:
    SYMBOLS = LIBRARY.read()

# get today
TODAY = datetime.today()
# get latest weekday
LATEST_WEEKDAY = TODAY - timedelta(days=1)
while LATEST_WEEKDAY.weekday() > 4:
    LATEST_WEEKDAY -= timedelta(days=1)
# get weekday previous to that one
PREV_WEEKDAY = LATEST_WEEKDAY - timedelta(days=1)
while PREV_WEEKDAY.weekday() > 4:
    PREV_WEEKDAY -= timedelta(days=1)
# get tomorrow
TOMORROW = TODAY + timedelta(days=1)

# download data between previous weekday and tomorrow
DATA = yf.download(SYMBOLS, start=f"{PREV_WEEKDAY:%F}", end=f"{TOMORROW:%F}")
# extract closing data
PREV_CLOSE = DATA["Close"].loc[f"{PREV_WEEKDAY:%F}"]
LATEST_CLOSE = DATA["Close"].loc[f"{LATEST_WEEKDAY:%F}"]

# create results dataframe
RESULT = pd.DataFrame()
RESULT.insert(0, "Current", LATEST_CLOSE)
RESULT.insert(1, "Change", LATEST_CLOSE - PREV_CLOSE)
RESULT.insert(2, "Percent", (LATEST_CLOSE - PREV_CLOSE) / LATEST_CLOSE * 100.)

# write results
with open(os.path.expanduser("~/.stocks/prices.txt"), "w") as PRICES:
    PRICES.write(RESULT.sort_values(by="Percent", ascending=False).to_string(header=False))
    PRICES.write(f"\n{datetime.now():%d %b %r}")
