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
  belongs_to :group
end
class Group < ActiveRecord::Base
  has_many :users
end

# Do something in the DB...when you awake it will have been a dream
def dream title
  puts "### Dreaming of #{title} #{"#"*50}" if title
  ActiveRecord::Base.transaction do
    yield
    raise ActiveRecord::Rollback
  end
end

dream "finding empty groups" do
  groups = []
  3.times { groups << Group.new }
  Group.import groups

  groups = Group.find(:all, :limit => 2)

  users = []
  100.times do |i|
    users << User.new(group: groups[i%2])
  end
  User.import users

  puts Group.first.users.count
end
