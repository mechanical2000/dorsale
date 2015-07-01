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
    expect(tel_link("+ 33 6")).to eq %(<a href="tel:+336">+ 33 6</a>)
  end

  it "email_link" do
    expect(email_link("")).to be nil
    expect(email_link(nil)).to be nil
    expect(email_link("aaa@bbb.com")).to eq %(<a href="mailto:aaa@bbb.com">aaa@bbb.com</a>)
  end

  it "twitter_link" do
    expect(twitter_link("")).to be nil
    expect(twitter_link(nil)).to be nil
    expect(twitter_link("BenoitMC")).to eq %(<a href="https://twitter.com/BenoitMC">BenoitMC</a>)
    expect(twitter_link("twitter.com/BenoitMC")).to eq %(<a href="https://twitter.com/BenoitMC">twitter.com/BenoitMC</a>)
    expect(twitter_link("http://twitter.com/BenoitMC")).to eq %(<a href="http://twitter.com/BenoitMC">http://twitter.com/BenoitMC</a>)
  end
end
