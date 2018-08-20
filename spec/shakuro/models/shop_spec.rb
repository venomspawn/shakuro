# frozen_string_literal: true

# Tests of shop model

RSpec.describe Shakuro::Models::Shop do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:shop, traits) }
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

    context 'when name value is nil' do
      let(:traits) { { name: nil } }

      it 'should raise Sequel::InvalidValue' do
        expect { subject }.to raise_error(Sequel::InvalidValue)
      end
    end
  end

  describe 'instance' do
    subject { create(:shop) }

    it { is_expected.to respond_to(:id, :name, :update) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:shop) }

    describe 'result' do
      it { is_expected.to be_an(Integer) }
    end
  end

  describe '#name' do
    subject(:result) { instance.name }

    let(:instance) { create(:shop) }

    describe 'result' do
      it { is_expected.to be_a(String) }
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:shop) }

    context 'when id is specified' do
      let(:params) { { id: 1 } }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when name is specified' do
      let(:params) { { name: value } }

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
          expect(instance.reload.name).to be == value
        end
      end
    end
  end
end
