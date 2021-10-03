module Types
  class AssetKindEnum < Types::BaseEnum
    ::Asset.kinds.each do |key, value|
      value key.upcase, value: value
    end
  end
end