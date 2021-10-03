require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class Base < GraphQL::Schema::Resolver
    extend Usable
  end
end