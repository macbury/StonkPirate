class AddDescriptionToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :description, :text, default: ''
  end
end
