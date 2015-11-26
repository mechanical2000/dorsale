$(document).on "ready page:load", ->
  $(".attachments .attachment [href$=edit]").click ->
    $(this).parents("li").load(this.href)
    return false
