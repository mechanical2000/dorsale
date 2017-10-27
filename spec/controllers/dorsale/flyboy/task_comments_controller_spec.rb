require "rails_helper"

describe Dorsale::Flyboy::TaskCommentsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  let(:task)         { create(:flyboy_task) }
  let(:task_comment) { create(:flyboy_task_comment, task: task) }

  describe "#create" do
    let(:valid_params) { {task_id: task.id, task_comment: task_comment.attributes} }

    it "should create the task_comment" do
      post :create, params: valid_params
      expect(assigns(:task_comment).persisted?).to be true
    end

    it "should redirect to referrer" do
      request.env["HTTP_REFERER"] = "/abc"
      post :create, params: valid_params
      expect(response).to redirect_to "/abc"
    end

    it "should redirect to task" do
      post :create, params: valid_params
      expect(response).to redirect_to flyboy_task_path(task)
    end
  end
end
