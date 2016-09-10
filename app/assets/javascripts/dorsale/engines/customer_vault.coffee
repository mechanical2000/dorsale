$(document).on "ready turbolinks:load page:load", ->
  $(".customer_vault select[name*=tag]").map ->
    placeholder = $(this).attr("placeholder")

    $(this).select2
      tags: true
      placeholder: placeholder


  $(".customer_vault .filters select[name*=tag]").map ->
    placeholder = $(this).attr("placeholder")

    $(this).select2
      tags: false
      placeholder: placeholder
