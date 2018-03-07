# Fake file input (bootstrap style)
window.setupUploadInputs = (scope = document) ->
  $(scope).find(".form-control.upload").map ->
    container = $(this)
    form      = container.parents("form")
    input     = container.find("[type=file]")
    label     = container.find("label")
    submit    = form.find("[type=submit]")
    progress  = form.find(".progress")

    label.map ->
      this.dataset.defaultValue = $(this).html()

    input.change ->
      if this.value == ""
        submit.prop(disabled: true) if input.hasClass("required")
        label_value = label.data("defaultValue")
      else
        submit.prop(disabled: false)
        label_value = this.value.split("/").pop().split("\\").pop()

      label.html(label_value)
    input.change()
