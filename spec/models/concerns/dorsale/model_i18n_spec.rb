require "rails_helper"

RSpec.describe Dorsale::ModelI18n, type: :model do
  it "should translate model name on class" do
    expect(User.t).to eq "Utilisateur"
    expect(User.ts).to eq "Utilisateurs"
  end

  it "should translate model name on instances" do
    expect(User.new.t).to eq "Utilisateur"
    expect(User.new.ts).to eq "Utilisateurs"
  end

  it "should translate attributes on class" do
    expect(User.t :name).to eq "Nom"
  end

  it "should translate attributes on instances" do
    expect(User.new.t :name).to eq "Nom"
  end
end
