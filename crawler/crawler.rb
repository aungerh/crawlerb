require('nokogiri')
require('open-uri')
require('fileutils')
require('terminal-table')
require_relative('../mixins')

class Crawler
  # crawler visit sites:
  # 1. collect links.
  # 2. looks for the source script (in the same request).
  # 3. adds the link to the list of visited.

  # changes are written to state and persisted in the instance of crawler.
  attr_accessor :state

  attr_accessor :script
  attr_accessor :sources
  attr_accessor :visited
  attr_accessor :to_visit

  def initialize(script, sources)
    create_file("results/crawl_results", "txt")
    self.sources = sources
    self.script = script
    self.to_visit = []
    self.visited = []
    self.state = {}
  end

  # TODO - get all the anchors on a website and add it to the `to_visit' list if they belong to the same domain.
  def start()
    self.sources.each do |src|
      doc = Nokogiri::HTML(open(src))
      has_script(doc) ? self.state[src] = [src, '✔'] : self.state[src] = [src, ' ']
      get_link_from_doc(doc)
      self.visited << src
    end

    write_results()
  end

  # from a site source gets all the anchors.
  def get_link_from_doc(doc)
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