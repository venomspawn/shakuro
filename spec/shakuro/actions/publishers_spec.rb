# frozen_string_literal: true

# Tests of actions on publisher records

RSpec.describe Shakuro::Actions::Publishers do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:index_shops) }
  end

  describe '.index_shops' do
    include described_class::IndexShops::SpecHelper

    subject(:result) { described_class.index_shops(params, rest) }

    let(:rest) { nil }
    let(:params) { data }
    let(:data) { { id: id } }
    let(:id) { publisher.id }
    let(:publisher) { create(:publisher) }
    let(:pub1ish3r) { create(:publisher) }
    let(:books) { create_list(:book, 3, publisher_id: publisher.id) }
    let(:b00ks) { create_list(:book, 3, publisher_id: pub1ish3r.id) }
    let(:shops) { create_list(:shop, 3) }
    let!(:book_copies) { create_book_copies(books, shops) }
    let!(:b00k_copies) { create_book_copies(b00ks, shops) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }

      describe 'value by `shops` key' do
        subject { result[:shops] }

        let(:shop_ids) { subject.map { |hash| hash[:id] } }

        it 'should have info of shops selling at least one book copy' do
          expect(subject.size).to be == 2
          expect(shop_ids).to match_array [shops[0].id, shops[1].id]
        end

        describe 'elements' do
          it 'should be ordered by amounts of sold books descending' do
            expect(subject[0][:id]).to be == shops[0].id
            expect(subject[1][:id]).to be == shops[1].id
          end

          it 'should include proper information about sold books' do
            expect(subject[0][:books_sold_count]).to be == 6
            expect(subject[1][:books_sold_count]).to be == 3
          end
        end
      end
    end
  end
end
