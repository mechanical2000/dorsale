FactoryGirl.define do
  factory :flyboy_task, class: ::Dorsale::Flyboy::Task do
    taskable { create(:flyboy_folder) }

    name        { "I-am-a-task#{Kernel.rand(1_000..9_999)}"                }
    description { "I-am-the-task-description_#{Kernel.rand(1_000..9_999)}" }
    progress    { Kernel.rand(0..99) }
    term        { Kernel.rand(0..1000).days.ago }
    reminder    { term - 30.days }
    done false
  end
end
