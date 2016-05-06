require "rails_helper"

RSpec.describe Dorsale::Serializers::XLSX do
  let(:data){
    [
      ["Name", "Age"],
      ["Benoit", 27],
    ]
  }

  let(:serializer) {
    Dorsale::Serializers::XLSX.new(data)
  }

  describe "#render_inline" do
    it "should return xlsx content" do
      str = serializer.render_inline
      expect(str).to include "workbook"
      expect(str).to include "worksheet"
      expect(str).to include "xml"
    end
  end

  describe "#render_file" do
    it "should write xlsx content" do
      file_path = Tempfile.new("xlsx")
      serializer.render_file(file_path)
      file_content = File.open(file_path, "rb").read
      expect(file_content).to eq serializer.render_inline
    end
  end

end
