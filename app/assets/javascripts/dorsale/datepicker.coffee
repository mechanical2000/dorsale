$(document).on "ready page:load", ->
  $("input[type*=date], input[name*=date]").map ->
    this.type = "text"

    if this.value.match("-")
      date = this.value.split("-")
      this.value = date[2] + "/" + date[1] + "/" + date[0]

    $(this).datepicker
      language: "fr"
