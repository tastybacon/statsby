require 'statsby'
RSpec.describe Statsby::Client do
  let(:default_client) { Statsby::Client.new }
  let(:tagless_client) { Statsby::Client.new(tags_enabled: false) }
end
