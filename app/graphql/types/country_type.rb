module Types
  class CountryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :region, String, null: false
    field :flag, String, null: false

    def id
      object.alpha2
    end

    def flag
      object.emoji_flag
    end
  end
end
