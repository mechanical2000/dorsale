require 'rails_helper'

module Dorsale
  RSpec.describe Address, :type => :model do
    it {should validate_presence_of :city}
    it {should belong_to :addressable}
  end
end
