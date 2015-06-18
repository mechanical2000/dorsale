require 'spec_helper'

describe Dorsale::Flyboy::ApplicationHelper, type: :helper do

  describe '#goal_color' do
    let!(:goal) {
      FactoryGirl.create(:flyboy_goal)
    }

    # ensure that tasks are filtered by group
    let!(:task_other_group_onalert) {
      FactoryGirl.create(:flyboy_task, reminder: Date.today - 3.days, term: Date.today - 1.day, done: false)
    }

    let!(:task_other_group_onwarning) {
      FactoryGirl.create(:flyboy_task, reminder: Date.today - 3.days, term: Date.today + 1.day, done: false)
    }

    #ensure tasks are filtered by goal
    let!(:other_goal) {
      FactoryGirl.create(:flyboy_goal)
    }
    let!(:task_onalert_for_other_goal) {
      FactoryGirl.create(:flyboy_task, taskable: other_goal, reminder: Date.today - 3.days, term: Date.today - 1.day, done: false)
    }
    let!(:task_onwarning_for_other_goal) {
      FactoryGirl.create(:flyboy_task, taskable: other_goal, reminder: Date.today - 3.days, term: Date.today + 1.day, done: false)
    }

    let!(:task_ontime) {
      FactoryGirl.create(:flyboy_task, taskable: goal, reminder: Date.today + 1.day, term: Date.today + 3.days, done: false)
    }
    let!(:task_finished) {
      FactoryGirl.create(:flyboy_task, taskable: goal, reminder: Date.today - 3.days, term: Date.today - 1.day, done: true)
    }

    context 'when all tasks are ontime or finished' do
      it 'should return ontime' do
        goal_color(goal).should eq('ontime')
      end

    end

    context 'when the goal is closed' do
      it 'should return finished' do
        goal_finished = FactoryGirl.create(:flyboy_goal, :status => "closed")
        goal_color(goal_finished).should eq('finished')
      end
    end

    context 'when at least one task is on warning' do
      let!(:task_onwarning) {FactoryGirl.create(:flyboy_task, taskable: goal, reminder: Date.today - 3.days, term: Date.today + 1.day, done: false)}
      it 'should return onwarning' do
        goal_color(goal).should eq('onwarning')
      end
    end

    context 'when at least one task is on alert' do
      let!(:task_onwarning) {FactoryGirl.create(:flyboy_task, taskable: goal, reminder: Date.today - 3.days, term: Date.today - 1.day, done: false)}

      it 'should return onalert' do
        goal_color(goal).should eq('onalert')
      end
    end
  end

  describe '#task_color' do
    # L’affichage de la couleur de la tâche dépend de son achèvement:
    # Si date jour < date relance alors noir
    it 'should return .ontime' do
      task = FactoryGirl.create(:flyboy_task, reminder: Date.today + 1.day, term: Date.today + 3.days, done: false)
      task_color(task).should eq('ontime')
    end
    # Si date relance < date jour < date butoir alors orange
    it 'should return .onwarning' do
      task = FactoryGirl.create(:flyboy_task, reminder: Date.today - 1.day, term: Date.today + 3.days, done: false)
      task_color(task).should eq('onwarning')
    end
    # Si date butoir < date jour alors rouge
    it 'should return .onalert' do
      task = FactoryGirl.create(:flyboy_task, reminder: Date.today - 3.days, term: Date.today - 1.day, done: false)
      task_color(task).should eq('onalert')
    end
    # Si action faite alors vert
    it 'should return .finished' do
      task = FactoryGirl.create(:flyboy_task, reminder: Date.today - 3.days, term: Date.today - 1.day, done: true )
      task_color(task).should eq('finished')
    end
  end

end
