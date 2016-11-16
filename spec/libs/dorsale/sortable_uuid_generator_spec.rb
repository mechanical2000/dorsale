require 'rails_helper'

RSpec.describe Dorsale::SortableUUIDGenerator do
  it "should generate a valid uuid" do
    uuid = described_class.generate
    expect(uuid).to match described_class::REGEX_WITH_DASH
  end

  it "should be incremental" do
    uuids = 1_000.times.map { described_class.generate }
    expect(uuids).to eq uuids.dup.sort
  end
end
