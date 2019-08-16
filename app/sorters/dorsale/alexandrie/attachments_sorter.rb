class Dorsale::Alexandrie::AttachmentsSorter < Agilibox::Sorter
  def sort
    case column
    when :created_at, :updated_at
      {column => direction}
    when :name
      Arel.sql %(LOWER(#{model.table_name}.#{column}) #{direction})
    when :attachment_type_name
      @collection = @collection.joins(:attachment_type)
      table = Dorsale::Alexandrie::AttachmentType.table_name
      Arel.sql %(LOWER(#{table}.name) #{direction})
    else
      {created_at: :desc, id: :desc}
    end
  end

  private

  def model
    Dorsale::Alexandrie::Attachment
  end
end
