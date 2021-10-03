module Stats
  class Base < Repository
    def write(country:, value:, timestamp:)
      writer.write(data: {
        name: ticker,
        tags: { country: country },
        fields: { 
          value: value.to_f,
        },
        time: timestamp.to_i,
        precision: '1mo'
      })
    end
  
    def latest(country, stop: Time.zone.now)
      query = <<-FLUX
        from(bucket: "{{ bucket }}")
          |> range(start: {{ start }}, stop: {{ stop }})
          |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
          |> filter(fn: (r) => r["_field"] == "value")
          |> filter(fn: (r) => r["country"] == "{{ country }}")
          |> sort(columns: ["_time"], desc: true)
          |> limit(n: 1)
          |> yield(name: "_value")
      FLUX
  
      execute query, country: country, stop: (stop).to_datetime.to_i, start: (stop - 6.months).to_datetime.to_i, ticker: ticker
    end
  
    def latest_timestamp(country)
      time = latest(country).values.first&.records&.first&.time
      return Time.zone.parse(time) if time
      nil
    end

    private

    def bucket
      'stats'
    end
  end
end