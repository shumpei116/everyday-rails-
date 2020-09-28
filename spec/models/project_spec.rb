require 'rails_helper'

RSpec.describe Project, type: :model do
  # 名前があれば有効な状態であること
  it "is valid with a name" do
    user = User.create(
      first_name: "Jae",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
      )
    project = user.projects.build(
      name: "Test project"
      )
    expect(project).to be_valid
  end
  #  名前が無ければ無効な状態であること
  it "is invalid without a name" do
    user = User.create(
      first_name: "Jae",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
      )
    project = user.projects.build(
      name: nil
      )
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end
  
  # ユーザー単位で重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "Jae",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
      )
      
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
    user = User.create(
      first_name: "Jae",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
      )
    
    user.projects.create(
      name: "Test Project"
      )
    
    other_user = User.create(
      first_name: "Jane",
      last_name:  "Tester",
      email:      "janetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze"
      )
    
    other_project = other_user.projects.build(
      name: "Test Project"
      )
    
    expect(other_project).to be_valid
  end
    
end
