class AddAttributeToDorsaleCustomerVaultPeople < ActiveRecord::Migration[5.0]
  class Person < ActiveRecord::Base
    self.table_name = :dorsale_customer_vault_people
  end

  def change
    add_column :dorsale_customer_vault_people, :context, :text
    add_column :dorsale_customer_vault_people, :corporation_id, :integer
    migrate_individuals_context
    migrate_corporations_immatriculation_numbers
  end

  def migrate_individuals_context
    Dorsale::CustomerVault::Individual.all.each do |individual|
      data = JSON.parse(individual.data_before_type_cast)

      individual.update_columns context: data["context"]
      data.delete("context")

      Person.where(id: individual.id).update_all(data: data.to_json)
    end
  end

  def migrate_corporations_immatriculation_numbers
    Dorsale::CustomerVault::Corporation.all.each do |corporation|
      data = JSON.parse(corporation.data_before_type_cast)

      immatriculation_number = "#{data['immatriculation_number_1']} / #{data['immatriculation_number_2']}"
      data.delete("immatriculation_number_1")
      data.delete("immatriculation_number_2")
      data["immatriculation_number"] = immatriculation_number

      Person.where(id: corporation.id).update_all(data: data.to_json)
    end
  end
end
