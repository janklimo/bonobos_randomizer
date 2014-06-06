class CreateOutfits < ActiveRecord::Migration
  def change
    create_table :outfits do |t|
      t.string :type
      t.string :shirt
      t.string :blazer

      t.timestamps
    end
  end
end
