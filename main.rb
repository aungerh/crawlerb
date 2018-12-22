require_relative("mixins.rb")
require_relative("config.rb")
require_relative("crawler/crawler.rb")

crwlr = Crawler.new()

crwlr.start()