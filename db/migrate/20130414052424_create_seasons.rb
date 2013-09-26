class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :year, :default => 0
      t.integer :subseason_id, :default => 0
      t.boolean :current, :default => false

      t.timestamps
    end
  end
end
