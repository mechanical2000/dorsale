require 'rails_helper'

module Dorsale
  RSpec.describe "dorsale/addresses/edit", :type => :view do
    before(:each) do
      @address = assign(:address, Address.create!(
        :street => "MyString",
        :street_bis => "MyString",
        :city => "MyString",
        :zip => "MyString",
        :country => "MyString"
      ))
    end

    it "renders the edit address form" do
      render

      assert_select "form[action=?][method=?]", dorsale.address_path(@address), "post" do

        assert_select "input#address_street[name=?]", "address[street]"

        assert_select "input#address_street_bis[name=?]", "address[street_bis]"

        assert_select "input#address_city[name=?]", "address[city]"

        assert_select "input#address_zip[name=?]", "address[zip]"

        assert_select "input#address_country[name=?]", "address[country]"
      end
    end
  end
end
