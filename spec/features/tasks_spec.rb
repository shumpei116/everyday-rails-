require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
    let(:user) { FactoryBot.create(:user) }
    let(:project) { FactoryBot.create(:project, name: "RSpec tutorial", owner: user) }
    let!(:task) { project.tasks.create!(name: "Finish RSpec tutorial") }
    
  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do

    sign_in user
    go_to_project "RSpec tutorial"
    
    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"
    
    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
    
  end
    
  def go_to_project(name)
    visit root_path
    click_link name
  end
  
  def complete_task(name)
    check "Finish RSpec tutorial"
  end
  
  def undo_complete_task(name)
    uncheck "Finish RSpec tutorial"
  end
  
  def expect_complete_task(name)
    expect(page).to have_css "label.completed", text: name
    expect(task.reload).to be_completed
  end
    
  def expect_incomplete_task(name)  
    expect(page).to_not have_css "label.completed", text: name
    expect(task.reload).to_not be_completed
  end
end
