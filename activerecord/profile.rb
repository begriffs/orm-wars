require 'rubygems'
require 'active_record'
require 'activerecord-import'
require 'logger'
require 'yaml'

ActiveRecord::Base.establish_connection(
  YAML::load(File.open('db/config.yml'))
)
ActiveRecord::Base.logger = Logger.new(STDOUT)

class User < ActiveRecord::Base
end
 
puts User.count
