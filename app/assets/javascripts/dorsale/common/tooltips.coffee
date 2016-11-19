$(document).on "turbolinks:load", ->
  $(".title-tooltip").map ->
    $(this).tooltip(html: this.title)
