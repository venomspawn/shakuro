# frozen_string_literal: true

# Tests of book copy model

RSpec.describe Shakuro::Models::BookCopy do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:book_copy, traits) }
    let(:traits) { {} }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(described_class) }
    end

    context 'when id is specified' do
      let(:traits) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when sold at value is a string and not of date and time format' do
      let(:traits) { { sold_at: 'not of date and time format' } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when book id is nil' do
      let(:traits) { { book_id: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when book id is not present in books table' do
      let(:traits) { { book_id: 100_500 } }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end

    context 'when shop id is nil' do
      let(:traits) { { shop_id: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when shop id is not present in shops table' do
      let(:traits) { { shop_id: 100_500 } }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end
  end

  describe 'instance' do
    subject { create(:book_copy) }

    methods = %i[id sold_at book_id shop_id update]
    it { is_expected.to respond_to(*methods) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:book_copy) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#sold_at' do
    subject(:result) { instance.sold_at }

    let(:instance) { create(:book_copy) }

    describe 'result' do
      subject { result }

      context 'when the field value is nil' do
        let(:instance) { create(:book_copy, sold_at: nil) }

        it { is_expected.to be_nil }
      end

      context 'when the field value is not nil' do
        it { is_expected.to be_a(Time) }
      end
    end
  end

  describe '#book_id' do
    subject(:result) { instance.book_id }

    let(:instance) { create(:book_copy) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#shop_id' do
    subject(:result) { instance.shop_id }

    let(:instance) { create(:book_copy) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:book_copy) }

    context 'when id is specified' do
      let(:params) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when sold_at is specified' do
      let(:params) { { sold_at: value } }

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.sold_at).to be_nil
        end
      end

      context 'when the value is a string and not of date and time format' do
        let(:value) { 'not of date and time format' }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when the value is a string of date and time format' do
        let(:value) { time.to_s }
        let(:time) { Time.now }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.sold_at).to be_within(1).of(time)
        end
      end

      context 'when the value is of Time' do
        let(:value) { Time.now }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.sold_at).to be_within(1).of(value)
        end
      end
    end

    context 'when book_id is specified' do
      let(:params) { { book_id: value } }

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when the value is not present in books table' do
        let(:value) { 100_500 }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end

      context 'when the value is correct' do
        let(:value) { create(:book).id }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.book_id).to be == value
        end
      end
    end

    context 'when shop_id is specified' do
      let(:params) { { shop_id: value } }

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when the value is not present in shops table' do
        let(:value) { 100_500 }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end

      context 'when the value is correct' do
        let(:value) { create(:shop).id }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.shop_id).to be == value
        end
      end
    end
  end
end
