window.alexandrie =
  loadList: ->
    $("#dorsale-attachments").map ->
      $.ajax
        url: this.dataset.url
        success: (data) ->
          alexandrie.replaceHTML(data)

  replaceHTML: (html) ->
    $container =  $("#dorsale-attachments")
    $container.html(html)
    setupUploadInputs($container)

  setup: ->
    $(document).on "ajax:success", "#dorsale-attachments *", (e, data) ->
      alexandrie.replaceHTML(data)

    $(document).on "submit", "#dorsale-attachments form", ->
      # Ignore progress if no file input
      return unless $(this).find("input[type=file]").length

      form = $(this)
      xhr  = new XMLHttpRequest()
      data = new FormData(this)

      xhr.upload.addEventListener "progress", (e) ->
        return unless e.lengthComputable

        percentComplete = Math.round(e.loaded * 100 / e.total)
        percentComplete = 1  if percentComplete == 0
        percentComplete = 99 if percentComplete == 100

        # Get edit progress bar if available, new progress bar otherwise
        bar = $("#edit_attachment_tr + tr .progress-bar").first()
        bar = $("#new_attachment_tr + tr .progress-bar").first() if bar.length == 0
        bar.html percentComplete+"%"
        bar.css  "width":         percentComplete+"%"
        bar.attr "aria-valuenow": percentComplete

      xhr.addEventListener "load", (e) ->
        alexandrie.replaceHTML(e.target.responseText)

      xhr.open("POST", this.action, true)
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest")
      xhr.send(data)

      return false

alexandrie.setup()
