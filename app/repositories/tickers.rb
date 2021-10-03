class Tickers < Repository
  def write(ticker, data, currency, precision: nil)
    writer.write(
      data: data.map do |row|
        {
          name: ticker,
          tags: { currency: currency },
          fields: { 
            value: row[:value].to_f, 
            volume: row[:volume].to_i, 
            highest: row[:highest].to_f, 
            lowest: row[:lowest].to_f, 
            opening: row[:opening].to_f
          },
          time: row[:timestamp].to_i,
          precision: precision
        }
      end
    )
  end

  def write_stats(ticker, pe:)
    writer.write(data: { name: ticker, fields: { pe: pe }, precision: '1d' })
  end

  def values(ticker, raw: false)
    query = <<-FLUX
      import "interpolate"

      from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: now())
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> aggregateWindow(every: 1d, fn: mean, createEmpty: false)
        |> filter(fn: (r) => r["_value"] > 0.0)
        |> interpolate.linear(every: 1d)
        |> yield(name: "_value")
    FLUX

    execute(query, ticker: ticker.to_s, start: '-10y', raw: raw)[0]
  end

  def history(ticker, start:, stop:, aggregate: '1mo')
    query = <<-FLUX
      import "interpolate"

      from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: {{ stop }})
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> aggregateWindow(every: {{ aggregate }}, fn: last, createEmpty: false)
        |> filter(fn: (r) => r["_value"] > 0.0)
        |> interpolate.linear(every: {{ aggregate }})
        |> yield(name: "_value")
    FLUX

    execute(query, ticker: ticker.to_s, start: start.strftime('%Y-%m-%d'), stop: stop.strftime('%Y-%m-%d'), aggregate: aggregate)[0]
  end

  def exchange_history(ticker, start:, stop:, aggregate: '1mo', ticker_currency:, default_currency: ::Money.default_currency)
    query = <<-FLUX
      import "interpolate"

      asset = from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: {{ stop }})
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> aggregateWindow(every: {{ aggregate }}, fn: last, createEmpty: false)
        |> filter(fn: (r) => r["_value"] > 0.0)
        |> interpolate.linear(every: {{ aggregate }})

      exchange = from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: {{ stop }})
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker_currency }}{{ default_currency }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> aggregateWindow(every: {{ aggregate }}, fn: last, createEmpty: false)
        |> interpolate.linear(every: {{ aggregate }})

      join(tables: { asset: asset, exchange: exchange }, on:["_time"])
        |> map(fn: (r) => ({
            _time: r._time,
            _value: r._value_asset * r._value_exchange
          })
        )
        |> filter(fn: (r) => r["_value"] > 0.0)
    FLUX

    execute(
      query,
      ticker: ticker.to_s,
      start: start.strftime('%Y-%m-%d'),
      stop: stop.strftime('%Y-%m-%d'),
      aggregate: aggregate,
      ticker_currency: ticker_currency,
      default_currency: default_currency
    )[0]
  end

  def exchange_values(ticker, ticker_currency:, default_currency: ::Money.default_currency, raw: false)
    query = <<-FLUX
      import "interpolate"

      asset = from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: now())
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> aggregateWindow(every: 1d, fn: mean, createEmpty: false)
        |> interpolate.linear(every: 1d)

      exchange = from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: now())
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker_currency }}{{ default_currency }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> aggregateWindow(every: 1d, fn: mean, createEmpty: false)
        |> interpolate.linear(every: 1d)

      join(tables: { asset: asset, exchange: exchange }, on:["_time"])
        |> map(fn: (r) => ({
            _time: r._time,
            _value: r._value_asset * r._value_exchange
          })
        )
        |> filter(fn: (r) => r["_value"] > 0.0)
    FLUX

    execute(query, ticker: ticker.to_s, start: '-10y', ticker_currency: ticker_currency, default_currency: default_currency, raw: raw)[0]
  end

  def count(ticker)
    query = <<-FLUX
      from(bucket: "{{ bucket }}")
        |> range(start: -10y, stop: now())
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> group()
        |> keep(columns: ["_value"])
        |> unique(column: "_value")
        |> count(column: "_value")
    FLUX
    execute(query, ticker: ticker.to_s).values.first&.records&.first&.value || 0
  end

  def latest(ticker, stop: Time.zone.now)
    query = <<-FLUX
      from(bucket: "{{ bucket }}")
        |> range(start: {{ start }}, stop: {{ stop }})
        |> filter(fn: (r) => r["_measurement"] == "{{ ticker }}")
        |> filter(fn: (r) => r["_field"] == "value")
        |> sort(columns: ["_time"], desc: true)
        |> limit(n: 1)
        |> yield(name: "_value")
    FLUX

    execute query, ticker: ticker, stop: stop.to_datetime.to_i, start: (stop - 10.years).to_datetime.to_i
  end

  def latest_timestamp(ticker)
    time = latest(ticker).values.first&.records&.first&.time
    return Time.zone.parse(time) if time
    nil
  end

  private

  def bucket
    'assets'
  end
end