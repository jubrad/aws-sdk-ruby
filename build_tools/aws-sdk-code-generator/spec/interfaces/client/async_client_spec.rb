require_relative '../../spec_helper'

describe 'Client Interface:' do
  describe 'Support H2 Async' do

    before(:all) do
      SpecHelper.generate_service(['Async'], multiple_files: false)  
    end

    let(:output_stream) {
      [
        { message_type: 'event', event_type: :baz_result, result: { details: [ "foo" ]}}
      ].each 
    }

    let(:client) {
      Async::AsyncClient.new(
        region: 'us-west-2',
        credentials: Aws::Credentials.new('akid', 'secret'),
        stub_responses: {foo: {
          member_b: "member_b_header",
          baz_stream: output_stream
        }}
      )
    }

    it 'supports signal events using eventstream object' do
      input_stream = Async::EventStreams::FooStream.new
      input_stream.signal_bar_event(bar_chunk: "chunk0")
      input_stream.signal_bar_event(bar_chunk: "chunk1")
      input_stream.signal_end_stream

      output_stream = Async::EventStreams::BazStream.new
      output_stream.on_baz_result_event do |e|
        expect(e.event_type).to eq(:baz_result)
        expect(e.result.details).to eq(['foo'])
      end

      async_resp = client.foo(member_a: "hello", input_event_stream_handler: input_stream,
        output_event_stream_handler: output_stream)
      async_resp.wait

      client.send_events.each_with_index do |event, i|
        expect(event.headers[":event-type"].value).to eq('BarEvent')
        expect(event.payload.read).to eq("chunk#{i}")
      end
    end

    it 'supports signal events using request block' do
      client.foo(member_a: "hello") do |input_stream, output_stream|

        input_stream.signal_bar_event(bar_chunk: "chunk")
        input_stream.signal_end_stream

        output_stream.on_baz_result_event do |e|
          expect(e.event_type).to eq(:baz_result)
          expect(e.result.details).to eq(['foo'])
        end
      end.wait

      expect(client.send_events.size).to eq(1)
      expect(client.send_events.first.headers[":event-type"].value).to eq('BarEvent')
      expect(client.send_events.first.payload.read).to eq('chunk')
    end

    it 'supports signal events after connection established' do
      input_stream = Async::EventStreams::FooStream.new
      output_stream = Async::EventStreams::BazStream.new
      output_stream.on_baz_result_event do |e|
        expect(e.event_type).to eq(:baz_result)
        expect(e.result.details).to eq(['foo'])
      end

      async_resp = client.foo(member_a: "hello", input_event_stream_handler: input_stream,
        output_event_stream_handler: output_stream)
      input_stream.signal_bar_event(bar_chunk: "chunk")
      input_stream.signal_end_stream
      async_resp.wait

      expect(client.send_events.size).to eq(1)
      expect(client.send_events.first.headers[":event-type"].value).to eq('BarEvent')
      expect(client.send_events.first.payload.read).to eq('chunk')
    end

    it 'supports signal events using block and by handler' do
      input_stream = Async::EventStreams::FooStream.new
      output_stream = Async::EventStreams::BazStream.new
      output_stream.on_baz_result_event do |e|
        expect(e.event_type).to eq(:baz_result)
        expect(e.result.details).to eq(['foo'])
      end
      input_stream.signal_bar_event(bar_chunk: "chunk0")

      async_resp = client.foo(member_a: "hello", input_event_stream_handler: input_stream,
        output_event_stream_handler: output_stream) do |stream, _|

        stream.signal_bar_event(bar_chunk: "chunk1")

      end
      input_stream.signal_bar_event(bar_chunk: "chunk2")
      input_stream.signal_end_stream
      async_resp.wait

      expect(client.send_events.size).to eq(3)
      client.send_events.each_with_index do |event, i|
        expect(event.headers[":event-type"].value).to eq('BarEvent')
        expect(event.payload.read).to eq("chunk#{i}")
      end
    end
  end
end
