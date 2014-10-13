require 'rails_helper'

module Dorsale
  RSpec.describe "dorsale/addresses/new", :type => :view do
    before(:each) do
      assign(:address, Address.new(
        :street => "MyString",
        :street_bis => "MyString",
        :city => "MyString",
        :zip => "MyString",
        :country => "MyString"
      ))
    end

    it "renders new address form" do
      render

      assert_select "form[action=?][method=?]", dorsale.addresses_path, "post" do

        assert_select "input#address_street[name=?]", "address[street]"

        assert_select "input#address_street_bis[name=?]", "address[street_bis]"

        assert_select "input#address_city[name=?]", "address[city]"

        assert_select "input#address_zip[name=?]", "address[zip]"

        assert_select "input#address_country[name=?]", "address[country]"
      end
    end
  end
end