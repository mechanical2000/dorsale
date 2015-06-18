require 'spec_helper'

describe ::Ability do
  let(:ability){
    ::Ability.new
  }

  describe Dorsale::Flyboy::Goal do
    it "can list goals" do
      expect(ability.can?(:list, Dorsale::Flyboy::Goal)).to be true
    end

    it "can create goals" do
      expect(ability.can?(:create, Dorsale::Flyboy::Goal.new)).to be true
    end

    it "can read goals" do
      expect(ability.can?(:read, Dorsale::Flyboy::Goal.new)).to be true
    end

    it "can update open goals" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      expect(ability.can?(:update, goal)).to be true
    end

    it "can't update closed goals" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      expect(ability.can?(:update, goal)).to be false
    end

    it "can delete open goals" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      expect(ability.can?(:delete, goal)).to be true
    end

    it "can't delete closed goals" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      expect(ability.can?(:delete, goal)).to be false
    end

    it "can close open goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      expect(ability.can?(:close, goal)).to be true
    end

    it "can't close already closed goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      expect(ability.can?(:close, goal)).to be false
    end

    it "can open closed goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      expect(ability.can?(:open, goal)).to be true
    end

    it "can't close goals with undone tasks" do
      task = FactoryGirl.create(:flyboy_task, done: false)
      goal = task.taskable
      expect(ability.can?(:close, goal)).to be false
    end

    it "can't open already open goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      expect(ability.can?(:open, goal)).to be false
    end
  end

  describe Dorsale::Flyboy::Task do
    it "can list tasks" do
      expect(ability.can?(:list, Dorsale::Flyboy::Task)).to be true
    end

    it "can create task in an open goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      task = goal.tasks.new
      expect(ability.can?(:create, task)).to be true
    end

    it "can't create task in a closed goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      task = goal.tasks.new
      expect(ability.can?(:create, task)).to be false
    end

    it "can read task" do
      task = FactoryGirl.create(:flyboy_task)
      expect(ability.can?(:read, task)).to be true
    end

    it "can update task in an open goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      task = FactoryGirl.create(:flyboy_task, taskable: goal)
      expect(ability.can?(:update, task)).to be true
    end

    it "can't update task in an closed goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      task = FactoryGirl.create(:flyboy_task, taskable: goal)
      expect(ability.can?(:update, task)).to be false
    end

    it "can delete task in an open goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "open")
      task = FactoryGirl.create(:flyboy_task, taskable: goal)
      expect(ability.can?(:delete, task)).to be true
    end

    it "can't delete task in an closed goal" do
      goal = FactoryGirl.create(:flyboy_goal, status: "closed")
      task = FactoryGirl.create(:flyboy_task, taskable: goal)
      expect(ability.can?(:delete, task)).to be false
    end

    it "can complete a undone task" do
      task = FactoryGirl.create(:flyboy_task, done: false)
      expect(ability.can?(:complete, task)).to be true
    end

    it "can't complete a done task" do
      task = FactoryGirl.create(:flyboy_task, done: true)
      expect(ability.can?(:complete, task)).to be false
    end

    it "can snooze a done task" do
      task = FactoryGirl.create(:flyboy_task, done: false)
      expect(ability.can?(:snooze, task)).to be true
    end

    it "can't snooze a done task" do
      task = FactoryGirl.create(:flyboy_task, done: true)
      expect(ability.can?(:snooze, task)).to be false
    end

    it "can't snooze if reminder >= today" do
      task = FactoryGirl.create(:flyboy_task, reminder: Date.today, term: Date.tomorrow)
      expect(ability.can?(:snooze, task)).to be false
    end

    it "can't create a task if it can't read taskable" do
      class DummyObject; end
      task = build(:flyboy_task)
      def task.taskable; DummyObject.new; end

      expect(ability.can?(:create, task)).to be false
    end
  end

end
