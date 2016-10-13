$(document).on "ready turbolinks:load page:load", ->
  $("form:not([action*=filters]) select[multiple][name*=tag]").not(".select2-hidden-accessible").map ->
    placeholder = $(this).attr("placeholder")

    $(this).select2
      tags: true
      placeholder: placeholder


  $(".filters select[multiple][name*=tag]").not(".select2-hidden-accessible").map ->
    placeholder = $(this).attr("placeholder")

    $(this).select2
      tags: false
      placeholder: placeholder
