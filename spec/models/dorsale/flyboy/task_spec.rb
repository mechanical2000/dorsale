require 'spec_helper'

describe Dorsale::Flyboy::Task do
  it { is_expected.to belong_to(:taskable) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of :taskable}
  it { is_expected.to validate_presence_of :name}
  it { is_expected.to validate_presence_of :term}
  it { is_expected.to validate_presence_of :reminder}

  describe "default values" do
    before do
      @task = Dorsale::Flyboy::Task.new
    end

    it "#done should be false" do
      expect(@task.done).to be false
    end

    it "#reminter should be present" do
      expect(@task.reminder.present?).to be true
    end

    it "#term should be present" do
      expect(@task.term.present?).to be true
    end

    it "#progress should be 0" do
      expect(@task.progress).to eq 0
    end
  end

  describe '#validation' do
    it 'factory should be #valid?' do
      expect(create(:flyboy_task)).to be_valid
    end

    it 'should ensure that term >= reminder' do
      date = Date.today
      task = build(:flyboy_task, reminder: date+1.day, term: date)
      expect(task).to_not be_valid
    end
  end

  describe '#snooze' do
    before do
      @today = Date.today
      @task = build(:flyboy_task, reminder: @today - 5 , term: @today + 5)
    end

    context 'term not passed' do
      it "should snooze the reminder and term with default value" do
        @task.snooze
        expect(@task.reminder).to eq Date.today + 2
        expect(@task.term).to eq Date.today + 35
      end

      context 'reminder too far is the past' do
        it "should set reminder to today" do
          @task.reminder = @today - 30
          @task.term = @today + 1
          @task.snooze
          expect(@task.reminder).to eq Date.today + 1
          expect(@task.term).to eq Date.today + 1
        end
      end
    end

    context 'term passed' do
      before do
        @task.term = Date.today - 2
      end

      it "should snooze the reminder and term with default value from current date" do
        @task.snooze
        expect(@task.reminder).to eq @today + 7
        expect(@task.term).to eq @today + 30
      end
    end

  end # describe '#snooze'
end
