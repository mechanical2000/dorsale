require 'rails_helper'

RSpec.describe ::Dorsale::CustomerVault::Corporation, type: :model do
    it { should have_one(:address).dependent(:destroy) }
    it { should have_many :comments }
    it { should have_many :taggings }
    it { should have_many :tags }
    it { should have_many(:tasks).dependent(:destroy) }

    it { should respond_to :legal_form }
    it { should respond_to :capital }
    it { should respond_to :immatriculation_number_1 }
    it { should respond_to :immatriculation_number_2 }

    it { should validate_presence_of :name }
end

