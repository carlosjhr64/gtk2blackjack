require 'date'
require 'find'

project_version = File.expand_path( File.dirname(__FILE__) ).split(/\//).last
project, version = nil, nil
if project_version=~/^(\w+)-(\d+\.\d+\.\d+)$/ then
  project, version = $1, $2
else
  raise 'need versioned directory'
end

spec = Gem::Specification.new do |s|
  s.name = project
  s.version = version
  s.date = Date.today.to_s
  s.summary = `head -n 1 README.txt`.strip
  s.email = "carlosjhr64@gmail.com"
  s.homepage = 'https://sites.google.com/site/gtk2applib/home/gtk2applib-applications/gtk2blackjack'
  s.description = `head -n 5 README.txt | tail -n 3`
  s.has_rdoc = false
  s.authors = ['carlosjhr64@gmail.com']

  files = []
  # Rbs
  Find.find('./lib'){|fn|
    if fn=~/\.rb$/ then
      files.push(fn)
    end
  }

  Find.find('./pngs'){|fn|
    if fn=~/\.png$/ then
      files.push(fn)
    end
  }

  files.push('data/deck.dat')
  files.push('README.txt')
  files.push('bin/bjserver')
  files.push('bin/gtk2fixed_client')

  s.files = files

  s.executables = ['gtk2blackjack']
  s.default_executable = 'gtk2blackjack'

  s.add_dependency('gtk2applib','~> 15.3')
  s.requirements << 'gtk2'

 # s.require_path = '.'

 # s.rubyforge_project = project
end
