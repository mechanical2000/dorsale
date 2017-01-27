require "rails_helper"

RSpec.describe Dorsale::PolymorphicId do
  it "should return guid" do
    task = create(:flyboy_task)
    expect(task.id).to be_present
    expect(task.guid).to eq "Dorsale::Flyboy::Task-#{task.id}"
  end

  it "should return guid" do
    corporation = create(:customer_vault_corporation)
    task        = build(:flyboy_task, taskable: nil)

    expect(task.taskable).to be_nil
    expect(task.taskable_id).to be_nil
    expect(task.taskable_type).to be_nil

    task.taskable_guid = corporation.guid

    expect(task.taskable).to eq corporation
    expect(task.taskable_id).to eq corporation.id
    expect(task.taskable_type).to eq "Dorsale::CustomerVault::Person"
  end

  it "should return base_class in guid" do
    corporation = create(:customer_vault_corporation)
    expect(corporation.guid).to eq "Dorsale::CustomerVault::Person-#{corporation.id}"
  end

end
