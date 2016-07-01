require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::CorporationsController, type: :controller do
  routes { ::Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  let(:valid_attributes) {
    FactoryGirl.attributes_for(:customer_vault_corporation)
  }

  let(:invalid_attributes) {
    {name: ""}
  }

  describe "GET show" do
    it "assigns the requested corporation as @corporation" do
      corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
      get :show, params: {:id => corporation.to_param}
      expect(assigns(:corporation)).to eq(corporation)
    end
  end

  describe "GET new" do
    it "assigns a new corporation as @corporation" do
      get :new
      expect(assigns(:corporation)).to be_a_new(::Dorsale::CustomerVault::Corporation)
      expect(assigns(:corporation).address).to be_a_new(::Dorsale::Address)
    end
  end

  describe "GET edit" do
    it "assigns the requested corporation as @corporation" do
      corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
      get :edit, params: {:id => corporation.to_param}
      expect(assigns(:corporation)).to eq(corporation)
      expect(assigns(:corporation).address).to be_a_new(Dorsale::Address)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new corporation" do
        expect {
          post :create, params: {:corporation => valid_attributes}
        }.to change(::Dorsale::CustomerVault::Corporation, :count).by(1)
      end

      it "assigns a newly created corporation as @corporation" do
        post :create, params: {:corporation => valid_attributes}
        expect(assigns(:corporation)).to be_a(::Dorsale::CustomerVault::Corporation)
        expect(assigns(:corporation)).to be_persisted
      end

      it "redirects to the created corporation" do
        post :create, params: {:corporation => valid_attributes}
        expect(response).to redirect_to(::Dorsale::CustomerVault::Corporation.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved corporation as @corporation" do
        post :create, params: {:corporation => invalid_attributes}
        expect(assigns(:corporation)).to be_a_new(::Dorsale::CustomerVault::Corporation)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:corporation => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {name: 'New name'}
      }

      it "updates the requested corporation" do
        corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
        put :update, params: {:id => corporation.to_param, :corporation => new_attributes}
        corporation.reload
        expect(corporation.name).to eq('New name')
      end

      it "assigns the requested corporation as @corporation" do
        corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
        put :update, params: {:id => corporation.to_param, :corporation => valid_attributes}
        expect(assigns(:corporation)).to eq(corporation)
      end

      it "redirects to the corporation" do
        corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
        put :update, params: {:id => corporation.to_param, :corporation => valid_attributes}
        expect(response).to redirect_to(corporation)
      end
    end

    describe "with invalid params" do
      it "assigns the corporation as @corporation" do
        corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
        put :update, params: {:id => corporation.to_param, :corporation => invalid_attributes}
        expect(assigns(:corporation)).to eq(corporation)
      end

      it "re-renders the 'edit' template" do
        corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
        put :update, params: {:id => corporation.to_param, :corporation => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested corporation" do
      corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
      expect {
        delete :destroy, params: {:id => corporation.to_param}
      }.to change(::Dorsale::CustomerVault::Corporation, :count).by(-1)
    end

    it "redirects to the corporations list" do
      corporation = ::Dorsale::CustomerVault::Corporation.create! valid_attributes
      delete :destroy, params: {:id => corporation.to_param}
      expect(response).to redirect_to(customer_vault_people_path)
    end
  end

end

