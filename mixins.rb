# creates a file in the specified directory
def create_file(path, extension)
  dir = File.dirname(path)

  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  path << ".#{extension}"
  File.new(path, 'w')
end