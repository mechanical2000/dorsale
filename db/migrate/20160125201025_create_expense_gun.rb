class CreateExpenseGun < ActiveRecord::Migration
  def change

    create_table :dorsale_expense_gun_expenses do |t|
      t.string :name
      t.string :state
      t.date :date
      t.timestamps null: false
    end

    create_table :dorsale_expense_gun_expense_lines do |t|
      t.integer :expense_id
      t.integer :category_id
      t.string :name
      t.date :date
      t.float :total_all_taxes
      t.float :vat
      t.float :company_part
      t.timestamps null: false
    end

    create_table :dorsale_expense_gun_categories do |t|
      t.string :name
      t.string :code
      t.boolean :vat_deductible
    end

    add_index :dorsale_expense_gun_expense_lines, :expense_id
    add_index :dorsale_expense_gun_expense_lines, :category_id

  end
end
