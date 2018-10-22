require 'statsby'
require 'shared/a_client'
RSpec.describe Statsby::Client do
  let(:default_client) { Statsby::Client.new }
  let(:tagless_client) { Statsby::Client.new(tags_enabled: false) }
  let(:tagged_client) do
    Statsby::Client.new(tags: { 'key' => 'value', 'key2' => 'value2' })
  end

  it_behaves_like 'a client'
end
