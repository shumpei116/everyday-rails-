require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  
  let(:user) { FactoryBot.create(:user) }
  
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    # Deviceが提供しているヘルパーを使う場合
    # sign_in user
    # visit root_path
    
    # 独自に定義したログインヘルパーを使う場合
    sign_in_as user
    
    expect{
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)
    
    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
  
  # ユーザーが既存のプロジェクトを編集する
  scenario "ユーザーが既存のプロジェクトを編集する" do
    project = FactoryBot.create(:project, name: "Test Project", owner: user)
    
    sign_in_as user
    
    click_link "Test Project"
    click_link "Edit"
    
    fill_in "Name", with:"hello!"
    select "2021", from:"project_due_on_1i"
    select "December", from:"project_due_on_2i"
    select "31", from:"project_due_on_3i"
    click_button "Update Project"
    
    expect(page).to have_content "Project was successfully updated."
    expect(page).to have_content "hello!"
    expect(page).to have_content "Due: December 31, 2021"
    
  end
end
