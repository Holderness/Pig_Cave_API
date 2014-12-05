class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :score
      t.string :title
      t.string :author
      t.string :permalink

      t.timestamps
    end
  end
end
