module Mutations
  module Categories
    class Destroy < BaseMutation
      null true

      argument :id, ID, required: true

      field :success, Boolean, null: true

      def resolve(id:)
        category = Category.find(id)

        {
          success: category.destroy
        }
      end
    end
  end
end