require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::PeopleController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "#index" do
    it "should redirect to activity" do
      get :index
      expect(response).to redirect_to customer_vault_people_activity_path
    end
  end

  describe '#list' do
    describe 'sorting' do
      let!(:alice) {
        create(:customer_vault_individual, first_name: 'Alice', last_name: 'Zarston')
      }

      let!(:bob) {
        create(:customer_vault_individual, first_name: 'Bob', last_name: 'Tilan')
      }

      let!(:corporation) {
        create(:customer_vault_corporation, name: 'Zorg Corp')
      }


      it 'should sort people by name by default' do
        get :list
        expect(assigns(:people)).to eq([bob, alice, corporation])
      end
    end

    describe "search" do
      it "search should ignore filters" do
        corporation1 = create(:customer_vault_corporation, tag_list: "abc", name: "aaa")
        corporation2 = create(:customer_vault_corporation, tag_list: "xyz", name: "bbb")
        @request.cookies["filters"] = {tags: ["abc"]}.to_json
        get :list, params: {q: "bbb"}
        expect(assigns(:people)).to eq [corporation2]
      end
    end
  end

  describe "activity" do
    before do
      @person = create(:customer_vault_corporation)
      @comment1 = @person.comments.create!(text: "ABC", created_at: Time.zone.now - 3.days, author: user)
      @comment2 = @person.comments.create!(text: "DEF", created_at: Time.zone.now - 2.days, author: user)
      @comment3 = @person.comments.create!(text: "DEF", created_at: Time.zone.now - 9.days, author: user)
    end

    it "should assigns all comments ordered by created_at DESC" do
      get :activity
      expect(assigns(:comments)).to eq [@comment2, @comment1, @comment3]
    end
  end

end
