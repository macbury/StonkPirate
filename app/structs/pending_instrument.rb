require 'csv'

class PendingInstrument < Dry::Struct
  attribute :name, Types::String
  attribute :symbol, Types::String
  attribute :isin, Types::String.optional

  def ticker
    symbol.split(':')[0]
  end

  def exchange
    symbol.split(':')[1]
  end

  def to_a
    to_h.values
  end

  def self.to_csv(items)
    CSV.generate(headers: true) do |csv|
      csv << items[0].to_h.keys.map { |k| k.to_s.humanize }

      items.each { |item| csv << item.to_a }
    end
  end

  def self.dump(items, path)
    f = File.new(path, 'w') 
    f.write(PendingInstrument.to_csv(items))
    f.close
  end
end