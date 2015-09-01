class NewTestPaper
  constructor: (@$el, params) ->
    console.log 'NewTestPaper'
    @_init()
  
  _init: ->
    @$modal_random_questions = @$el.find('#modal-random-questions')
    @$modal_questions_selector = @$el.find('#modal-questions-selector')
    @_bind()

  _bind: ->
    that = this
    @$el.on 'click', '.btn-random', ->
      $this = jQuery(this)
      that.$modal_random_questions.modal('show')

    @$el.on 'click', '.btn-choose', ->
      $this = jQuery(this)
      that.$modal_questions_selector.modal('show')
      

jQuery(document).on 'ready page:load', ->
  new NewTestPaper(jQuery('.page-new-test_paper'), {}) if jQuery('.page-new-test_paper').length > 0
