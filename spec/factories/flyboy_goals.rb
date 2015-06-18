FactoryGirl.define do
  factory :flyboy_goal, class: Dorsale::Flyboy::Goal do
    name        { "I-am-a-goal_#{Kernel.rand(0..9999)}" }
    description { "I-am-the-goal-description_#{Kernel.rand(0..9999)}" }
    status      { "open" }
  end
end
