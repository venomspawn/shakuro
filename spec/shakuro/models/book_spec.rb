# frozen_string_literal: true

# Tests of book model

RSpec.describe Shakuro::Models::Book do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:book, traits) }
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

    context 'when title value is nil' do
      let(:traits) { { title: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when publisher id is nil' do
      let(:traits) { { publisher_id: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end

    context 'when publisher id is not present in publishers table' do
      let(:traits) { { publisher_id: 100_500 } }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end
    end
  end

  describe 'instance' do
    subject { create(:book) }

    it { is_expected.to respond_to(:id, :title, :publisher_id, :update) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:book) }

    describe 'result' do
      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#title' do
    subject(:result) { instance.title }

    let(:instance) { create(:book) }

    describe 'result' do
      it { is_expected.to be_a(String) }
    end
  end

  describe '#publisher_id' do
    subject(:result) { instance.publisher_id }

    let(:instance) { create(:book) }

    describe 'result' do
      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:book) }

    context 'when id is specified' do
      let(:params) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when title is specified' do
      let(:params) { { title: value } }

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when the value is a string' do
        let(:value) { create(:string) }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.title).to be == value
        end
      end
    end

    context 'when publisher_id is specified' do
      let(:params) { { publisher_id: value } }

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when the value is not present in publishers table' do
        let(:value) { 100_500 }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end

      context 'when the value is correct' do
        let(:value) { create(:publisher).id }

        it 'should set the field to the value' do
          subject
          expect(instance.reload.publisher_id).to be == value
        end
      end
    end
  end
end
