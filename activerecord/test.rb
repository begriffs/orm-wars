require 'rubygems'
require 'active_record'
require 'activerecord-import'
require 'logger'
require 'yaml'

ActiveRecord::Base.establish_connection(
  YAML::load(File.open('db/config.yml'))
)

class User < ActiveRecord::Base
  belongs_to :group
end
class Group < ActiveRecord::Base
  has_many :users
end

# Do something in the DB...when you awake it will have been a dream
def dream title, &blk
  time = nil
  puts "#"*80
  puts "### Dreaming of #{title}" if title
  ActiveRecord::Base.transaction do
    build_groups
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    time = Benchmark.measure &blk
    raise ActiveRecord::Rollback
  end
  ActiveRecord::Base.logger = nil
  puts "### Time elapsed #{time.to_s.strip}"
  puts "#"*80 + "\n\n\n"
end

def build_groups
  groups = []
  3.times { groups << Group.new }
  Group.import groups

  groups = Group.find(:all, :limit => 2)

  users = []
  100.times do |i|
    users << User.new(group: groups[i%2])
  end
  User.import users
end

dream "finding empty groups" do
  empties = Group.all(
    :joins => "LEFT OUTER JOIN users u ON u.group_id = groups.id",
    :conditions => "u.group_id IS NULL")
  puts empties.count
end

dream "listing count of users in each group by repeated queries" do
  counts = []
  Group.all.each do |g|
    counts << g.users.count
  end
  puts counts
end

dream "listing count of users in each group by using group-by" do
  counts = User.count(group: 'users.group_id')
  puts counts
end
