window.setupDatepickers = ->
  $("input[type*=date], input[name*=date], input[name$=_at]").map ->
    return if this.type == "hidden"

    this.type = "text"

    if this.value.match("-")
      date = this.value.split("-")
      this.value = date[2] + "/" + date[1] + "/" + date[0]

    $(this).datepicker
      language: "fr"

$(document).on "ready page:load cocoon:after-insert", ->
  setupDatepickers()
