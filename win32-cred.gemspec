# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'win32/cred/version'

Gem::Specification.new do |spec|
  spec.name          = 'win32-cred'
  spec.version       = Win32::Cred::VERSION
  spec.authors       = ['Ben Vidulich']
  spec.email         = ['ben@vidulich.co.nz']

  spec.summary       = %q{Adds an interface to the Windows Credential API}
  spec.description   = %q{Adds an interface to the Windows Credential API}
  spec.homepage      = 'https://github.com/zl4bv/win32-cred'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'ffi'
end
