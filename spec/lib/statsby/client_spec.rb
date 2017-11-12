require 'statsby'
RSpec.describe Statsby::Client do
  let(:default_client) { Statsby::Client.new }
  let(:tagless_client) { Statsby::Client.new(tags_enabled: false) }
  let(:tagged_client) do
    Statsby::Client.new(tags: { 'key' => 'value', 'key2' => 'value2' })
  end

  describe '#format_tags' do
    it 'returns nil when tags are disabled' do
      expect(tagless_client.format_tags('test' => 'tag')).to be_nil
    end

    it 'returns nil when tags are empty' do
      expect(default_client.format_tags).to be_nil
    end

    it 'uses client based tags' do
      expect(tagged_client.format_tags).to eq ',key=value,key2=value2'
    end

    it 'uses message based tags' do
      expect(default_client.format_tags('test' => 'tag')).to eq ',test=tag'
    end

    it 'overwrites client tags with message tags' do
      expect(tagged_client.format_tags('key' => 'new_value'))
        .to eq ',key=new_value,key2=value2'
    end
  end
end
