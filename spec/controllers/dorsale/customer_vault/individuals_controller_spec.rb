require "rails_helper"


RSpec.describe ::Dorsale::CustomerVault::IndividualsController, type: :controller do

  routes { ::Dorsale::Engine.routes }

  let(:valid_attributes) {
    FactoryGirl.attributes_for(:customer_vault_individual)
  }

  let(:invalid_attributes) {
    { last_name: "" }
  }

  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested individual as @individual" do
      individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
      get :show, {:id => individual.to_param}, valid_session
      expect(assigns(:individual)).to eq(individual)
    end
  end

  describe "GET new" do
    it "assigns a new individual as @individual" do
      get :new, {}, valid_session
      expect(assigns(:individual)).to be_a_new(::Dorsale::CustomerVault::Individual)
    end
  end

  describe "GET edit" do
    it "assigns the requested individual as @individual" do
      individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
      get :edit, {:id => individual.to_param}, valid_session
      expect(assigns(:individual)).to eq(individual)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new individual" do
        expect {
          post :create, {:individual => valid_attributes}, valid_session
        }.to change(::Dorsale::CustomerVault::Individual, :count).by(1)
      end

      it "assigns a newly created individual as @individual" do
        post :create, {:individual => valid_attributes}, valid_session
        expect(assigns(:individual)).to be_a(::Dorsale::CustomerVault::Individual)
        expect(assigns(:individual)).to be_persisted
      end

      it "redirects to the created individual" do
        post :create, {:individual => valid_attributes}, valid_session
        expect(response).to redirect_to(::Dorsale::CustomerVault::Individual.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved individual as @individual" do
        post :create, {:individual => invalid_attributes}, valid_session
        expect(assigns(:individual)).to be_a_new(::Dorsale::CustomerVault::Individual)
      end

      it "re-renders the 'new' template" do
        post :create, {:individual => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {first_name: "Stroumph"}
      }

      it "updates the requested individual" do
        individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
        put :update, {:id => individual.to_param, :individual => new_attributes}, valid_session
        individual.reload
        expect(individual.first_name).to eq("Stroumph")
      end

      it "assigns the requested individual as @individual" do
        individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
        put :update, {:id => individual.to_param, :individual => valid_attributes}, valid_session
        expect(assigns(:individual)).to eq(individual)
      end

      it "redirects to the individual" do
        individual =::Dorsale::CustomerVault::Individual.create! valid_attributes
        put :update, {:id => individual.to_param, :individual => valid_attributes}, valid_session
        expect(response).to redirect_to(individual)
      end
    end

    describe "with invalid params" do
      it "assigns the individual as @individual" do
        individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
        put :update, {:id => individual.to_param, :individual => invalid_attributes}, valid_session
        expect(assigns(:individual)).to eq(individual)
      end

      it "re-renders the 'edit' template" do
        individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
        put :update, {:id => individual.to_param, :individual => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested individual" do
      individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
      expect {
        delete :destroy, {:id => individual.to_param}, valid_session
      }.to change(::Dorsale::CustomerVault::Individual, :count).by(-1)
    end

    it "redirects to the individuals list" do
      individual = ::Dorsale::CustomerVault::Individual.create! valid_attributes
      delete :destroy, {:id => individual.to_param}, valid_session
      expect(response).to redirect_to(customer_vault_people_path)
    end
  end

end
