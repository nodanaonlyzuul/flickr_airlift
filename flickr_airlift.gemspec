$spec = Gem::Specification.new do |s|
  s.name = "flickr_airlift"
  s.version = '0.0.7'
  s.summary = "A Command-Line tool for scraping any user's original photos, or uploading all media in a given directory"

  s.authors  = ['Stephen Schor']
  s.email    = ['beholdthepanda@gmail.com']
  s.homepage = 'https://github.com/nodanaonlyzuul/flickr_airlift'

  s.executables = ['flickr_airlift', 'flickr_uplift']

  s.files = Dir['bin/*','lib/**/*']
  s.rubyforge_project = 'nowarning'
end