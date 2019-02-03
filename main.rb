require_relative('constants')
require_relative("crawler/crawler.rb")

puts "domain to crawl:"
domain = gets

puts "script name: (use default?: `#{@script_name_default}`) [Y/n]?"
script = gets
if script == 'Y' or 'y' then
  script = "#{@script_name_default}"
end

Crawler.configure do |config|
  config.domain = "#{domain.strip}"
  config.script = "#{script.strip}"
end

Crawler.new().start()