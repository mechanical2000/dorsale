FactoryGirl.define do
  factory :flyboy_task_comment, class: ::Dorsale::Flyboy::TaskComment do
    task { create(:flyboy_task) }
    date { DateTime.now }
    progress 95
    description "I-am-a-task-comment"
  end
end
