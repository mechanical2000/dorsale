require 'rails_helper'

module Dorsale
  RSpec.describe "dorsale/addresses/show", :type => :view do
    before(:each) do
      @address = assign(:address, Address.create!(
        :street => "Street",
        :street_bis => "Street Bis",
        :city => "City",
        :zip => "Zip",
        :country => "Country"
      ))
    end

    it "renders attributes in <p>" do
      render
      expect(rendered).to match(/Street/)
      expect(rendered).to match(/Street Bis/)
      expect(rendered).to match(/City/)
      expect(rendered).to match(/Zip/)
      expect(rendered).to match(/Country/)
    end
  end
end