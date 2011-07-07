require 'webmock'

RSpec.configure do |config|
  config.include WebMock::API
  WebMock.disable_net_connect!
end