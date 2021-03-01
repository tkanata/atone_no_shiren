require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  scenario "user submits new cards on root page" do
    visit root_path
    fill_in "post[card_info]", with: "S1 S2 S3 S4 S5"
    click_button "Check"
    expect(page).to have_content "ストレートフラッシュ"
  end

  scenario "root page renders /result when user submits new valid cards" do
    visit root_path
    fill_in "post[card_info]", with: "S1 S2 S3 S4 S5"
    click_button "Check"
    expect(current_path).to eq '/result'
  end

  scenario "user submits new valid cards on /result page" do
    visit '/result'
    fill_in "post[card_info]", with: "S1 S2 S3 S4 S5"
    click_button "Check"
    expect(page).to have_content "ストレートフラッシュ"
  end

end
