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
          alexandrie.setupCreateForm()
          alexandrie.setupEditButtons()
          alexandrie.setupDeleteButtons()

  reload: ->
    alexandrie.load()

  setupCreateForm: ->
    return unless xhr2_available()
    return unless alexandrie.enable_xhr_upload

    $("#new_attachment").submit ->
      form = $(this)
      xhr  = new XMLHttpRequest()
      data = new FormData(this)

      data.append "attachment[attachment_type_id]", $("#attachment_attachment_type_id").val()

      xhr.upload.addEventListener "progress", (e) ->
        return unless e.lengthComputable

        percentComplete = Math.round(e.loaded * 100 / e.total)
        percentComplete = 1  if percentComplete == 0
        percentComplete = 99 if percentComplete == 100

        bar = $("#new_attachment_progress .progress-bar")
        bar.html percentComplete+"%"
        bar.css  "width":         percentComplete+"%"
        bar.attr "aria-valuenow": percentComplete

      xhr.addEventListener "load", (e) ->
        alexandrie.reload()

      xhr.open("POST", this.action, true)
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest")
      xhr.send(data)

      return false

  setupEditForm: ->
    $("#edit_attachment").on("ajax:success", alexandrie.reload)

    $("#edit_attachment").on "ajax:beforeSend", (event, xhr, settings) ->
      settings.data = $("#edit_attachment_tr :input").serialize()
      true

  setupEditButtons: ->
    $("#dorsale-attachments [href$=edit]").click ->
      container = $(this).parents(".attachment")
      url       = this.href

      $.ajax
        url: url
        success: (data) ->
          container.replaceWith(data)
          alexandrie.setupEditForm()

      return false

  setupDeleteButtons: ->
    $("#dorsale-attachments [data-method=delete]").map ->
      $(this).on("ajax:success", alexandrie.reload)
