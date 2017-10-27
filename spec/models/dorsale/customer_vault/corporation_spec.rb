require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Corporation, type: :model do
  it { is_expected.to have_one(:address).dependent(:destroy) }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :taggings }
  it { is_expected.to have_many :tags }
  it { is_expected.to have_many :individuals }
  it { is_expected.to have_many(:tasks).dependent(:destroy) }
  it { is_expected.to have_many(:events).dependent(:destroy) }

  it { is_expected.to respond_to :legal_form }
  it { is_expected.to respond_to :capital }
  it { is_expected.to respond_to :immatriculation_number }
  it { is_expected.to respond_to :naf }
  it { is_expected.to respond_to :revenue }
  it { is_expected.to respond_to :context }
  it { is_expected.to respond_to :number_of_employees }
  it { is_expected.to respond_to :societe_com }

  it { is_expected.to belong_to :activity_type }
  it { is_expected.to belong_to :origin }

  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of :corporation_name }
end
