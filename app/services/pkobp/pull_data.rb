module Pkobp
  class PullData < BrowserService
    SYMBOL_REGEXP = /(?<symbol>[a-z]+)/i
    ENDPOINT = 'https://www.zakup.obligacjeskarbowe.pl/login.html'

    def call
      info "Visiting: #{ENDPOINT}"
      browser.get(ENDPOINT)

      sleep 5
      find_element(id: 'username').send_keys Setting.get(:polish_bonds_login)
      find_element(id: 'password').send_keys Setting.get(:polish_bonds_password)

      find_element(id: 'baton').click

      return {
        free_amount: free_amount,
        bonds: bonds
      }
    end

    private

    def free_amount
      find_text(xpath: '//*[@id="stanRachunku"]/span[2]').to_money
    end

    def bonds
      table = find_element(css: '.ui-datatable')
      table.find_elements(css: 'tbody tr').map do |row|
        columns = row.find_elements(css: 'td')
        name = columns[0].text.strip.upcase
        symbol = name.match(SYMBOL_REGEXP)[:symbol]

        {
          ticker: Ticker.new(exchange: 'PKOBP', symbol: symbol),
          name: name,
          amount: columns[1].text.to_i + columns[2].text.to_i,
          start_price: columns[3].text.to_money,
          market_price: columns[4].text.to_money,
          buyout_date: columns[5].text.to_date
        }
      end
    end
  end
end