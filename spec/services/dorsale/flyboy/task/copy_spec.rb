require "rails_helper"

RSpec.describe Dorsale::Flyboy::Task::Copy do
  let(:task) {
    create(:flyboy_task, done: true, progress: 50)
  }

  let(:copy) {
    copy = Dorsale::Flyboy::Task::Copy.(task)
    copy.save!
    copy
  }

  it "is expected to duplicate the whole object" do
    expect(copy).to be_persisted
    expect(copy.name).to                    eq task.name
    expect(copy.owner).to                   eq task.owner
    expect(copy.description).to             eq task.description
  end

  it "is expected to set the progress to 0" do
    expect(copy.progress).to eq 0
  end
end
