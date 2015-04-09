$ ->
  $("button.reset").click ->
    form = $(this).parents("form")

    form.find("option").map ->
      this.selected = true if this.value == ""

    form.find("input").map ->
      this.value = "" unless this.type.match(/submit|hidden|button/)

    form.find("textarea").val("")
