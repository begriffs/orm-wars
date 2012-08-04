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
  Group.import [Group.new]*3
  groups = Group.find(:all, :limit => 2)
  User.import (0...100).map { |i| User.new(group: groups[i%2]) }
end

dream "finding empty groups by looping" do
  puts Group.all.select { |g| g.users.count == 0 }
end

dream "finding empty groups with left join" do
  empties = Group.all(
    :joins => "LEFT OUTER JOIN users u ON u.group_id = groups.id",
    :conditions => "u.group_id IS NULL")
  puts empties.count
end

dream "finding empty groups with includes" do
  empties = Group.includes(:users).where('users.group_id' => nil).all
  puts empties.count
end

dream "finding empty groups with subquery" do
  puts ActiveRecord::Base.connection.execute(<<query
    select id from groups
    where not exists
      (select 1 from users where group_id = groups.id)
query
  ).to_a
end

dream "listing count of users in each group by repeated queries" do
  Group.all.each do |g|
    puts g.users.count
  end
end

dream "listing count of users in each group ala Jaymes" do
  Group.includes(:users).map {|group| puts group.id, group.users.count }
end

dream "listing count of users in each group using sql subquery" do
  puts ActiveRecord::Base.connection.execute(<<query
    select id, (select count(1) from users where group_id = groups.id)
    from groups
query
  ).to_a
end
