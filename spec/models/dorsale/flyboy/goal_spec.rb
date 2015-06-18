require 'spec_helper'

describe Dorsale::Flyboy::Goal do
  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  describe '#validation' do
    it { should validate_presence_of :name }

    it "should validate the goal when not step is assigned" do
      goal = FactoryGirl.build(:flyboy_goal)
      expect(goal).to be_valid
    end

    it "should ensure that status has a valid value" do
      goal = FactoryGirl.build(:flyboy_goal, status: 999)
      expect(goal).to_not be_valid
    end
  end

  it "should increase the version number" do
    goal = FactoryGirl.create(:flyboy_goal)
    expect(goal.version).to eq 1
    goal.save
    expect(goal.version).to eq 2
    goal.save
    expect(goal.version).to eq 3
  end

  it "should create tracking" do
    Timecop.freeze DateTime.new(2013, 8, 1, 9, 13, 5)

    goal1 = FactoryGirl.create(:flyboy_goal)
    goal2 = FactoryGirl.create(:flyboy_goal)
    goal3 = FactoryGirl.create(:flyboy_goal)

    expect(goal1.tracking).to eq "130801-1"
    expect(goal2.tracking).to eq "130801-2"
    expect(goal3.tracking).to eq "130801-3"
  end

  it "revision should contain tracking and version" do
    Timecop.freeze Date.parse("2012-12-21")
    goal = FactoryGirl.create(:flyboy_goal)
    expect(goal.revision).to eq "121221-1 1"
  end

  describe "#progress" do
    it "update task should update goal progress" do
      goal  = FactoryGirl.create(:flyboy_goal)
      task1 = FactoryGirl.create(:flyboy_task, taskable: goal, progress: 50)
      task2 = FactoryGirl.create(:flyboy_task, taskable: goal, progress: 100)
      expect(goal.reload.progress).to eq 75
      task1.progress = 100
      task1.save
      expect(goal.reload.progress).to eq 100
    end

   it "delete task should update goal progress" do
      goal  = FactoryGirl.create(:flyboy_goal)
      task1 = FactoryGirl.create(:flyboy_task, taskable: goal, progress: 50)
      expect(goal.reload.progress).to eq 50
      task1.destroy
      expect(goal.reload.progress).to eq 0
    end

    it "should be 0 if new goal" do
      expect(Dorsale::Flyboy::Goal.new.progress).to eq 0
    end
  end

  describe "states" do
    it "initial state should be open" do
      expect(Dorsale::Flyboy::Goal.new.status).to eq "open"
    end

    it "open goal can be closed" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      expect(goal.close).to be true
      expect(goal.status).to eq "closed"
    end

    it "closed goal can be reopened" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      expect(goal.open).to be true
      expect(goal.status).to eq "open"
    end

    it "open goal with undone tasks can't be closed" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      task = FactoryGirl.create(:flyboy_task, taskable: goal, done: false)
      expect(goal.close).to be false
      expect(goal.status).to eq "open"
    end

    it "open goal with all tasks done can be closed" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      task = FactoryGirl.create(:flyboy_task, taskable: goal, done: true)
      expect(goal.close).to be true
      expect(goal.status).to eq "closed"
    end

  end

end
