FactoryBot.define do
  factory :flyboy_task, class: ::Dorsale::Flyboy::Task do
    name        { "I-am-a-task#{Kernel.rand(1_000..9_999)}" }
    description { "I-am-the-task-description_#{Kernel.rand(1_000..9_999)}" }
    progress    { Kernel.rand(0..99) }
    done        { false }
  end
end
