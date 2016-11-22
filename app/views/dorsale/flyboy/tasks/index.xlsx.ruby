data = [
  [
    model.t(:taskable),
    model.t(:taskable_type),
    model.t(:taskable_progress),
    model.t(:name),
    model.t(:progress),
    model.t(:term),
  ]
]

@tasks_without_pagination.each do |task|
  data << [
    task.taskable.name,
    task.taskable.class.t,
    percentage(task.taskable.try(:progress)),
    task.name,
    percentage(task.progress),
    date(task.term),
  ]
end

Dorsale::Serializers::XLSX.new(data).render_inline
