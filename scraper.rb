require 'nokogiri'
require 'httparty'

require "uri"
require "net/http"
require 'json'

require 'tty-table'
require 'artii'
require 'rainbow'
require 'friendly_numbers'

# Scrapping LME Website
lme_url = "https://www.lme.com/en-GB/Metals/Non-ferrous/Aluminium#tabIndex=0"
lme_unparsed = HTTParty.get(lme_url)
lme_parsed = Nokogiri::HTML(lme_unparsed)
@lme = Array.new
lme_table = lme_parsed.css('.tabContent').css('.table-wrapper')
lme_table = lme_table.css('tbody tr')
lme_table.each do |list|
  l = list.css('td').map(&:content)[1]
  @lme << l
end

# Scrapping Shanghai Metals Market Website
smm_url = "https://www.metal.com/"
smm_unparsed = HTTParty.get(smm_url)
smm_parsed = Nokogiri::HTML(smm_unparsed)
@smm = Array.new
smm_table = smm_parsed.css('.rowContent___R6As2').css('.row___uDSlF')
smm_table.each do |list|
  l = list.css('div').map(&:content)[1]
  @smm << l
end

# Getting USD -> CNY exchange rate
def exchange_rates_api
  url = URI("https://api.exchangeratesapi.io/latest?base=USD&symbols=CNY")
  https = Net::HTTP.new(url.host, url.port);
  https.use_ssl = true
  request = Net::HTTP::Get.new(url)
  response = https.request(request)
  obj = JSON.parse(response.read_body)

  @rate = obj['rates']['CNY']
end

# OANDA (USD -> CNY) exchange rates
def oanda_average_rate
  url = URI("http://web-services.oanda.com/rates/public/v1/daily?base=USD&quote=CNY")
  http = Net::HTTP.new(url.host, url.port);
  request = Net::HTTP::Get.new(url)
  response = http.request(request)
  obj = JSON.parse(response.read_body)

  @oanda = obj['rates']['avg_bid']
end

def lme_sme_ave
  (@lme[1].to_f + (@smm[1].split("-").first.gsub(",", "").to_f / exchange_rates_api))/2
end

table = TTY::Table.new do |t|
  t << ['LME', 'SME', 'Rate', 'Ave LME/SME']
  t << [
    "#{FriendlyNumbers.number_to_currency @lme[1].to_f}",
    "#{@smm[1].split("-").first.gsub(",", "").to_f}",
    "#{FriendlyNumbers.number_to_currency exchange_rates_api.to_f, precision: 4}",
    "#{FriendlyNumbers.number_to_currency lme_sme_ave.to_f}"
  ]
end
table = table.render width: 60, resize: true, alignments: [:right, :right, :right, :right]

# Output
welcome = Artii::Base.new
puts Rainbow(welcome.asciify("Vertilux's LME Scraper")).red
puts table
