import requests
import urllib.request
import time
from bs4 import BeautifulSoup

url = "https://www.lme.com/en-GB/Metals/Non-ferrous/Aluminium#tabIndex=0"
page = requests.get(url)

soup = BeautifulSoup(page.text, "html.parser")
print(soup.findAll)
