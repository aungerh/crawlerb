def _get_config()
  return {
    "script" => "https://uberall.com/assets/storeFinderWidget-v2.js",
    "sources" => [
      "https://www.biocompany.de/bio-company-markt-finden/",
      "https://www.biocompany.de"
    ]
  }
end

# creates a file in the specified directory
def create_file(path, extension)
  dir = File.dirname(path)

  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  path << ".#{extension}"
  File.new(path, 'w')
end