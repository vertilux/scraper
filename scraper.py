from bs4 import BeautifulSoup
import requests
import json
import config
import pyodbc
import datetime

server = 'VXACCPAC2'
db_name = 'ACCLTD'
con = pyodbc.connect('DRIVER={FreeTDS};SERVER='+server+';DATABASE='+db_name+';PORT='+config.SQL_PORT+';UID='+config.SQL_USER+';PWD='+ config.SQL_PASSWD)
cursor = con.cursor()

def lme():
    url = "https://www.lme.com/en-GB/Metals/Non-ferrous/Aluminium#tabIndex=0"
    page = requests.get(url).text
    soup = BeautifulSoup(page, 'lxml')
    lme = soup.find("td", text="3-months").find_next_sibling("td").text
    return (float(lme))

def sme():
    cookies = {"SMM_auth_token":config.SMM_AUTH_TOKEN}
    url = "https://www.metal.com/"
    page = requests.get(url, cookies=cookies).text
    soup = BeautifulSoup(page, 'lxml')
    div = soup.find('div', text="SMM Aluminum Ingot(RMB/mt)").find_next_sibling("div").text
    sme = (div.split("-")[0]).replace(",", "")
    return (float(sme))

def exchange_rates_api():
    url = "https://openexchangerates.org/api/latest.json"
    querystring = {
        "app_id":config.OPEN_EXCHANGE_API,
        "base":"USD",
        "symbols":"CNY"
    }
    payload = ""
    response = requests.request("GET", url, data=payload, params=querystring)
    json_object = response.json()
    return json_object['rates']['CNY']

def oanda_rates_api():
    url = "http://web-services.oanda.com/rates/public/v1/daily"
    querystring = {
        "base":"USD",
        "quote":"CNY"
    }
    payload = ""
    response = requests.request("GET", url, data=payload, params=querystring)
    json_object = response.json()
    return json_object['rates']['avg_bid']

cursor.execute("""
    INSERT INTO daily_lme (lme, smm, rate, oanda, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?)
""", (lme(), sme(), exchange_rates_api(), oanda_rates_api(), datetime.datetime.now(), datetime.datetime.now()))
cursor.commit()
cursor.close()
con.close()
