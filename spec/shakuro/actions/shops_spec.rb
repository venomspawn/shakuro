# frozen_string_literal: true

# Tests of actions on shop records

RSpec.describe Shakuro::Actions::Shops do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:sell_book_copies) }
  end

  describe '.sell_book_copies' do
    subject { described_class.sell_book_copies(params, rest) }

    let(:rest) { nil }
    let(:params) { data }
    let(:data) { { id: id, book_copy_ids: book_copy_ids } }
    let(:id) { shop.id }
    let(:shop) { create(:shop) }
    let(:book_copy_ids) { book_copies.map(&:id) }
    let(:book_copies) { create_list(:book_copy, 2, shop_id: id, sold_at: nil) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    it 'should mark book copies as sold' do
      subject
      expect(book_copies.map(&:reload).map(&:sold_at))
        .to all be_within(1).of(Time.now)
    end

    context 'when the shop is not found' do
      let(:id) { 100_500 }
      let(:book_copies) { [] }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end
    end

    context 'when a book copy has not been selling in the shop' do
      let(:book_copies) { create_list(:book_copy, 1, sold_at: nil) }

      error = described_class::SellBookCopies::Errors::BookCopies::NotFound
      it "should raise #{error}" do
        expect { subject }.to raise_error(error)
      end
    end

    context 'when a book copy has already been sold in the shop' do
      let(:book_copies) { create_list(:book_copy, 1, shop_id: id) }

      error = described_class::SellBookCopies::Errors::BookCopies::Sold
      it "should raise #{error}" do
        expect { subject }.to raise_error(error)
      end
    end
  end
end
