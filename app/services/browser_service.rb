# Run service call inside active record transaction
class BrowserService < Service
  include BrowserHelper

  attr_reader :browser

  def self.call(**args, &block)
    BROWSER_POOL.with do |browser|
      super(**args.merge(browser: browser, &block))
    ensure
      browser&.get('about:blank')
    end
  end

  def initialize(browser:)
    @browser = browser
  end
end