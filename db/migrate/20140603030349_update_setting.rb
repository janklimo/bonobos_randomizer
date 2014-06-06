class UpdateSetting < ActiveRecord::Migration
  def up
  	rename_column("outfits", "type", "outfit_setting")
  end

  def down
  	rename_column("outfits", "outfit_setting", "type")
  end

end
