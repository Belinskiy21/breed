# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BreedService do # rubocop:disable Metrics/BlockLength
  describe '#new' do
    subject { described_class.new(input) }

    context 'when the arg is present' do
      let(:input) { 'valid' }

      it 'returns new object' do
        expect(subject).to be_present
      end

      it 'does not raise arg error' do
        expect { subject }.not_to raise_error ArgumentError
      end
    end

    context 'when the arg is abcent' do
      let(:input) { nil }

      it 'raises the arg error' do
        expect { subject }.to raise_error ArgumentError, I18n.t(:breed_cant_be_blank)
      end
    end
  end

  describe '#call' do
    subject { described_class.new(input).call }

    before do
      stub_request(:get, "https://dog.ceo/api/breed/#{input}/images/random").with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: status, body: '', headers: {})
      subject
    end

    context 'when the breed is found' do
      let(:input) { 'husky' }
      let(:status) { 200 }

      it 'responds with true' do
        expect(subject).to be true
      end
    end

    context 'when the breed is not found' do
      let(:input) { 'invalid' }
      let(:status) { 404 }

      it 'responds with false' do
        expect(subject).to be false
      end
    end
  end

  describe '#breed' do
    subject { described_class.new(input).breed }

    let(:input) { 'australian shepherd' }

    it 'returns the capitalized breed' do
      expect(subject).to eq 'Australian Shepherd'
    end
  end

  describe '#img' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(input).img }

    before do
      stub_request(:get, "https://dog.ceo/api/breed/#{input}/images/random").with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: status, body: body, headers: {})
      subject
    end

    context 'when the response ok' do
      let(:input) { 'husky' }
      let(:status) { 200 }
      let(:img_url) { 'https://images.dog.ceo/breeds/australian-shepherd/leroy.jpg' }
      let(:body) do
        {
          'message' => img_url,
          'status' => 'success'
        }.to_json
      end

      it 'responds with image url' do
        expect(subject).to eq img_url
      end
    end

    context 'when the response is not ok' do
      let(:input) { 'invalid' }
      let(:status) { 404 }
      let(:body) { '' }

      it 'responds with false' do
        expect(subject).to be nil
      end
    end
  end
end
