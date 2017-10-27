require "rails_helper"

describe Dorsale::Flyboy::Task::Snoozer do
  describe "#snooze" do
    it "should snooze term" do
      task = create(:flyboy_task, term: "2017-04-13")
      expect(task.snoozer.snooze).to be true
      expect(task.term).to eq Date.parse("2017-04-20")
    end

    it "should auto update reminder_date for duration reminder type" do
      task = create(:flyboy_task,
        :term              => "2017-04-13",
        :reminder_type     => "duration",
        :reminder_duration => 1,
        :reminder_unit     => "days",
      )
      expect(task.reminder_date).to eq Date.parse("2017-04-12")

      expect(task.snoozer.snooze).to be true
      expect(task.term).to          eq Date.parse("2017-04-20")
      expect(task.reminder_date).to eq Date.parse("2017-04-19")
    end

    it "should snooze reminder_date" do
      task = create(:flyboy_task,
        :term              => "2017-04-13",
        :reminder_type     => "custom",
        :reminder_date     => "2017-04-12",
      )

      expect(task.snoozer.snooze).to be true
      expect(task.term).to          eq Date.parse("2017-04-20")
      expect(task.reminder_date).to eq Date.parse("2017-04-19")
    end
  end # describe "#snooze"

  describe "#snoozable?" do
    before do
      Timecop.freeze "2017-04-13 12:00:00"
    end

    it "should always be false if task is done" do
      task = create(:flyboy_task,
        :done              => true,
        :term              => 1.day.ago,
        :reminder_type     => "custom",
        :reminder_date     => 2.days.ago,
      )

      expect(task.snoozer.snoozable?).to be false
    end

    it "should true if term is today" do
      task = create(:flyboy_task,
        :done              => false,
        :term              => Date.current,
        :reminder_type     => nil,
      )

      expect(task.snoozer.snoozable?).to be true
    end

    it "should true if term is yesterday" do
      task = create(:flyboy_task,
        :done              => false,
        :term              => Date.yesterday,
        :reminder_type     => nil,
      )

      expect(task.snoozer.snoozable?).to be true
    end

    it "should false if term is tomorrow" do
      task = create(:flyboy_task,
        :done              => false,
        :term              => Date.tomorrow,
        :reminder_type     => nil,
      )

      expect(task.snoozer.snoozable?).to be false
    end

    it "should true if reminder_date is today" do
      task = create(:flyboy_task,
        :done              => false,
        :term              => "2017-04-20", # future
        :reminder_type     => "custom",
        :reminder_date     => Date.current,
      )

      expect(task.snoozer.snoozable?).to be true
    end

    it "should true if reminder_date is yesterday" do
      task = create(:flyboy_task,
        :done              => false,
        :term              => "2017-04-20", # future
        :reminder_type     => "custom",
        :reminder_date     => Date.yesterday,
      )

      expect(task.snoozer.snoozable?).to be true
    end

    it "should false if reminder_date is tomorrow" do
      task = create(:flyboy_task,
        :done              => false,
        :term              => "2017-04-20", # future
        :reminder_type     => "custom",
        :reminder_date     => Date.tomorrow,
      )

      expect(task.snoozer.snoozable?).to be false
    end
  end # describe "#snoozable?"
end
