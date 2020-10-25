require 'rails_helper'

RSpec.describe Project, type: :model do
  # 名前があれば有効な状態であること
  it "is valid with a name" do
    user = FactoryBot.create(:user, :joe)
    project = user.projects.build(
      name: "Test project"
      )
    expect(project).to be_valid
  end
  #  名前が無ければ無効な状態であること
  it "is invalid without a name" do
    user = FactoryBot.create(:user, :joe)
    project = user.projects.build(
      name: nil
      )
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end
  
  # ユーザー単位で重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user, :joe)
      
    user.projects.create(
      name: "Test Project"
      )
    
    new_project = user.projects.build(
      name: "Test Project"
      )
    
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end
  
  # 2人のユーザーが同じ名前のプロジェクトを使うことは許可すること
  it "allows two users to share a project name" do
    user = FactoryBot.create(:user, :joe)
    user.projects.create(
      name: "Test Project"
      )
    
    other_user = FactoryBot.create(:user)
    
    other_project = other_user.projects.build(
      name: "Test Project"
      )
    
    expect(other_project).to be_valid
  end
  
  # 遅延ステータス
  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end
    
    # 締切日が今日ならスケジュール通りであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end
    
    # 締切日が未来ならスケジュール通りであること
    it "is on time when the due date is in the future" do 
      project = FactoryBot.create(:project,:due_tomorrow)
      expect(project).to_not be_late
    end
  end
  
  # たくさんのメモがついていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
  
  # Shoulda Matchersを使用したテスト
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
    
end
