# frozen_string_literal: true

# Tests of REST API method which returns information of shops selling at least
# one copy of a book released by a publisher

RSpec.describe Shakuro::API::REST::Publishers::IndexShops do
  describe 'GET /publishers/:id/shops' do
    include described_class::SpecHelper

    subject(:response) { get "/publishers/#{id}/shops" }

    let(:id) { publisher.id }
    let(:publisher) { create(:publisher) }

    it 'should invoke Shakuro::Actions::Publishers.index_shops' do
      expect(Shakuro::Actions::Publishers)
        .to receive(:index_shops)
        .and_call_original
      subject
    end

    describe 'response' do
      subject { response }

      it { is_expected.to be_ok }

      describe 'body' do
        subject { response.body }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when publisher record isn\'t found by provided id' do
        let(:id) { 100_500 }

        it { is_expected.to be_not_found }
      end

      context 'when provided publisher record id isn\'t a number' do
        let(:id) { 'notanumber' }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
