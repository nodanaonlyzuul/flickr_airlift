$spec = Gem::Specification.new do |s|
  s.name = "flickr_airlift"
  s.version = '0.0.2'
  s.summary = "A Command-Line tool for scraping any user's original photos"

  s.authors  = ['Stephen Schor']
  s.email    = ['beholdthepanda@gmail.com']
  s.homepage = 'https://github.com/nodanaonlyzuul/flickr_airlift'

  s.executables = ['flickr_airlift']

  s.files = Dir['bin/*','lib/**/*']
  s.rubyforge_project = 'nowarning'
end