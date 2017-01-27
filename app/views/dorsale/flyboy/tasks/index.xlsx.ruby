data = [
  [
    model.t(:taskable),
    model.t(:taskable_type),
    model.t(:name),
    model.t(:progress),
    model.t(:term),
  ]
]

@tasks_without_pagination.each do |task|
  data << [
    task.taskable.to_s,
    (task.taskable.class.t if task.taskable),
    task.name,
    percentage(task.progress),
    date(task.term),
  ]
end

Dorsale::Serializers::XLSX.new(data).render_inline
