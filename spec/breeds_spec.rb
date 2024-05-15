# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Breeds form page', type: :system do # rubocop:disable Metrics/BlockLength
  before do
    WebMock.allow_net_connect!
  end

  it 'shows the form lable text' do
    visit root_path
    expect(page).to have_content(I18n.t(:breed_label))
  end

  it 'shoes the input' do
    visit root_path
    expect(page).to have_css('input#breed')
  end

  it 'shoes the submit button' do
    visit root_path
    expect(page).to have_button('Submit')
  end

  it 'shoes the clear button' do
    visit root_path
    expect(page).to have_link('Clear', href: root_path)
  end

  context 'with the correct value' do
    let(:value) { 'husky' }

    it 'shoes the breed name' do
      visit root_path
      fill_in 'breed', with: value
      click_button 'Submit'

      expect(page).to have_content('Husky')
      expect(page.find('#breed_img')['src']).to match %r{https://images.dog.ceo/breeds/husky/}
    end
  end

  context 'with the incorrect value' do
    let(:value) { 'invalid' }

    it 'shoes the breed name' do
      visit root_path
      fill_in 'breed', with: value
      click_button 'Submit'

      expect(page).not_to have_content('Invalid')
      expect(page.find('#breed_img')['src']).not_to match %r{https://images.dog.ceo/breeds/invalid/}
      expect(page).to have_content(I18n.t(:no_matches_found))
    end
  end
end
