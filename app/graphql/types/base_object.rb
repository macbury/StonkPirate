module Types
  class BaseObject < GraphQL::Schema::Object
    extend Usable
    field_class Types::BaseField
  end
end
