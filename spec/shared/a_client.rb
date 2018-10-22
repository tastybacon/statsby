RSpec.shared_examples 'a client' do
  describe '#counter' do
    it 'sends the right message' do
      expect { default_client.counter(:abcd, 20) }
        .to change { test_io.string }.from('').to('abcd:20|c')
    end
  end

  describe '#gauge' do
    it 'sends the right message' do
      expect { default_client.gauge(:abcd, 20) }
        .to change { test_io.string }.from('').to('abcd:20|g')
    end
  end

  describe '#timing' do
    it 'sends the right message' do
      expect { default_client.timing(:abcd, 20) }
        .to change { test_io.string }.from('').to('abcd:20|ms')
    end
  end

  describe '#set' do
    it 'sends the right message' do
      expect { default_client.set(:abcd, 20) }
        .to change { test_io.string }.from('').to('abcd:20|s')
    end
  end

  describe '#format_tags' do
    context 'when tags are disabled' do
      it 'returns nil' do
        expect(tagless_client.format_tags('test' => 'tag')).to be_nil
      end
    end

    context 'when tags are enabled' do
      context 'when tags are empty' do
        it 'returns nil' do
          expect(default_client.format_tags).to be_nil
        end
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

  describe '#format_message' do
    it 'correctly formats a message' do
      message = default_client.format_message(
        'name',
        2,
        'c',
        'a' => 'b',
        'c' => 'd'
      )
      expect(message).to eq 'name,a=b,c=d:2|c'
    end

    context 'when tags are disabled' do
      it 'does not include message tags' do
        message = tagless_client.format_message(
          'name',
          2,
          'c',
          'a' => 'b',
          'c' => 'd'
        )
        expect(message).to eq 'name:2|c'
      end
    end
  end
end
