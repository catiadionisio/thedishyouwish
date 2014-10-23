#= require active_admin/base

//= require chosen.jquery


$ ->
  # enable chosen js
  $('.chosen-select').chosen
    no_results_text: 'No results matched'
    width: '80%'

$ ->
  # enable chosen js
  $('.chosen-select2').chosen
    no_results_text: 'No results matched'
    width: '100%'

$(document).on 'has_many_add:after', '.has_many_container', (e, fieldset)->
  fieldset.find('select').chosen
    width: '80%'