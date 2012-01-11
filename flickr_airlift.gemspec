$spec = Gem::Specification.new do |s|
  s.name        = "flickr_airlift"
  s.description = "A Command-Line tool for scraping any user's original photos OR uploading all photos from a given directory"
  s.version     = '0.2.1'
  s.summary     = "A Command-Line tool for scraping any user's original photos OR uploading all photos from a given directory"

  s.authors   = ['Stephen Schor']
  s.email     = ['beholdthepanda@gmail.com']
  s.homepage  = 'https://github.com/nodanaonlyzuul/flickr_airlift'

  s.executables   =  ['flickr_airlift', 'flickr_uplift']
  s.files         = Dir['bin/*','lib/**/*']

  s.add_dependency('launchy',  '0.4.0')
  s.add_dependency('flickraw', '0.8.4')

  s.rubyforge_project = 'nowarning'
end