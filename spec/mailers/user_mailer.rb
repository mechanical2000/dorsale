require "rails_helper"

describe ::Dorsale::UserMailer do
  describe "New Account" do
    let(:user) { create(:user) }
    let(:email) { ::Dorsale::UserMailer.new_account(user, user.password) }

    it "should send to the right person" do
      expect(email.to).to eq([user.email])
    end

    it "should have the right sender" do
      expect(email.from).to eq(["contact@example.org"])
    end

    it "should contain user_type, login and password" do
      expect(email.body).to include user.email
      expect(email.body).to include user.password
    end
  end
end
