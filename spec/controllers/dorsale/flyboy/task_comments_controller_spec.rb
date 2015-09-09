require "rails_helper"

describe Dorsale::Flyboy::TaskCommentsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:task)         { create(:flyboy_task) }
  let(:task_comment) { create(:flyboy_task_comment, task: task) }

  let(:user) {create(:user)}
  before :each do
    sign_in user
  end
  
  describe "#create" do
    it "should create the task_comment" do
      post :create, task_id: task.id, task_comment: task_comment.attributes
      expect(assigns(:task_comment).persisted?).to be true
    end
  end

end
