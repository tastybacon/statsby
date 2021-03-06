require 'statsby'
require 'shared/a_client'
RSpec.describe Statsby::Context do
  let(:test_io) { StringIO.new }

  let(:default_client) do
    client = Statsby::Client.new(metrics_writer: test_io)
    client.subcontext
  end

  let(:tagless_client) do
    client = Statsby::Client.new(tags_enabled: false)
    client.subcontext
  end

  let(:tagged_client) do
    client = Statsby::Client.new(tags: { 'key' => 'value', 'key2' => 'value2' })
    client.subcontext
  end

  it_behaves_like 'a client'

  describe '#format_tags' do
    context 'when built on a tagless supercontext' do
      it 'returns nil' do
        context = described_class.new(tagless_client, 'context' => 'level1')
        expect(context.format_tags).to be_nil
      end
    end

    context 'when nested' do
      it 'includes tags from all levels' do
        context = described_class.new(tagged_client, 'context' => 'level1')
        subcontext = described_class.new(context, 'subcontext' => 'level2')
        expect(context.format_tags)
          .to eq ',key=value,key2=value2,context=level1'
        expect(subcontext.format_tags)
          .to eq ',key=value,key2=value2,context=level1,subcontext=level2'
      end

      it 'subcontexts will overwrite tags from parent contexts' do
        context = described_class.new(tagged_client, 'context' => 'level1')
        subcontext = described_class.new(
          context,
          'key' => 'new_value',
          'context' => 'level2'
        )
        expect(context.format_tags)
          .to eq ',key=value,key2=value2,context=level1'
        expect(subcontext.format_tags)
          .to eq ',key=new_value,key2=value2,context=level2'
      end
    end
  end

  describe '#subcontext' do
    it 'returns a new Context instance' do
      context = described_class.new(default_client)
      subcontext = context.subcontext
      expect(context).not_to eq(subcontext)
      expect(context).to be_a(described_class)
    end
  end
end
