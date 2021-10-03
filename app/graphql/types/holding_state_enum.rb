module Types
  class HoldingStateEnum < Types::BaseEnum
    ::Holding.states.each do |key, value|
      value key.upcase, value: value
    end
  end
end