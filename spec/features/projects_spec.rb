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
  
  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    # プロジェクトをもったユーザーを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "test project", owner: user)
    # ユーザーはログインしている
    sign_in user
    # ユーザーがプロジェクト画面を開き
    visit project_path(project)
    expect(page).to_not have_content "Completed"
    # "complete"ボタンをクリックすると
    click_button "Complete"
    # プロジェクトは完了済としてマークされる
    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
  
  # 完了済のプロジェクトは非表示になる
  scenario "完了済のプロジェクトは非表示になる" do
    user = FactoryBot.create(:user, first_name: "ooyama", last_name: "shumpei")
    # 完了済のプロジェクト
    finish_project = FactoryBot.create(:project, name: "finish_project", owner: user, completed: true)
    # 完了前のプロジェクト
    project = FactoryBot.create(:project, name: "new_project", owner: user, completed: nil)
    
    # ログインする
    sign_in user
    visit projects_path
    # 完了前のプロジェクトは表示されている
    expect(page).to have_content "new_project"
    # 完了済のプロジェクトは表示されていない
    expect(page).to_not have_content "finish_project"
  end
  
  # 完了済のプロジェクトは完了済プロジェクト一覧ページから復元できる
  scenario "完了済みのプロジェクトは完了済プロジェクト一覧ページから復元できる" do
    user = FactoryBot.create(:user, first_name: "ooyama", last_name: "shumpei")
    # 完了済のプロジェクト
    finish_project = FactoryBot.create(:project, name: "finish_project", owner: user, completed: true)
    # 完了前のプロジェクト
    project = FactoryBot.create(:project, name: "new_project", owner: user, completed: nil)
    
    # ログインする
    sign_in user
    # プロジェクト一覧ページにアクセス
    visit projects_path
    # 完了済のプロジェクトは表示されていない
    expect(page).to_not have_content "finish_project"
    # 完了済プロジェクトベージにアクセス
    click_link "完了済プロジェクト一覧"
    # 完了済のプロジェクトは表示されている
    expect(page).to have_content "finish_project"
    # 完了前のプロジェクトは表示されていない
    expect(page).to_not have_content "new_project"
    # 完了済のプロジェクトを復元する
    click_link "復元する"
    # 復元完了のフラッシュメッセージが表示される
    expect(page).to have_content "Congratulations, this project is restore!"
    # 完了済だったプロジェクトも表示されている
    expect(page).to have_content "finish_project"
    # 完了済プロジェクト一覧ページにアクセス
    click_link "完了済プロジェクト一覧"
    # 完了済だったプロジェクトは表示されていない
    expect(page).to_not have_content "finish_project"
    
   
  end
  
end
