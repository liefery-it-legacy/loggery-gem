# frozen_string_literal: true

require 'spec_helper'

describe Loggery::Metadata::Middleware::Rack do
  subject { described_class.new(double(call: nil)) }

  describe '#call' do
    let(:request_id) { 'my_request_id' }
    let(:request_env) { { 'action_dispatch.request_id' => request_id } }

    it 'sets the current request id as logging metadata' do
      subject.call(request_env) do
        expect(Loggery::Metadata::Store.store[:request_id]).to eq request_id
      end
    end
  end
end
