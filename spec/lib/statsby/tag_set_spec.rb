require 'statsby'
RSpec.describe Statsby::TagSet do
  let(:single_tag) do
    ts = Statsby::TagSet.new
    ts['key'] = 'val'
    ts
  end

  let(:multiple_tag) do
    ts = Statsby::TagSet.new
    ts['key1'] = 'val1'
    ts['key2'] = 'val2'
    ts['key3'] = 'val3'
    ts
  end

  describe '#to_s' do
    context 'when empty' do
      it 'returns an empty string' do
        expect(subject).to be_empty
        expect(subject.to_s).to eq ''
      end
    end

    context 'with a single tag' do
      it 'formats key-values correctly' do
        expect(single_tag.to_s).to eq 'key=val'
      end
    end

    context 'with multiple tags' do
      it 'contains all key-value pairs separated by commas' do
        # I like my tests to be as simple as possible,
        # however I didn't want to rely on iterating over
        # the keys in the same order they were inserted.
        expected_tags = %w[key1=val1 key2=val2 key3=val3]
        expect(multiple_tag.to_s.split(',')).to match_array(expected_tags)
      end
    end
  end

  describe '.from_hash' do
    let(:test_hash) { { key1: :val1, key2: :val2 } }

    it 'returns a TagSet' do
      expect(Statsby::TagSet.from_hash({})).to be_a(Statsby::TagSet)
    end

    it 'preserves keys' do
      ts = Statsby::TagSet.from_hash(test_hash)
      expect(ts).to eq test_hash
    end
  end
end
