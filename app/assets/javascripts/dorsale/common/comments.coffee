window.dorsaleComments =
  setup: ->
    dorsaleComments.setupCreateForm()
    dorsaleComments.setupEditForm()
    dorsaleComments.setupEditButtons()
    dorsaleComments.setupDeleteButtons()
    dorsaleComments.setupShowMoreLinks()

  setupCreateForm: ->
    $(document).on "ajax:success", "form#new-dorsale-comment", (e, data) ->
      if data.length
        $(this).find("#comment_title, #comment_text").val("")
        $(this).find("input[id$=title], textarea[id$=text]").val("")
        $(".dorsale-comments-list").prepend(data)

  setupEditForm: ->
    $(document).on "ajax:success", "form#edit-dorsale-comment", (e, data) ->
     $(this).replaceWith(data)

  setupEditButtons: ->
    $(document).on "click", "a.edit-dorsale-comment", ->
      container = $(this).parents(".comment")
      url       = this.href

      $.ajax
        url: url
        success: (data) ->
          container.replaceWith(data)
          setupDatepickers()

      return false

  setupDeleteButtons: ->
    $(document).on "ajax:success", ".delete-dorsale-comment", ->
      $(this).parents(".comment").fadeOut ->
        $(this).remove()

  setupShowMoreLinks: ->
    $(document).on "click", ".comment-show_more", ->
      $(this).parents(".comment-text-truncated").remove()
      return false


dorsaleComments.setup()
