# frozen_string_literal: true

# Tests of REST API method which marks book copies in a shop as sold

RSpec.describe Shakuro::API::REST::Shops::SellBookCopies do
  describe 'POST /shops/:id/sold_book_copies' do
    subject(:response) { post "/shops/#{id}/sold_book_copies", body }

    let(:id) { shop.id }
    let(:shop) { create(:shop) }
    let(:body) { Oj.dump(params) }
    let(:params) { { book_copy_ids: book_copy_ids } }
    let(:book_copy_ids) { book_copies.map(&:id) }
    let(:book_copies) { create_list(:book_copy, 2, shop_id: id, sold_at: nil) }

    it 'should invoke Shakuro::Actions::Shops.sell_book_copies' do
      expect(Shakuro::Actions::Shops)
        .to receive(:sell_book_copies)
        .and_call_original
      subject
    end

    describe 'response' do
      subject { response }

      it { is_expected.to be_no_content }

      context 'when shop id is of bad format' do
        let(:id) { 'of_bad_format' }
        let(:book_copies) { [] }

        it { is_expected.to be_unprocessable }
      end

      context 'when shop record isn\'t found by provided id' do
        let(:id) { 100_500 }
        let(:book_copies) { [] }

        it { is_expected.to be_not_found }
      end

      context 'when a book copy has not been selling in the shop' do
        let(:book_copies) { create_list(:book_copy, 1, sold_at: nil) }

        it { is_expected.to be_unprocessable }
      end

      context 'when a book copy has already been sold in the shop' do
        let(:book_copies) { create_list(:book_copy, 1, shop_id: id) }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
