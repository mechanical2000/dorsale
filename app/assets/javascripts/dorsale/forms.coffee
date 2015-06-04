$(document).on "ready page:load", ->
  $("button.reset").click ->
    form = $(this).parents("form")

    form.find("option").map ->
      this.selected = true if this.value == ""

    form.find("input").map ->
      this.value = "" unless this.type.match(/submit|hidden|button/)

    form.find("textarea").val("")

    form.find("select").map ->
      this.selectize.clear() if this.selectize

  # Referer with anchor
  $("form").submit ->
    if $(this).find("[name=back_url]").length == 0
      input       = document.createElement("input")
      input.type  = "hidden"
      input.name  = "back_url"
      input.value = location.href
      $(this).append(input)
