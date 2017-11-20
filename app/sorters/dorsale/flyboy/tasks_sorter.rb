class Dorsale::Flyboy::TasksSorter < Agilibox::Sorter
  def sort
    case column
    when :name, :status
      %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
    when :progress, :term
      %(dorsale_flyboy_tasks.#{column} #{direction})
    when :taskable
      if direction == :asc
        proc { |a, b| a.taskable.to_s.downcase <=> b.taskable.to_s.downcase }
      else
        proc { |a, b| b.taskable.to_s.downcase <=> a.taskable.to_s.downcase }
      end
    when :tags
      %(
        (
          SELECT STRING_AGG(n, ' ' ORDER BY n)
          FROM (
            SELECT name AS n
            FROM tags
            WHERE id IN (
              SELECT taggings.tag_id
              FROM taggings
              WHERE taggable_id = dorsale_flyboy_tasks.id
              AND taggings.taggable_type = '#{Dorsale::Flyboy::Task}'
            )
          ) AS task_tags
        ) #{direction}
      )
    end
  end

  def call
    order = sort

    if order.is_a?(Proc) # sorting by a polymorphic attribute
      result = @collection.sort(&order)
    else
      result = @collection.reorder(order)
    end

    result
  end
end
