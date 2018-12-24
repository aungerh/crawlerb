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
# The crawler has 2 phases
#   1. find links and add them to the state
#   2. get the html document and find the source script

class Crawler
  attr_accessor :uri
  attr_accessor :state
  attr_accessor :script
  attr_accessor :domain
  attr_accessor :contains_script

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

  def initialize
    create_file("results/crawl_results", "txt")
    self.uri = URI.parse(Crawler.configuration.domain)
    self.domain = Crawler.configuration.domain
    self.script = Crawler.configuration.script
    self.contains_script = []
    self.state = {}
  end

  def start
    update_state(Nokogiri::HTML(open(self.domain)))
    expand_links()
    write_results()
  end

  def update_state(doc)
    anchors = doc.css('a')
    base = self.uri

    anchors.each do |a|
      path = a['href']
      unless invalid(path) then
        a[0] == '/' ? base.path = URI::encode(path) : base.path = "/#{URI::encode(path)}"
        self.state[base.to_s] = [base.to_s, ' ']
      end
    end
  end

  def has_script(doc)
    return doc.css('script').collect{|s| s.values[1]}.compact.include?(self.script)
  end

  def expand_links
    self.state.values.each do |v|
      doc = Nokogiri::HTML(open(v[0]))
      update_state(doc)
      self.contains_script << v[0] if has_script(doc)
    end
  end

  def write_results
    f = File.open("results/crawl_results.txt", "w+")
    self.contains_script.each{|c| self.state[c][1] = 'x'}
    f.write(Terminal::Table.new :rows => self.state.values)
    f.close()
  end

  def print_stats
    # aims to provide stats for the crawler:
    # amount of visited urls
    # current url being crawled
    # real time updates on how many visited links contain the source script
    # scould update every 500 to 1000 milliseconds
  end
end