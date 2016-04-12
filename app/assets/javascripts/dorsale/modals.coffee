window.modal =
  i18n:
    loading: "Loading..."
    error: "Error."

  template: """
    <div id='modal' class='modal'>
      <div class='modal-overlay modal-close'></div>
      <button class='modal-close'></button>
      <div class='modal-body'>
        {{content}}
      </div>
    </div>
  """

  _generateModalHTML: (content) ->
    $(modal.template.replace("{{content}}", content))

  open: (content) ->
    modal.close()
    $("body").addClass("modal-open")
    $("body").append(modal._generateModalHTML(content))
    $(document).trigger("modal:open")

  close: ->
    $("#modal").remove()
    $("body").removeClass("modal-open")
    $(document).trigger("modal:close")

  openUrl: (url, type = "GET", data = {}) ->
    modal.open(modal.i18n.loading)

    $.ajax
      url: url
      type: type
      data: data
      dataType: "html"
      success: (data) ->
        modal.open(data)
      error: ->
        modal.open(modal.i18n.error)

  _callbacks:
    links: ->
      modal.openUrl(this.href)
      return false

    forms: ->
      modal.openUrl(this.href, this.action, $(this).serialize())
      return false

    escape: (event) ->
      modal.close() if event.keyCode == 27

  setup: ->
    $(document)
      .off("keyup", modal._callbacks.escape)
      .on("keyup", modal._callbacks.escape)

    $(".modal-close")
      .off("click", modal.close)
      .on("click", modal.close)

    $("a[data-modal=1], .modal-body a:not([data-modal=0])")
      .off("click", modal._callbacks.links)
      .on("click", modal._callbacks.links)

    $("form[data-modal=1], .modal-body form:not([data-modal=0])")
      .off("submit", modal._callbacks.forms)
      .on("submit", modal._callbacks.forms)


$(document).on "ready page:load modal:open", ->
  modal.setup()
