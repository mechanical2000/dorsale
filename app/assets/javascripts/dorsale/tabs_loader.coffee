$(document).on "ready page:load", ->
  if window.location.hash
    activeTab = $('[href="' + window.location.hash + '"]')
    activeTab && activeTab.tab('show')

  $('.nav-tabs a').on 'click', (e) ->
    window.location.hash = e.target.hash
