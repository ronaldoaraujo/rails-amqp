require 'rails_helper'

class TestWorker
end

describe Rails::AMQP::Config do
  let(:config) do
    {
      connect:   { host: '127.0.0.1', port: 5672 },
      exchange:  { testx:  { name: 'testx', type: 'fanout' },
                   testd:  { name: 'testd', type: 'direct' },
                   topicx: { name: 'topicx', type: 'topic' } },
      queue:     { testq: { name: 'testq', durable: true } },
      binding:   {
        test:    { queue: 'testq', exchange: 'testx' },
        testd:   { queue: 'testq', exchange: 'testd', keys: ['test_key'] },
        topic:   { queue: 'testq', exchange: 'topicx', topics: 'test.a,test.b' },
        default: { queue: 'testq' }
      },
      channel: {
        testd: {
          prefetch: 5
        }
      }
    }.with_indifferent_access
  end

  before do
    allow(described_class).to receive(:data).and_return(config)
  end

  it 'tells client how to connect' do
    expect(described_class.connect).to eq('host' => '127.0.0.1', 'port' => 5672)
  end

  it 'returns queue settings' do
    expect(described_class.queue(:testq)).to eq ['testq', { durable: true }]
  end

  it 'returns exchange settings' do
    expect(described_class.exchange(:testx)).to eq %w[fanout testx]
  end

  it 'returns binding queue' do
    expect(described_class.binding_queue(:test)).to eq ['testq', { durable: true }]
  end

  it 'returns binding exchange' do
    expect(described_class.binding_exchange(:test)).to eq %w[fanout testx]
  end

  it 'sets exchange to nil when binding use default exchange' do
    expect(described_class.binding_exchange(:default)).to be_nil
  end

  it 'finds binding worker' do
    expect(described_class.binding_worker(:test)).to be_instance_of(TestWorker)
  end

  it 'returns keys for queue of binding' do
    expect(described_class.routing_keys(:testd)).to eq ['test_key']
  end

  it 'returns topics to subscribe' do
    expect(described_class.topics(:topic)).to eq ['test.a', 'test.b']
  end

  it 'returns empty hash when data channel is not present' do
    expect(described_class.channel(:meh)).to eq({})
  end

  it 'returns channel data for given id' do
    expect(described_class.channel(:testd)[:prefetch]).to eq(5)
  end
end
