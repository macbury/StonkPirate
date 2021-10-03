module Types
  class MoneyArgument < GraphQL::Schema::Scalar
    def self.coerce_input(value, _context)
      value.to_money
    end
  end
end