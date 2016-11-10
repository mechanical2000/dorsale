require "rails_helper"

module Dorsale
  describe SmallData::Filter do
    let(:jar)    { {} }
    let(:filter) { {"name" => "bidule"} }
    let(:f)      { Dorsale::SmallData::Filter.new(jar) }

    describe "write" do
      it "should write the provided hash as json in the jar" do
        f.write(filter)
        expect(jar["filters"]).to eq filter.to_json
      end
    end

    describe "read" do
      it "should read stored filters" do
        f.write(filter)
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

    it "should set/get values" do
      filter = Dorsale::CustomerVault::SmallData::FilterForPeople.new({})
      filter.person_type = "truc"
      expect(filter.person_type).to eq "truc"
    end

  end
end
