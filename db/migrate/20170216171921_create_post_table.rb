class CreatePostTable < ActiveRecord::Migration
  def change
    create table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :text
  end
end
