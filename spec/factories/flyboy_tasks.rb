FactoryGirl.define do
  factory :flyboy_task, class: Dorsale::Flyboy::Task do
    taskable { create(:flyboy_folder) }

    name        { "I-am-a-task#{Kernel.rand(0..9999)}"                }
    description { "I-am-the-task-description_#{Kernel.rand(0..9999)}" }
    reminder "2013-08-27"
    term "2013-08-27"
    done false
  end
end
