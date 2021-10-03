module Nbp
  class ReadChartService < Service
    def initialize
      @country = 'PL'
    end

    def call
      last_point_date = repo.latest_timestamp(country) || 100.years.ago

      points = data.map { |timestamp, value| { value: value, timestamp: Time.at(timestamp.to_f/1000.0) } }.reject do |point|
        point[:timestamp].before?(last_point_date) || point[:timestamp] == last_point_date
      end

      return false if points.empty?

      info "Saving: #{points.size} points from #{last_point_date}"

      points.each do |point|
        info "Writing point: #{point}"
        repo.write(country: country, value: point[:value], timestamp: point[:timestamp])
      end
      
      true
    end

    private

    attr_reader :country

    def endpoint
      raise NotImplementedError
    end

    def repo
      raise NotImplementedError
    end

    def client
      @client ||= Faraday.new do |f|
        f.request :retry
      end
    end

    def data
      @data ||= JSON.parse(client.get(endpoint).body[4..-5])
    end
  end
end