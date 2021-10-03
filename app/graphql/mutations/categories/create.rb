module Mutations
  module Categories
    class Create < BaseMutation
      null true

      argument :name, String, required: true

      field :errors, [String], null: false
      field :category, Types::CategoryType, null: true

      def resolve(...)
        {
          category: Category.create!(...),
          errors: []
        }
      end
    end
  end
end