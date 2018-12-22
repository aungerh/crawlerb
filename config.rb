require_relative('crawler/crawler.rb')

Crawler.configure do |config|
  config.domain = "https://www.biocompany.de"
end