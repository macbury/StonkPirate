class StonksPirateSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # Union and Interface Resolution
  def self.resolve_type(abstract_type, obj, ctx)
    # TODO: Implement this function
    # to return the correct object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.error "RecordNotFound: #{exception}"
    nil
  end

  rescue_from ServiceFailure do |exception|
    Rails.logger.error "Service Failure: #{exception}"
    { errors: [exception.to_s] }
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    Rails.logger.error "Validation error: #{exception}"
    { errors: exception.record.errors.full_messages }
  end
end
