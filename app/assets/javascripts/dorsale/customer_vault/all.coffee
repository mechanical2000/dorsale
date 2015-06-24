$(document).on "ready page:load", ->
  $(".customer_vault select[name*=tag]").map ->
    $(this).selectize
      create: true
      plugins: ["remove_button"]

  $(".customer_vault .filters select[name*=tag]").map ->
    if this.selectize
      this.selectize.settings.create = false
