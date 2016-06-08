# Fake file input (bootstrap style)s
window.setupUploadInputs = (scope = document) ->
  $(scope).find(".form-group.upload").map ->
    group    = $(this)
    form     = group.parents("form")
    input    = group.find("[type=file]")
    submit   = group.find("[type=submit]")
    label    = group.find("label")
    progress = group.find(".progress")

    progress.hide() if not xhr2_available()

    label.map ->
      this.dataset.defaultValue = $(this).html()

    input.change ->
      if this.value == ""
        submit.prop(disabled: true)
        label_value = label.data("defaultValue")
      else
        submit.prop(disabled: false)
        label_value = this.value.split("/").pop().split("\\").pop()

      label.html(label_value)
    input.change()

$(document).on "ready page:load", ->
  $("button.reset").click ->
    form = $(this).parents("form")

    form.find("select option:first-child").map ->
      this.selected = true

    form.find("input").map ->
      return if this.type.match(/submit|hidden|button/)
      this.value = $(this).data("default-value") || ""

    form.find("textarea").map ->
      this.value = $(this).data("default-value") || ""

    form.find("select").map ->
      this.selectize.clear() if this.selectize

  # Referer with anchor
  $("form").submit ->
    return if this.method.toUpperCase() == "GET"
    return if $(this).find("[name=back_url]").length > 0

    input       = document.createElement("input")
    input.type  = "hidden"
    input.name  = "back_url"
    input.value = location.href
    $(this).append(input)

  setupUploadInputs()
