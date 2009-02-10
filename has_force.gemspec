Gem::Specification.new do |s|
  s.name              = 'has_force'
  s.version           = '1.0.2'
  s.date              = '2009-02-10'
  
  s.summary           = "SalesForce.com Web2Lead Submission"
  s.description       = "The has_force library will provide a simple SalesForce.com submission tool to allow you to capture leads from your ActiveRecord models without utilizing the SalesForce.com API"
  
  s.authors           = "Sean O'Brien"
  s.email             = 'sean.ducttape.it'
  s.homepage          = 'http://github.com/sob/has_force'
  
  s.has_rdoc          = true
  s.rdoc_options      = ['--main', 'README.rdoc']
  s.rdoc_options     << '--inline-source' << '--charset=UTF-8'
  s.extra_rdoc_files  = ['README.rdoc', 'MIT-LICENSE']
  
  s.files             = %w(CHANGELOG.rdoc MIT-LICENSE README.rdoc Rakefile lib lib/force lib/force.rb lib/force/core_ext lib/force/core_ext/array.rb lib/force/core_ext/hash.rb lib/force/has_force.rb rails rails/init.rb test test/core_ext_test.rb test/database.yml test/has_force_test.rb test/schema.rb test/test_helper.rb)
  s.test_files        = %w(test/core_ext_test.rb test/database.yml test/has_force_test.rb test/schema.rb test/test_helper.rb)
end