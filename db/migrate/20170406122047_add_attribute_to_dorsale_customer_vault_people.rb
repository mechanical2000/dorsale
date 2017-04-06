class AddAttributeToDorsaleCustomerVaultPeople < ActiveRecord::Migration[5.0]
  class Person < ActiveRecord::Base
    self.table_name = 'dorsale_customer_vault_people'
  end

  class Individual < Person
  end

  class Corporation < Person
  end

  def change
    add_column :dorsale_customer_vault_people, :context, :text
    add_column :dorsale_customer_vault_people, :corporation_id, :integer
    migrate_individuals_context
    migrate_corporations_immatriculation_numbers
  end

  def migrate_individuals_context
    Individual.all.each do |individual|
      data = JSON.parse(individual.data)
      individual.context = data["context"]
      data.delete("context")
      individual.data = data.to_json
      individual.save!
    end
  end

  def migrate_corporations_immatriculation_numbers
    Corporation.all.each do |corporation|
      data = JSON.parse(corporation.data)
      immatriculation_number = "#{data['immatriculation_number_1']} / #{data['immatriculation_number_2']}"
      data.delete["immatriculation_number_1"]
      data.delete["immatriculation_number_2"]
      data["immatriculation_number"] = immatriculation_number
      corporation.data = data.to_json
      corporation.save!
    end
  end
end
