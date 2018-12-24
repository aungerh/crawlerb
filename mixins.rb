# creates a file in the specified directory
def create_file(path, extension)
  dir = File.dirname(path)

  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end

  path << ".#{extension}"
  File.new(path, 'w')
end

# urls that point out of the domain are not considered
def invalid(path)
  path.nil? or
  path.empty? or
  path.include?('https') or
  path.include?('http') or
  path.include?('?')
end