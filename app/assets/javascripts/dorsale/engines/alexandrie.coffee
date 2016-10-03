window.xhr2_available = ->
  !!window.ProgressEvent && !!window.FormData

window.alexandrie =
  enable_xhr_upload: true

  load: ->
    $("#dorsale-attachments").map ->
      container = $(this)
      url       = this.dataset.url

      $.ajax
        url: url
        success: (data) ->
          container.html(data)
          setupUploadInputs(container)
          alexandrie.setup()

  reload: ->
    alexandrie.load()

  setup: ->
    alexandrie.setupForms()
    alexandrie.setupFormsProgress()
    alexandrie.setupEditButtons()
    alexandrie.setupDeleteButtons()

  setupForms: ->
    $("#dorsale-attachments form").on("ajax:success", alexandrie.reload)

  setupEditButtons: ->
    $("#dorsale-attachments [href$=edit]").click ->
      container = $("#dorsale-attachments")
      url       = this.href

      $.ajax
        url: url
        success: (data) ->
          container.html(data)
          setupUploadInputs(container)
          alexandrie.setup()

      return false

  setupDeleteButtons: ->
    $("#dorsale-attachments [data-method=delete]").map ->
      $(this).on("ajax:success", alexandrie.reload)

  setupFormsProgress: ->
    return unless xhr2_available()
    return unless alexandrie.enable_xhr_upload

    # Ignore progress if no file input
    return unless $("#dorsale-attachments form input[type=file]").length

    $("#dorsale-attachments form").submit ->
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
        alexandrie.reload()

      xhr.open("POST", this.action, true)
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest")
      xhr.send(data)

      return false
