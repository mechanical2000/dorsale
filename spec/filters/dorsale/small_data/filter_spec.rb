require "rails_helper"

module Dorsale
  describe SmallData::Filter do
    let(:jar)    { {} }
    let(:filter) { {"name" => "bidule"} }
    let(:f)      { Dorsale::SmallData::Filter.new(jar) }

    describe "store" do
      it "should store the provided hash as json in the jar" do
        f.store(filter)
        expect(jar["filters"]).to eq filter.to_json
      end
    end

    describe "read" do
      it "should read stored filters" do
        f.store(filter)
        expect(f.read).to eq(filter)
      end

      it "should return empty hash by default" do
        expect(f.read).to eq({})
      end

      it "should return empty hash on invalid json" do
        jar["filters"] = "i am invalid"
        expect(f.read).to eq({})
      end
    end

    describe "get" do
      it "should return the value" do
        f.store(filter)
        expect(f.get("name")).to eq("bidule")
      end
    end

    describe "set" do
      it "should set the value" do
        f.store(filter)
        f.set("new", "truc")
        expect(f.get("new")).to eq("truc")
      end
    end
  end
end
