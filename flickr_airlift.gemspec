$spec = Gem::Specification.new do |s|
  s.name        = "flickr_airlift"
  s.description = "A Command-Line tool for scraping any user's original photos"
  s.version     = '0.1.0'
  s.summary     = "A Command-Line tool for scraping any user's original photos"

  s.authors   = ['Stephen Schor']
  s.email     = ['beholdthepanda@gmail.com']
  s.homepage  = 'https://github.com/nodanaonlyzuul/flickr_airlift'

  s.executables   =  ['flickr_airlift', 'flickr_uplift']
  s.files         = Dir['bin/*','lib/**/*']

  s.add_dependency('launchy')
  s.add_dependency('flickraw')

  s.rubyforge_project = 'nowarning'
end