require 'rails_helper'

RSpec.feature "PasswordResets", type: :feature do
  include ActiveJob::TestHelper
  
  background do
    ActionMailer::Base.deliveries.clear
  end
  
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end
  
  # ユーザーはパスワードをリセットする
  scenario "ユーザーはパスワードをリセットする" do
    user = FactoryBot.create(:user, email: "password_reset@example.com")
    
    visit root_path
    click_link "Sign in"
    click_link "Forgot your password?"
    
    perform_enqueued_jobs do
      expect{
        fill_in "Email", with:"password_reset@example.com"
        click_button "Send me reset password instructions"
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
      
      expect(page).to have_content "You will receive an email with instructions on how to reset your password in a few minutes."
      expect(current_path).to eq new_user_session_path
    end
    
    mail = ActionMailer::Base.deliveries.last
    
    aggregate_failures do
      expect(mail.to).to eq ["password_reset@example.com"]
      expect(mail.from).to eq ["please-change-me-at-config-initializers-devise@example.com"]
      expect(mail.subject).to eq "Reset password instructions"
      expect(mail.body).to match "Change my password"
      expect(mail.body).to match "assword_reset@example.com"
    end
    
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content 'Change your password'
    
    click_button "Change my password"
    expect(page).to have_content "Password can't be blank"
    
    fill_in "New password", with: "123456"
    fill_in "Confirm new password", with: "1234567"
    click_button "Change my password"
    expect(page).to have_content "Password confirmation doesn't match Password"


    
    fill_in "New password", with: "123456"
    fill_in "Confirm new password", with: "123456"
    click_button "Change my password"
    
    expect(page).to have_content "Your password has been changed successfully. You are now signed in."
    expect(current_path).to eq root_path

    
    
  end
end
