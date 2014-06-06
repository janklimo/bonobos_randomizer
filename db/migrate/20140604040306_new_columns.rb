class NewColumns < ActiveRecord::Migration
  def up
  	remove_column :outfits, :outfit_setting
  	add_column :outfits, :tie, :string
  	add_column :outfits, :pocket_square, :string
		add_column :outfits, :pants, :string
		add_column :outfits, :shoes, :string
		add_column :outfits, :belt, :string
		add_column :outfits, :bag, :string
		add_column :outfits, :socks, :string
  end

  def down
  	add_column :outfits, :outfit_setting, :string
  	remove_column :outfits, :tie, :string
  	remove_column :outfits, :pocket_square, :string
		remove_column :outfits, :pants, :string
		remove_column :outfits, :shoes, :string
		remove_column :outfits, :belt, :string
		remove_column :outfits, :bag, :string
		remove_column :outfits, :socks, :string
  end
end
