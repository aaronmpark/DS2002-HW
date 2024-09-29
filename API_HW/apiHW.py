# API HW
# Aaron Park ync4hn
import requests
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime, timedelta

headers = {
    'x-api-key': "TWMfaqargI8Of9cWoArge3dcidbllR2h2RjI9Kpb"
}

# output function for the values needed to be displayed back to the user
def get_stockData(ticker):
    # Initialize the urls and query
    quote_url = "https://yfapi.net/v6/finance/quote"
    summary_url = f"https://yfapi.net/v11/finance/quoteSummary/{ticker}"
    querystring = {"symbols": ticker}

    try:
        # quote data fetching
        quote_response = requests.request("GET", quote_url, headers=headers, params=querystring)
        quote_response.raise_for_status() 
        quote_data = quote_response.json()

        # summary data fetching [for Target Mean Price]
        summary_response = requests.request("GET", summary_url, headers=headers, params={"modules": "financialData"})
        summary_response.raise_for_status()
        summary_data = summary_response.json()
        
        # check if the response exists, [stock exists]
        if 'quoteResponse' in quote_data and 'result' in quote_data['quoteResponse']:

            stock_info = quote_data['quoteResponse']['result'][0] # get quote stock data

            # make sure if the summary response exists as well
            if 'quoteSummary' in summary_data and 'result' in summary_data['quoteSummary']:

                # fetch target_mean_price
                financial_data = summary_data['quoteSummary']['result'][0].get('financialData')
                target_mean_price = financial_data.get('targetMeanPrice').get('raw')

            # return the values
            return {
                'Ticker': stock_info.get('symbol'),
                'Full Name': stock_info.get('longName'),
                'Current Market Price': stock_info.get('regularMarketPrice'),
                'Target Mean Price': target_mean_price,
                '52 Week High': stock_info.get('fiftyTwoWeekHigh'),
                '52 Week Low': stock_info.get('fiftyTwoWeekLow')
            }
        # handle errors [api not returning any info]
        else:
            print(f"No data found for ticker: {ticker}")
    # handle error of fetching data
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

# output function for the 5 current trending stocks
def get_trendingStocks():
    url = "https://yfapi.net/v1/finance/trending/US"

    try:
        # url 
        response = requests.request("GET", url, headers=headers)
        response.raise_for_status()
        data = response.json()
        
        # check if data exists
        if 'finance' in data and 'result' in data['finance']:
            
            # get 5 of the current trending stocks
            trending = data['finance']['result'][0].get('quotes', [])
            return [stock['symbol'] for stock in trending[:5]]
        
        # error catching [fetching doesn't work or stocks not found]
        else:
            print("No trending stocks found from the data")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching the data of trending stocks: {e}")

# Bonus data function 
def get_historicalData(ticker):
    
    url = f"https://yfapi.net/v8/finance/chart/{ticker}"
    querystring = {
        "range": "5d",
        "interval": "1d"
    } # set range for 5 days, at a 1 day interval

    try:
        # get data
        response = requests.request("GET", url, headers=headers, params=querystring)
        response.raise_for_status()
        data = response.json()

        # check if data exists
        if 'chart' in data and 'result' in data['chart']:
            historicalData = data['chart']['result'][0]
            timestamps = historicalData['timestamp']
            high_prices = historicalData['indicators']['quote'][0]['high']
            
            dates = [datetime.fromtimestamp(ts) for ts in timestamps]
            return dates, high_prices
        else:
            print(f"No historical data found for the ticker: {ticker}")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching the historical data: {e}")

# get user input of a ticker symbol
ticker = input("Enter ticker symbol: ")

# get the stock data and print it out 
stock_data = get_stockData(ticker)

print("Stock Information: \n")
for key, value in stock_data.items():
    print(f"{key}: {value}")

# Put data in a DataFrame and then store that to a CSV file
df = pd.DataFrame([stock_data])
df.to_csv(f"{ticker}_data.csv", index=False)

# Get trending data and print it out 
trending_stocks = get_trendingStocks()
if trending_stocks:
    print("Current Trending Stocks: \n")
    for stock in trending_stocks:
        print(stock)

# Bonus: Plot historical price of a stock's price highest value over the past 5 days
dates, high_prices = get_historicalData(ticker)
if dates and high_prices:
    plt.figure(figsize=(5, 5))
    plt.plot(dates, high_prices, marker='o')
    plt.title(f"{ticker} Highest Stock Price Over the Past 5 Days")
    plt.xlabel("Date")
    plt.ylabel("Price")
    plt.xticks(rotation=45)
    plt.show()
    plt.savefig("apiHW.png")
    plt.close()
