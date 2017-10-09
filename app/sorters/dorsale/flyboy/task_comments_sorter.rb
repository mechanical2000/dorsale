class Dorsale::Flyboy::TaskCommentsSorter < Agilibox::Sorter
  def sort
    case column
    when :date
      %(#{column} #{direction})
    else
      "date DESC"
    end
  end
end
