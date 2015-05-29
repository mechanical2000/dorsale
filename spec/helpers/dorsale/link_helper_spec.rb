require 'rails_helper'

describe Dorsale::LinkHelper, type: :helper do
  it "web_link" do
    expect(web_link("")).to be nil
    expect(web_link(nil)).to be nil
    expect(web_link("google.fr")).to eq %(<a href="http://google.fr">google.fr</a>)
    expect(web_link("http://google.fr")).to eq %(<a href="http://google.fr">http://google.fr</a>)
  end

  it "tel_link" do
    expect(tel_link("")).to be nil
    expect(tel_link(nil)).to be nil
    expect(tel_link("123")).to eq %(<a href="tel:123">123</a>)
  end

  it "email_link" do
    expect(email_link("")).to be nil
    expect(email_link(nil)).to be nil
    expect(email_link("aaa@bbb.com")).to eq %(<a href="mailto:aaa@bbb.com">aaa@bbb.com</a>)
  end
end
