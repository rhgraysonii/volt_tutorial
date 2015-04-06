require 'spec_helper'

describe Volt::FormatValidator do
  subject { described_class.new(*init_params) }

  let(:init_params) { [ model, field_name ] }
  let(:validate_params) { [ model, nil, field_name, options ] }

  let(:model) { Volt::Model.new field: field_content }
  let(:field_name) { :field }
  let(:options) { regex_opts }

  let(:regex) { /^valid/ }
  let(:proc_regex) { /^valid/ }
  let(:test_proc) { ->(content) { proc_regex.match content } }

  let(:proc_opts) { { with: test_proc, message: proc_message } }
  let(:regex_opts) { { with: regex, message: regex_message } }

  let(:proc_message) { 'proc is invalid' }
  let(:regex_message) { 'regex is invalid' }

  let(:field_content) { valid_content }
  let(:invalid_content) { 'invalid_content' }
  let(:valid_content) { 'valid_content' }

  let(:validate) { described_class.validate(*validate_params) }

  before do
    allow(described_class).to receive(:new).and_return subject
  end

  context 'when no criteria is provided' do
    before { validate }

    it 'should have no errors' do
      expect(subject.errors).to eq({})
    end

    specify { expect(subject).to be_valid }
  end

  context 'when the only criterion is a regex' do
    let(:options) { regex_opts }

    before { validate }

    context 'and the field matches' do
      let(:field_content) { valid_content }

      it 'should have no errors' do
        expect(subject.errors).to eq({})
      end

      specify { expect(subject).to be_valid }
    end

    context 'and the field does not match' do
      let(:field_content) { invalid_content }

      it 'should report the related error message' do
        expect(subject.errors).to eq field_name => [regex_message]
      end

      specify { expect(subject).to_not be_valid }
    end
  end

  context 'when the only criterion is a block' do
    let(:options) { proc_opts }

    before { validate }

    context 'and the field passes the block' do
      let(:field_content) { valid_content }

      it 'should have no errors' do
        expect(subject.errors).to eq({})
      end

      specify { expect(subject).to be_valid }
    end

    context 'and the field fails the block' do
      let(:field_content) { invalid_content }

      it 'should report the related error message' do
        expect(subject.errors).to eq field_name => [proc_message]
      end

      specify { expect(subject).to_not be_valid }
    end
  end

  context 'when there is both regex and block criteria' do
    let(:options) { [ regex_opts, proc_opts ] }

    before { validate }

    context 'and the field passes all criteria' do
      let(:field_content) { valid_content }

      it 'should have no errors' do
        expect(subject.errors).to eq({})
      end

      specify { expect(subject).to be_valid }
    end

    context 'and the field fails the regex' do
      let(:regex) { /^invalid/ }

      it 'should report the related error message' do
        expect(subject.errors).to eq field_name => [regex_message]
      end

      specify { expect(subject).to_not be_valid }
    end

    context 'and the field fails the block' do
      let(:proc_regex) { /^invalid/ }

      it 'should report the related error message' do
        expect(subject.errors).to eq field_name => [proc_message]
      end

      specify { expect(subject).to_not be_valid }
    end

    context 'and the field fails both the regex and the block' do
      let(:field_content) { invalid_content }

      it 'should report the regex error message' do
        expect(subject.errors[field_name]).to include regex_message
      end

      it 'should report the proc error message' do
        expect(subject.errors[field_name]).to include proc_message
      end

      specify { expect(subject).to_not be_valid }
    end
  end
end
