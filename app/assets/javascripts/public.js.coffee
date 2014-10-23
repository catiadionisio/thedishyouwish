$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    placeholder_text_multiple: 'Pesquisar ingredientes'
    no_results_text: 'Não existem resultados'
    width: 'auto'

$ ->
  # enable chosen js
  $('.chosen-select2').chosen
    allow_single_deselect: true
    placeholder_text_single: "Categorias"
    no_results_text: 'Não existem resultados'
    disable_search_threshold: 10
    width: 'auto'

$ ->
  # enable chosen js
  $('.chosen-select3').chosen
    placeholder_text_single: 'Ingredientes'
    no_results_text: 'Não existem resultados'
    width: 'auto'