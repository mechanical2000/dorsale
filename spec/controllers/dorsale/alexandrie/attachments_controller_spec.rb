require "rails_helper"

describe Dorsale::Alexandrie::AttachmentsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:uploaded_file) {
    path = Rails.root.join("..", "..", "spec", "files", "pdf.pdf").to_s
    Rack::Test::UploadedFile.new(path, "application/pdf")
  }

  let(:valid_attributes) {
    attachable = DummyModel.create!(name: "A")

    {
      :attachable_id   => attachable.id,
      :attachable_type => attachable.class.to_s,
      :file            => uploaded_file,
    }
  }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  let(:attachment) { create(:alexandrie_attachment) }

  describe "sorting" do
    let!(:attachable) { create(:billing_machine_quotation) }

    let!(:attachment1) {
      create(:alexandrie_attachment,
        :attachable      => attachable,
        :name            => "AAA",
        :created_at      => "2010-01-01",
        :updated_at      => "2010-01-01",
        :attachment_type => create(:alexandrie_attachment_type, name: "AAA"),
      )
    }

    let!(:attachment2) {
      create(:alexandrie_attachment,
        :attachable      => attachable,
        :name            => "ZZZ",
        :created_at      => "2020-01-01",
        :updated_at      => "2020-01-01",
        :attachment_type => create(:alexandrie_attachment_type, name: "ZZZ"),
      )
    }

    before do
      allow_any_instance_of(described_class).to \
        receive(:find_attachable_from_params).and_return(attachable)
    end

    it "should sort by name" do
      get :index, params: {sort: "name"}
      expect(assigns :attachments).to eq [attachment1, attachment2]
    end

    it "should sort by -name" do
      get :index, params: {sort: "-name"}
      expect(assigns :attachments).to eq [attachment2, attachment1]
    end

    it "should sort by created_at" do
      get :index, params: {sort: "created_at"}
      expect(assigns :attachments).to eq [attachment1, attachment2]
    end

    it "should sort by -created_at" do
      get :index, params: {sort: "-created_at"}
      expect(assigns :attachments).to eq [attachment2, attachment1]
    end

    it "should sort by updated_at" do
      get :index, params: {sort: "updated_at"}
      expect(assigns :attachments).to eq [attachment1, attachment2]
    end

    it "should sort by -updated_at" do
      get :index, params: {sort: "-updated_at"}
      expect(assigns :attachments).to eq [attachment2, attachment1]
    end

    it "should sort by attachment_type_name" do
      get :index, params: {sort: "attachment_type_name"}
      expect(assigns :attachments).to eq [attachment1, attachment2]
    end

    it "should sort by -attachment_type_name" do
      get :index, params: {sort: "-attachment_type_name"}
      expect(assigns :attachments).to eq [attachment2, attachment1]
    end
  end # describe "sorting"

  describe "create" do
    it "should create attachment" do
      post :create, params: {attachment: valid_attributes}
      expect(assigns(:attachment)).to be_persisted
    end

    it "should render list" do
      post :create, params: {attachment: valid_attributes}
      expect(response).to be_ok
      expect(response).to render_template :index
    end
  end

  describe "edit" do
    it "should render list" do
      get :edit, params: {id: attachment}
      expect(response).to be_ok
      expect(response).to render_template :index
    end
  end

  describe "update" do
    it "should update attachment" do
      patch :update, params: {id: attachment, attachment: {name: "new_name"}}
      expect(attachment.reload.name).to eq "new_name"
    end

    it "should render list" do
      patch :update, params: {id: attachment}
      expect(response).to be_ok
      expect(response).to render_template :index
    end
  end

  describe "destroy" do
    let!(:attachment) { create(:alexandrie_attachment) }

    it "should delete attachment" do
      expect {
        delete :destroy, params: {id: attachment}
      }.to change(::Dorsale::Alexandrie::Attachment, :count).by(-1)
    end

    it "should render list" do
      delete :destroy, params: {id: attachment}
      expect(response).to be_ok
      expect(response).to render_template :index
    end
  end
end
