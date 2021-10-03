module Types
  class AssetStatusEnum < Types::BaseEnum
    ::Asset.statuses.each do |key, value|
      value key.upcase, value: value
    end
  end
end