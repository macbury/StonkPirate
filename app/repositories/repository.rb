class Repository
  def initialize(precision: InfluxDB2::WritePrecision::SECOND)
    @client = InfluxDB2::Client.new(ENV.fetch('INFLUXDB_URL'), ENV.fetch('INFLUXDB_TOKEN'), 
      bucket: bucket,
      org: org_name,
      precision: precision,
      use_ssl: false
    )
  end

  def create_bucket!
    api = management.create_buckets_api
    return true if api.get_buckets.buckets.find { |b| b.name == bucket }

    request = InfluxDB2::API::PostBucketRequest.new(org_id: organization.id, name: bucket, retention_rules: [])
    api.post_buckets(request)
  end

  def execute(query, **kwargs)
    variables = (kwargs || {}).merge(bucket: bucket)
    Rails.logger.tagged('Flux') do 
      Rails.logger.info "Variables: #{variables.inspect}"
      final_query = Mustache.render(query, variables)
      Rails.logger.info "Execute:\n#{final_query}"

      variables[:raw] ? query_api.query_raw(query: final_query) : query_api.query(query: final_query)
    end
  end

  private

  attr_reader :client

  def bucket
    raise NotImplementedError
  end

  def org_name
    'stonks'
  end

  def organization
    @organization ||= management.create_organizations_api.get_orgs.orgs.select { |it| it.name == org_name }.first
  end

  def management
    @management ||= InfluxDB2::API::Client.new(client)
  end

  def writer
    @writer ||= client.create_write_api
  end

  def query_api
    @query_api ||= client.create_query_api
  end
end