FactoryGirl.define do
  factory :flyboy_folder, class: Dorsale::Flyboy::Folder do
    name        { "I-am-a-folder_#{Kernel.rand(0..9999)}" }
    description { "I-am-the-folder-description_#{Kernel.rand(0..9999)}" }
    status      { "open" }
  end
end
