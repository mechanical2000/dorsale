# Fake file input (bootstrap style)
window.setupUploadInputs = (scope = document) ->
  $(scope).find(".form-control.upload").map ->
    container = $(this)
    form      = container.parents("form")
    input     = container.find("[type=file]")
    label     = container.find("label")
    submit    = form.find("[type=submit]")
    progress  = form.find(".progress")

    progress.hide() if not xhr2_available()

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

$(document).on "turbolinks:load", ->
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
      $(this).val("").trigger("change")

  # Referer with anchor
  $("form").submit ->
    return if this.method.toUpperCase() == "GET"
    return if $(this).find("[name=form_url]").length > 0

    input       = document.createElement("input")
    input.type  = "hidden"
    input.name  = "form_url"
    input.value = location.href
    $(this).append(input)

  $("select").map ->
    select = $(this)
    form   = select.parents("form")

    return if select.find("[value=custom_date]").length == 0

    select.change ->
      if select.val() == "custom_date"
        form.find(".form-group[class*=date_begin], .form-group[class*=date_end]").show()
      else
        form.find("input[id*=date_begin], input[id*=date_end]").val("")
        form.find(".form-group[class*=date_begin], .form-group[class*=date_end]").hide()

    select.change()
