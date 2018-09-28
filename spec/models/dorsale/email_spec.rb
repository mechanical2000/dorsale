require "rails_helper"

describe Dorsale::Email do
  describe "validations" do
    it "should validate :to format" do
      email = described_class.new

      expect(email).to allow_value("user@example.org").for(:to)
      expect(email).to allow_value("user1@example.org,user2@example.org").for(:to)
      expect(email).to allow_value("user1@example.org;user2@example.org").for(:to)
      expect(email).to allow_value("User <user@example.com>").for(:to)
      expect(email).to allow_value("<user@example.com>").for(:to)
      expect(email).to allow_value("User <user@example.com>;user2@example.org").for(:to)

      expect(email).to_not allow_value("user").for(:to)
      expect(email).to_not allow_value("user@example.com>").for(:to)
      expect(email).to_not allow_value("<user@example.com").for(:to)
      expect(email).to_not allow_value("valid@example.com;invalid").for(:to)
    end

    it "should validate :cc format" do
      email = described_class.new

      expect(email).to allow_value("").for(:cc)

      expect(email).to allow_value("user@example.org").for(:cc)
      expect(email).to allow_value("user1@example.org,user2@example.org").for(:cc)
      expect(email).to allow_value("user1@example.org;user2@example.org").for(:cc)
      expect(email).to allow_value("User <user@example.com>").for(:cc)
      expect(email).to allow_value("<user@example.com>").for(:cc)
      expect(email).to allow_value("User <user@example.com>;user2@example.org").for(:cc)

      expect(email).to_not allow_value("user").for(:cc)
      expect(email).to_not allow_value("user@example.com>").for(:cc)
      expect(email).to_not allow_value("<user@example.com").for(:cc)
      expect(email).to_not allow_value("valid@example.com;invalid").for(:to)
    end
  end # describe "validations" do
end
