require_relative('crawler/crawler.rb')

Crawler.configure do |config|
  config.domain = "https://www.biocompany.de"
  config.script = "https://uberall.com/assets/storeFinderWidget-v2.js"
end