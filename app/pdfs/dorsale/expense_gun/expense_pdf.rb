class Dorsale::ExpenseGun::ExpensePdf < Dorsale::ApplicationPdf
  attr_reader :expense

  def initialize(expense)
    @expense = expense
    super(page_layout: :landscape)
  end

  delegate :attachments, to: :expense

  def build
    font_size  11

    text "Note de frais : #{expense}", align: :center, size: 16, style: :bold

    move_down 10.mm

    info expense, :user

    move_down 10.mm

    font_size 9 do
      table(table_data, width: bounds.width) do |t|
        t.row(0).font_style = :bold
      end
    end

    move_down 10.mm

    info expense, :total_all_taxes, helper: :euros
    info expense, :total_employee_payback, helper: :euros
    info expense, :total_vat_deductible, helper: :euros
  end

  private

  def info(obj, attribute, helper: nil, **options)
    key = obj.t(attribute)
    value = obj.public_send(attribute)
    value = helper ? H.public_send(helper, value) : value.to_s
    text "<b>#{key} :</b> #{value}", inline_format: true, **options
  end

  def table_data
    [table_headers] + table_body
  end

  def table_headers
    [
      :name,
      :category,
      :date,
      :total_all_taxes,
      :company_part,
      :employee_payback,
      :vat,
      :total_vat_deductible,
    ].map { |attr| Dorsale::ExpenseGun::ExpenseLine.t(attr) }
  end

  def table_body
    expense.expense_lines.map do |line|
      [
        line.name.to_s,
        line.category.to_s,
        H.date(line.date),
        H.euros(line.total_all_taxes),
        H.euros(line.company_part),
        H.euros(line.employee_payback),
        H.euros(line.vat),
        H.euros(line.total_vat_deductible),
      ]
    end
  end
end
