require 'rails_helper'

RSpec.feature "UsersEdits", type: :feature do
  # ユーザーの情報を変更する
  scenario "ユーザーの名前を変更する" do
    user = FactoryBot.create(:user)
    
    sign_in user
    visit root_path
    
    click_link "Aaron Sumner"
    fill_in "First name", with: "shumpei"
    fill_in "Last name", with: "ooyama"
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    fill_in "Current password", with: user.password
    click_button "Update"
    
    expect(page).to have_content "Your account has been updated successfully."
    expect(page).to have_content "shumpei ooyama"
    
  end
end
