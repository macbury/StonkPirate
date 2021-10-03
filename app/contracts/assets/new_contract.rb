module Assets
  class NewContract < ApplicationContract
    params do
      required(:ticker).value(:string)
    end

    rule(:ticker) do
      if ticker = Ticker.parse(value)
        key.failure('already exist') unless Asset.by_ticker(ticker).count.zero?
      else
        key.failure('invalid ticker')
      end
    end
  end
end