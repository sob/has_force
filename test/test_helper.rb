ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..'))

require 'test/unit'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config', 'environment.rb'))

def load_schema
  config = YAML::load(IO.read(File.expand_path(File.join(File.dirname(__FILE__), 'database.yml'))))
  ActiveRecord::Base.logger = Logger.new(File.expand_path(File.join(File.dirname(__FILE__), 'debug.log')))
  
  db_adapter = ENV['db']
  
  db_adapter ||=
    begin
      require 'rubygems'
      require 'sqlite'
      'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
        'sqlite3'
      rescue MissingSourceFile
      end
    end
  
  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one or install sqlite or sqlite3"
  end
  
  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.expand_path(File.join(File.dirname(__FILE__), 'schema.rb')))
  require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rails', 'init.rb'))
end