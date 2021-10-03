class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :assets, id: :string do |t|
      t.string :name
      t.string :exchange
      t.string :currency
      t.string :country
      t.string :symbol
      t.string :kind, default: 'unknown'
      t.string :status, default: 'initializing'

      t.timestamps
    end
  end
end
