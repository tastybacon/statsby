require 'statsby'
RSpec.describe Statsby::Client do
  let(:default_client) { Statsby::Client.new }
  let(:tagless_client) { Statsby::Client.new(tags_enabled: false) }

  describe '#format_tags' do
    let(:test_tags) { { test: 1, foo: 'bar' } }
    context 'when tags are enabled' do
      it 'formats tags properly' do
        expect(default_client.format_tags(test_tags)).to eq('test=1,foo=bar')
      end
    end

    context 'when tags are disabled' do
      it 'returns nil' do
        expect(tagless_client.format_tags(test_tags)).to be_nil
      end
    end
  end
end
