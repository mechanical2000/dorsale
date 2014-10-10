require 'rails_helper'

RSpec.describe "addresses/index", :type => :view do
  before(:each) do
    assign(:addresses, [
      Address.create!(
        :street => "Street",
        :street_bis => "Street Bis",
        :city => "City",
        :zip => "Zip",
        :country => "Country"
      ),
      Address.create!(
        :street => "Street",
        :street_bis => "Street Bis",
        :city => "City",
        :zip => "Zip",
        :country => "Country"
      )
    ])
  end

  it "renders a list of addresses" do
    render
    assert_select "tr>td", :text => "Street".to_s, :count => 2
    assert_select "tr>td", :text => "Street Bis".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
