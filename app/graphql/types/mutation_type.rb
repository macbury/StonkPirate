module Types
  class MutationType < Types::BaseObject
    field :buy, mutation: Mutations::Holdings::Buy
    field :sell, mutation: Mutations::Holdings::Sell
    field :archive_holding, mutation: Mutations::Holdings::Archive

    field :observe, mutation: Mutations::Assets::Observe

    field :create_category, mutation: Mutations::Categories::Create
    field :update_category, mutation: Mutations::Categories::Update
    field :destroy_category, mutation: Mutations::Categories::Destroy
  end
end
