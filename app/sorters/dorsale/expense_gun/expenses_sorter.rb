class Dorsale::ExpenseGun::ExpensesSorter < Agilibox::Sorter
  def sort
    case column
    when :created_at, :date
      {column => direction}
    end
  end
end
