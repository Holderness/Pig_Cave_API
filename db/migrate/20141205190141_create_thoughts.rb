class CreateThoughts < ActiveRecord::Migration
  def change
    create_table :thoughts do |t|
      t.integer :score
      t.text :title
      t.string :author
      t.string :permalink

      t.timestamps
    end
  end
end
