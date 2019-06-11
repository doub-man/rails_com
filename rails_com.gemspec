$:.push File.expand_path('lib', __dir__)
require 'rails_com/version'

Gem::Specification.new do |s|
  s.name = 'rails_com'
  s.version = RailsCom::VERSION
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_com'
  s.summary = 'Rails Engine with common utils'
  s.description = 'Common utils for Rails Application'
  s.license = 'LGPL-3.0'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'Rakefile',
    'LICENSE',
    'README.md'
  ]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '5.1.5'
  s.add_dependency 'httparty', '>= 0.16', '<= 1.0'
  s.add_dependency 'default_where', '~> 2.2'
  s.add_dependency 'default_form', '~> 1.3'
end
