class AddLogoToAssets < ActiveRecord::Migration[6.1]
  def change
    add_column :assets, :logo_data, :jsonb
  end
end
