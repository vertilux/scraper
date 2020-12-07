# Vertilux's LME/SME Web scraper
```
 __      __       _   _ _
 \ \    / /      | | (_) |
  \ \  / /__ _ __| |_ _| |_   ___  __
   \ \/ / _ \ '__| __| | | | | \ \/ /
    \  /  __/ |  | |_| | | |_| |>  <
     \/ \___|_|   \__|_|_|\__,_/_/\_\
```
Simple web scraper to calculate the LME and SME rates.

## Vertilux
Vertilux is one of the largest manufacturers and distributors of fabrics, components and automated solutions for the Window Covering Industry.   
With more than 35 years of experience, Vertilux offers its clients the best fabrics and decorative & technical solutions, which ensure a successful business through an excellent service and professional advice, oriented to the consumer.

## How to

### Install
Clone the script: `git clone https://github.com/vertilux/scraper.git` the `cd scraper`.   

### Set env variables
Set environment variables, and make sure to change: IP_ADDRESS, DB_NAME, DB_PORT, SAGE_USER and SAGE_PASSWD:   

`echo 'export ACCLTD_HOST="IP_ADDRESS"' >> ~/.bashrc`   
`echo 'export ACCLTD_DB="DB_NAME"' >> ~/.bashrc`   
`echo 'export ACCLTD_DB="DB_PORT"' >> ~/.bashrc`   
`echo 'export SAGE_USER="USER"' >> ~/.bashrc`   
`echo 'export SAGE_PASSWD="PASSWORD"' >> ~/.bashrc`   

### Execute
Run it by simple execute ruby script: `bundle exec ruby scrapper`.

### TODO

* If record saved send email or slack message
