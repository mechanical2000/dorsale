require 'rails_helper'

describe Dorsale::Flyboy::Task do
  it { is_expected.to belong_to(:taskable) }
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :term }
  it { is_expected.to_not validate_presence_of :reminder_type }

  it { is_expected.to_not validate_presence_of :taskable }

  describe "default values" do
    before do
      @task = Dorsale::Flyboy::Task.new
    end

    it "#done should be false" do
      expect(@task.done).to be false
    end

    it "#term should be present" do
      expect(@task.term).to be_present
    end

    it "#reminter should be nil" do
      expect(@task.reminder_type).to     be nil
      expect(@task.reminder_date).to     be nil
      expect(@task.reminder_duration).to be nil
      expect(@task.reminder_unit).to     be nil
    end

    it "#progress should be 0" do
      expect(@task.progress).to eq 0
    end
  end

  describe '#validation' do
    it 'factory should be #valid?' do
      expect(create(:flyboy_task)).to be_valid
    end
  end # describe '#validation'

  describe "reminders" do
    before do
      Timecop.freeze "2017-04-12"
    end

    it "should not validate reminder_date if reminder_type is nil" do
      task = described_class.new(reminder_type: nil)
      task.valid?
      expect(task.errors).to_not have_key :reminder_date
    end

    it "should validate reminder_date if reminder_type is present" do
      task = described_class.new(reminder_type: "custom")
      task.valid?
      expect(task.errors).to have_key :reminder_date
    end

    it "should auto reset reminder_date" do
      task = described_class.new(term: "2017-04-12", reminder_type: "custom", reminder_date: "2017-04-11")
      task.reminder_type = nil
      expect(task.reminder_date).to eq nil
    end

    it "should auto set reminder_date by with days" do
      task = described_class.new(term: "2017-04-12", reminder_type: "duration", reminder_duration: 1, reminder_unit: "days")
      expect(task.reminder_date).to eq Date.parse("2017-04-11")
    end

    it "should auto set reminder_date by with weeks" do
      task = described_class.new(term: "2017-04-12", reminder_type: "duration", reminder_duration: 2, reminder_unit: "weeks")
      expect(task.reminder_date).to eq Date.parse("2017-03-29")
    end

    it "should auto set reminder_date by with months" do
      task = described_class.new(term: "2017-04-12", reminder_type: "duration", reminder_duration: 1, reminder_unit: "months")
      expect(task.reminder_date).to eq Date.parse("2017-03-12")
    end

    it "update term should update reminder_date" do
      task = described_class.new(term: "2017-04-12", reminder_type: "duration", reminder_duration: 1, reminder_unit: "days")
      expect(task.reminder_date).to eq Date.parse("2017-04-11")
      task.term = "2017-04-25"
      expect(task.reminder_date).to eq Date.parse("2017-04-24")
    end
  end # describe "reminders"

  describe "scopes" do
    it "should return delayed unfinished tasks" do
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+1)
      task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-1, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-1, done: false)
      task_3 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-2, done: true)
      task_4 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-2, done: false)
      tasks = ::Dorsale::Flyboy::Task.delayed
      expect(tasks).to contain_exactly(task_2, task_4)
    end

    it "should return today unfinished tasks" do
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+1)
      task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date, done: false)
      tasks = ::Dorsale::Flyboy::Task.today
      expect(tasks).to contain_exactly(task_2)
    end

    it "should return tomorrow unfinished tasks" do
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date)
      task_1 = create(:flyboy_task, owner: @user1, term: Date.tomorrow, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Date.tomorrow, done: false)
      tasks = ::Dorsale::Flyboy::Task.tomorrow
      expect(tasks).to contain_exactly(task_2)
    end

    it "should return this week unfinished tasks" do
      Timecop.freeze(2015, 5, 21, 12, 0, 0)
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date-7, done: false)
      task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+2, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+2, done: false)
      task_3 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+3, done: false)
      task_4 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+5, done: false)
      tasks = ::Dorsale::Flyboy::Task.this_week
      expect(tasks).to contain_exactly(task_2, task_3)
    end

    it "should return next week unfinished tasks" do
      Timecop.freeze(2015, 5, 21)
      task = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date, done: false)
      task_1 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+7, done: true)
      task_2 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+7, done: false)
      task_3 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+9, done: false)
      task_4 = create(:flyboy_task, owner: @user1, term: Time.zone.now.to_date+12, done: false)
      tasks = ::Dorsale::Flyboy::Task.next_week
      expect(tasks).to contain_exactly(task_2, task_3)
    end
  end # describe "scopes"
end
