window.dorsaleComments =
  setup: ->
    dorsaleComments.setupCreateForm()
    dorsaleComments.setupEditForm()
    dorsaleComments.setupEditButtons()
    dorsaleComments.setupDeleteButtons()
    dorsaleComments.setupShowMoreLinks()

  setupCreateForm: ->
    $("#dorsale-comments").on "ajax:success", "form[id*=new]", (e, data) ->
      if data.length
        $(this).find("textarea").val("")
        $("#dorsale-comments-list").prepend(data)

  setupEditForm: ->
    $("#dorsale-comments-list").on "ajax:success", "form[id*=edit]", (e, data) ->
     $(this).replaceWith(data)

  setupEditButtons: ->
    $("#dorsale-comments-list").on "click", "[href$=edit]", ->
      container = $(this).parents(".comment")
      url       = this.href

      $.ajax
        url: url
        success: (data) ->
          container.replaceWith(data)
          setupDatepickers()

      return false

  setupDeleteButtons: ->
    $("#dorsale-comments-list").on "ajax:success", "[data-method=delete]", ->
      $(this).parents(".comment").fadeOut ->
        $(this).remove()

  setupShowMoreLinks: ->
    $("#dorsale-comments").on "click", ".comment-show_more", ->
      $(this).parents(".comment-text-truncated").remove()
      return false

$(document).on "turbolinks:load", ->
  dorsaleComments.setup()
