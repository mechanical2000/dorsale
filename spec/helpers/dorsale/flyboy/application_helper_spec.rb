require 'rails_helper'

describe Dorsale::Flyboy::ApplicationHelper, type: :helper do
  describe '#task_color' do
    # L’affichage de la couleur de la tâche dépend de son achèvement:
    # Si date jour < date relance alors noir
    it 'should return .ontime' do
      task = create(:flyboy_task, reminder_type: "custom", reminder_date: Time.zone.now.to_date + 1.day, term: Time.zone.now.to_date + 3.days, done: false)
      expect(task_color(task)).to eq('ontime')
    end
    # Si date relance < date jour < date butoir alors orange
    it 'should return .onwarning' do
      task = create(:flyboy_task, reminder_type: "custom", reminder_date: Time.zone.now.to_date - 1.day, term: Time.zone.now.to_date + 3.days, done: false)
      expect(task_color(task)).to eq('onwarning')
    end
    # Si date butoir < date jour alors rouge
    it 'should return .onalert' do
      task = create(:flyboy_task, reminder_type: "custom", reminder_date: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: false)
      expect(task_color(task)).to eq('onalert')
    end
    # Si action faite alors vert
    it 'should return .finished' do
      task = create(:flyboy_task, reminder_type: "custom", reminder_date: Time.zone.now.to_date - 3.days, term: Time.zone.now.to_date - 1.day, done: true )
      expect(task_color(task)).to eq('finished')
    end
  end
end
