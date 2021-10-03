module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    extend Usable

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  end
end
