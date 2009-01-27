require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the test plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the test plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'has_force'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--webcvs=http://github.com/sob/has_force/tree/master/'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Update .manifest with the latest list of project filenames'
task :manifest do
  list = Dir['**/*'].sort
  spec_file = Dir['*.gemspec'].first
  list -= [spec_file] if spec_file
  
  File.read('.gitignore').each_line do |glob|
    glob = glob.chomp.sub(/^\//, '')
    list -= Dir[glob]
    list -= Dir["#{glob}/**/*"] if File.directory?(glob) && !File.symlink?(glob)
    puts "excluding #{glob}"
  end
  
  if spec_file
    spec = File.read spec_file
    spec.gsub! /^(\s* s.(test_)?files \s* = \s* )( \[ [^\]]* \] | %w\( [^)]* \) )/mx do
      assignment = $1
      bunch = $2 ? list.grep(/^test\//) : list
      '%s%%w(%s)' % [ assignment, bunch.join(' ') ]
    end
    
    File.open(spec_file, 'w') {|f| f << spec }
  end
  File.open('.manifest', 'w') {|f| f << list.join("\n") }
end