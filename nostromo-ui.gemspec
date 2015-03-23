# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nostromo_ui/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'nostromo-ui'
  s.version      = NostromoUI::VERSION
  s.author       = 'Gusztav Szikszai'
  s.email        = 'gusztav.szikszai@digitalnatives.hu'
  s.homepage     = ''
  s.summary      = 'UI Elements For Nostromo'
  s.description  = 'UI Elements For Nostromo'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', ['~> 0.6.0']
  s.add_development_dependency 'opal-rspec', '~> 0.3.0'
end
