from tradingview_ta import TA_Handler, Exchange,Interval
import tradingview_ta
tesla = TA_Handler(
    symbol='TSLA',
    screener='america',
    exchange='NASDAQ',
    interval=Interval.INTERVAL_1_MINUTE
)
bn = TA_Handler(
    symbol='BANKNIFTY',
    screener='india',
    exchange='NSE',
    interval=Interval.INTERVAL_5_MINUTES
)
sbiI = TA_Handler(
    symbol='SBIN',
    screener='india',
    exchange='NSE',
    interval=Interval.INTERVAL_5_MINUTES
)
# print(sbiI.get_analysis().indicators["close"])
# print(sbiI)
print(bn.get_analysis().indicators['EMA30'])

print(tradingview_ta.__version__)