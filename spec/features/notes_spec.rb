require 'rails_helper'

RSpec.feature "Notes", type: :feature do
  # ユーザーが新しいノートを作成する
  scenario "ノートを作成する" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "Note Test", owner: user)
    
    sign_in user
    visit root_path
    
    expect{
     click_link "Note Test"
     click_link "Add Note"
     fill_in "Message", with: "Test Note"
     click_button "Create Note"
     
     expect(page).to have_content "Note was successfully created."
     expect(page).to have_content "Test Note"
    }.to change(user.notes, :count).by(1)
  end
  
   scenario "ノートを検索する" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "Note Test", owner: user)
    
    sign_in user
    visit root_path
    
    click_link "Note Test"
    click_link "Add Note"
    fill_in "Message", with: "Test Note"
    click_button "Create Note"
    click_link "Add Note"
    fill_in "Message", with: "hello"
    click_button "Create Note"
    
    fill_in "term", with: "Test"
    click_button "Search Notes"
    
    expect(page).to have_content "Test Note"
    expect(page).to_not have_content "hello"
    click_link "Back to Note Test"
    
    expect(page).to have_content "Test Note"
    expect(page).to have_content "hello"

  end
end
