require 'rails_helper'

RSpec.feature 'Pokers', type: :feature do
  scenario 'user submits new cards on root page' do
    visit root_path
    fill_in 'poker[card_info]', with: 'S1 S2 S3 S4 S5'
    click_button 'Check'
    expect(page).to have_content 'ストレートフラッシュ'
  end

  scenario 'root page renders /result when user submits new valid cards' do
    visit root_path
    fill_in 'poker[card_info]', with: 'S1 S2 S3 S4 S5'
    click_button 'Check'
    expect(current_path).to eq '/result'
  end

  scenario 'user submits new valid cards on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: 'S1 S2 S3 S4 S5'
    click_button 'Check'
    expect(page).to have_content 'ストレートフラッシュ'
  end

  scenario 'user submit duplicated cards on /result page' do
      visit '/result'
      fill_in 'poker[card_info]', with: 'S1 S2 S3 S4 S4'
      click_button 'Check'
      expect(page).to have_content 'カードが重複しています'
  end

  scenario 'user submit no cards on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: ''
    click_button 'Check'
    expect(page).to have_content '値を入力してください'
  end

  scenario 'user submit wrong card for first card on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: 'X1 S2 S3 S4 S5'
    click_button 'Check'
    expect(page).to have_content '1枚目のカード情報が適切ではありません。(X1)'
  end

  scenario 'user submit wrong card for second card on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: 'S1 X2 S3 S4 S5'
    click_button 'Check'
    expect(page).to have_content '2枚目のカード情報が適切ではありません。(X2)'
  end

  scenario 'user submit wrong card for third card on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: 'S1 S2 X3 S4 S5'
    click_button 'Check'
    expect(page).to have_content '3枚目のカード情報が適切ではありません。(X3)'
  end

  scenario 'user submit wrong card for fourth card on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: 'S1 S2 S3 X4 S5'
    click_button 'Check'
    expect(page).to have_content '4枚目のカード情報が適切ではありません。(X4)'
  end

  scenario 'user submit wrong card for fifth card on /result page' do
    visit '/result'
    fill_in 'poker[card_info]', with: 'S1 S2 S3 S4 X5'
    click_button 'Check'
    expect(page).to have_content '5枚目のカード情報が適切ではありません。(X5)'
  end

end
