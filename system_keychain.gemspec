Gem::Specification.new do |s|
  s.name        = 'system_keychain'
  s.version     = '1.0.1'
  s.date        = "#{Time.now.strftime '%Y-%m-%d'}"
  s.summary     = "System Keychain"
  s.description = "Store account credentials in the OS keychain"
  s.authors     = ["Aaron VonderHaar"]
  s.email       = 'gruen0aermel@gmail.com'
  s.homepage    = 'http://github.com/avh4/system_keychain'
  s.license     = 'MIT'

  s.add_dependency('colorize', '>= 0.5.8')
  s.add_dependency('highline', '>= 1.6.19')

  s.files       += Dir.glob("lib/**/*")
end