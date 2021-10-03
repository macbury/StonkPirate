module Mutations
  module Categories
    class Update < BaseMutation
      null true

      argument :id, ID, required: true
      argument :name, String, required: true

      field :errors, [String], null: false
      field :category, Types::CategoryType, null: true

      def resolve(id:, name:)
        category = Category.find(id)
        {
          category: category.update!(name: name),
          errors: []
        }
      end
    end
  end
end