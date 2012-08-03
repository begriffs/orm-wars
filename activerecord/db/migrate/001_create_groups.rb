class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups
  end

  def self.down
    drop_table :groups
  end
end
