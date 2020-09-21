$LOAD_PATH.push File.expand_path('../lib', __FILE__)

version = File.read(File.join(File.dirname(__FILE__), 'VERSION')).strip

Gem::Specification.new do |s|
  s.name = 'stealth-twilio'
  s.summary = 'Stealth Twilio SMS driver'
  s.description = 'Twilio SMS driver for Stealth.'
  s.homepage = 'https://github.com/hellostealth/stealth-twilio'
  s.licenses = ['MIT']
  s.version = version
  s.author = 'Mauricio Gomes'
  s.email = 'mauricio@edge14.com'

  s.add_dependency 'stealth', '~> 2'
  s.add_dependency 'twilio-ruby', '~> 5.5'

  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  s.add_development_dependency 'rack-test', '~> 1.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
