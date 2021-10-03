require 'graphql/rake_task'

GraphQL::RakeTask.new(
  schema_name: 'StonksPirateSchema',
  json_outfile: 'schema.json',
  idl_outfile: 'schema.graphql'
)

namespace :graphql do
  desc 'Generate client headers'
  task dump: :environment do
    Rake::Task['graphql:schema:dump'].invoke
    frontend_path = Rails.root
    puts "Opening #{frontend_path}"
    puts `cd #{frontend_path} && yarn graphql:codegen`
  end
end