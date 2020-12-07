require 'nokogiri'
require 'httparty'
require 'mechanize'
require "uri"
require "net/http"
require 'json'

require 'tty-table'
require 'artii'
require 'friendly_numbers'
require 'require_all'

require 'active_record'
require 'activerecord-sqlserver-adapter'
require_all 'config'
require_all 'app/models'

# Scrapping LME Website
lme_agent = Mechanize.new
lme_page = lme_agent.get('https://www.lme.com')
aluminum = lme_agent.page.links_with(:text => 'LME Aluminium')[1].click
lme = aluminum.xpath('/html/body/div/div[2]/div[2]/div[2]/div[1]/div[2]/section[1]/div/div[2]/div/div[2]/table/tbody/tr[2]/td[2]')
@lme = lme.to_s.gsub(/<\/?[^>]*>/, "")

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
  (@lme.to_f + (@smm[1].split("-").first.gsub(",", "").to_f / exchange_rates_api))/2
end

table = TTY::Table.new do |t|
  t << ['LME', 'SME', 'Rate', 'Ave LME/SME']
  t << [
    "#{FriendlyNumbers.number_to_currency @lme.to_f}",
    "#{@smm[1].split("-").first.gsub(",", "").to_f}",
    "#{FriendlyNumbers.number_to_currency exchange_rates_api.to_f, precision: 4}",
    "#{FriendlyNumbers.number_to_currency lme_sme_ave.to_f}"
  ]
end
table = table.render width: 60, resize: true, alignments: [:right, :right, :right, :right]

# Output
welcome = Artii::Base.new
puts welcome.asciify("Vertilux's LME Scraper")
puts table

DailyLme.new do |r|
  r.lme = @lme.to_f
  r.smm = @smm[1].split("-").first.gsub(",", "").to_f
  r.rate = exchange_rates_api
  r.oanda = oanda_average_rate
  r.save
end
