require 'spec_helper'

describe ::Ability do
  let(:ability){
    ::Ability.new
  }

  describe Dorsale::Flyboy::Folder do
    it "can list folders" do
      expect(ability.can?(:list, Dorsale::Flyboy::Folder)).to be true
    end

    it "can create folders" do
      expect(ability.can?(:create, Dorsale::Flyboy::Folder.new)).to be true
    end

    it "can read folders" do
      expect(ability.can?(:read, Dorsale::Flyboy::Folder.new)).to be true
    end

    it "can update open folders" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      expect(ability.can?(:update, folder)).to be true
    end

    it "can't update closed folders" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      expect(ability.can?(:update, folder)).to be false
    end

    it "can delete open folders" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      expect(ability.can?(:delete, folder)).to be true
    end

    it "can't delete closed folders" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      expect(ability.can?(:delete, folder)).to be false
    end

    it "can close open folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      expect(ability.can?(:close, folder)).to be true
    end

    it "can't close already closed folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      expect(ability.can?(:close, folder)).to be false
    end

    it "can open closed folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      expect(ability.can?(:open, folder)).to be true
    end

    it "can't close folders with undone tasks" do
      task = FactoryGirl.create(:flyboy_task, done: false)
      folder = task.taskable
      expect(ability.can?(:close, folder)).to be false
    end

    it "can't open already open folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      expect(ability.can?(:open, folder)).to be false
    end
  end

  describe Dorsale::Flyboy::Task do
    it "can list tasks" do
      expect(ability.can?(:list, Dorsale::Flyboy::Task)).to be true
    end

    it "can create task in an open folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      task = folder.tasks.new
      expect(ability.can?(:create, task)).to be true
    end

    it "can't create task in a closed folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      task = folder.tasks.new
      expect(ability.can?(:create, task)).to be false
    end

    it "can read task" do
      task = FactoryGirl.create(:flyboy_task)
      expect(ability.can?(:read, task)).to be true
    end

    it "can update task in an open folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      task = FactoryGirl.create(:flyboy_task, taskable: folder)
      expect(ability.can?(:update, task)).to be true
    end

    it "can't update task in an closed folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      task = FactoryGirl.create(:flyboy_task, taskable: folder)
      expect(ability.can?(:update, task)).to be false
    end

    it "can delete task in an open folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "open")
      task = FactoryGirl.create(:flyboy_task, taskable: folder)
      expect(ability.can?(:delete, task)).to be true
    end

    it "can't delete task in an closed folder" do
      folder = FactoryGirl.create(:flyboy_folder, status: "closed")
      task = FactoryGirl.create(:flyboy_task, taskable: folder)
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
