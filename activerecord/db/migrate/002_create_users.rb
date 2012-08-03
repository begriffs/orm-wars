class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users
    add_column :users, :group_id, :integer
    add_foreign_key :users, :groups
  end

  def self.down
    drop_table :users
  end
end
