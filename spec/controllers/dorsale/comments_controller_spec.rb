require "rails_helper"

describe Dorsale::CommentsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) {create(:user)}
  before :each do
    sign_in user
  end

  let(:valid_attributes){
    commentable = DummyModel.create!(name: "A")

    {
      :commentable_id   => commentable.id,
      :commentable_type => commentable.class.to_s,
      :text             => "Hello"
    }
  }

  describe "create" do
    it "should create comment" do
      post :create, comment: valid_attributes, back_url: "/"
      expect(assigns(:comment)).to be_persisted
    end

    it "should redirect to back_url" do
      post :create, comment: valid_attributes, back_url: "/"
      expect(response).to redirect_to("/")
    end
  end

  describe "update" do
    it "should update comment text" do
      comment = create(:dorsale_comment)
      patch :update, id: comment, comment: {text: "New-comment-text"}, back_url: "/"
      expect(response).to redirect_to("/")
      expect(comment.reload.text).to eq "New-comment-text"
    end
  end

  describe "destroy" do
    it "should destroy comment" do
      comment = create(:dorsale_comment)
      delete :destroy, id: comment, back_url: "/"
      expect(response).to redirect_to("/")
    end
  end
end
