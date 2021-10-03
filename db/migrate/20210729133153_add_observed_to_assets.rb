class AddObservedToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :observed, :boolean
  end
end
