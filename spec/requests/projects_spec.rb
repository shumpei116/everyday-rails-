require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "#create" do
    # 認証済のユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      
      # 有効な属性値の場合
      context "with valid attributes" do
        # プロジェクトを追加できること
        it "adds a project" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect{
            post projects_path, params: { project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end
      
      # 無効な属性値の場合
      context "with invalid attributes" do
        # プロジェクトを追加できないこと
        it "dose not add a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect{
            post projects_path, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end
    end
  end
  
  describe "#index" do
    # 認証済のユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 通常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get projects_path
        expect(response).to be_success
      end
      # ２００レスポンスを返すこと
      it "returns a 200 response" do
        sign_in @user
        get projects_path
        expect(response).to have_http_status "200"
      end
    end
    # ゲストとして
    context "as a guest" do
      # ３０２レスポンスを返すこと
      it "returns a 302 response" do
        get projects_path
        expect(response).to have_http_status "302"
      end
      # サインイン画面にリダイレクトすること
      it "redirects to the sign_in page" do
        get projects_path
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  
  describe "#destroy" do
    # 認可されたユーザーとして
    context "as an authorized user" do
      before do 
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      # プロジェクトを削除できること
      it "deletes a project" do
        sign_in @user
        expect{
          delete project_path(@project)
        }.to change(@user.projects, :count).by(-1)
      end
    end
    
    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end
      # プロジェクトを削除できないこと
      it "does not delete the project" do
        sign_in @user
        expect{
          delete project_path(@project)
        }.to_not change(Project, :count)
      end
      # ダッシュボードにリダイレクトされること
      it "redirects to the dashboard" do
        sign_in @user
        delete project_path(@project)
        expect(response).to redirect_to root_path
      end
    end
    
    # ゲストとして
    context "as a guest" do
      before do 
        user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: user)
      end
      # ３０２レスポンスを返すこと
      it "returns a 302 response" do
        delete project_path(@project)
        expect(response).to have_http_status "302"
      end
      # サインイン画面にリダイレクトすること
      it "redirects to the sign_in page" do
        delete project_path(@project)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
