# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
jQuery ->
  $('#course_tag_tokens').tokenInput '/tags.json'
  prePopulate: $('#course_tag_tokens').data('load')
