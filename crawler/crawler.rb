require('nokogiri')
require('open-uri')
require('fileutils')
require('terminal-table')
require_relative('../mixins')

# Crawler visit sites:
# 1. collect links.
# 2. looks for the source script (in the same request).
# 3. adds the link to the list of visited.
# 4. it will ONLY crawl resources from the requested site, never related ones like google or facebook.

class Crawler
  attr_accessor :state
  attr_accessor :script
  attr_accessor :domain
  attr_accessor :visited
  attr_accessor :to_visit

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :domain
    attr_accessor :script

    def initialize
      @domain = 'https://example.com'
      @script = 'example.js'
    end
  end

  def initialize()
    create_file("results/crawl_results", "txt")
    self.domain = Crawler.configuration.domain
    self.script = Crawler.configuration.script
    self.to_visit = []
    self.visited = []
    self.state = {}
  end

  # TODO - get all the anchors on a website and add it to the `to_visit' list if they belong to the same domain.
  def start()
    run_entry_point()
    # run_main_loop()
    write_results()
  end

  def run_entry_point()
    e = self.domain
    doc = Nokogiri::HTML(open(e))
    has_script(doc) ? self.state[e] = [e, '✔'] : self.state[e] = [e, ' ']
    links(doc)
    self.visited << e
  end

  def run_main_loop()
    # TODO - implement
  end

  def links(doc)
    anchors = doc.css('a')
    anchors.each do |a|
      # TODO - sanitize: remove empty, recognize which typeof link we encountered.
      self.state[a] = [a['href'], ' ']
    end
  end

  def write_results()
    f = File.open("results/crawl_results.txt", "w+")
    f.write(Terminal::Table.new :rows => self.state.values)
    f.close()
  end

  def print_stats()
    # aims to provide stats for the crawler:
    # amount of visited urls
    # current url being crawled
    # real time updates on how many visited links contain the source script
    # scould update every 500 to 1000 milliseconds
  end

  # TODO - error handling. 404 and all the like.
  def has_script(doc)
    return doc.css('script').collect{|s| s.values[1]}.compact.include?(self.script)
  end
end