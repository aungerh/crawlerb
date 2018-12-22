require_relative("mixins.rb")
require_relative("crawler/crawler.rb")

config = _get_config()
crwlr = Crawler.new(config["script"], config["sources"])

crwlr.start()