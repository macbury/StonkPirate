class CreateBuckets < ActiveRecord::Migration[7.0]
  def change
    Tickers.new.create_bucket!
    Stats::Base.new.create_bucket!
  end
end
