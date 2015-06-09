require 'rails_helper'

describe Dorsale::TextHelper, type: :helper do
  it "hours" do
    expect(hours(1)).to eq "1.00 hour"
    expect(hours(3)).to eq "3.00 hours"
    expect(hours(3.5)).to eq "3.50 hours"
    expect(hours(3.123)).to eq "3.12 hours"
  end

  it "number" do
    expect(number(1)).to eq "1"
    expect(number(1.2)).to eq "1.20"
    expect(number(1.234)).to eq "1.23"
  end
end
