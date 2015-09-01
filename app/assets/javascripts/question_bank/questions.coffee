jQuery(document).on "ready page:load", ->
  jQuery('.form-question-single-choice').on 'click', '.add-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    next_choice_answer_index = jQuerychoice_answer_indexs.find('.radio:not(.hidden)').length
    dom = jQuerychoice_answer_indexs.find('.radio:first').clone()
    dom.removeClass('hidden')
    dom.find('input[name="question[choices][]"]').val("")
    dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
    jQuery(this).before(dom)

  jQuery('.form-question-single-choice').on 'click', '.delete-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    jQuerydelete_radio = jQuery(this).closest('.radio')
    delete_index = parseInt(jQuerydelete_radio.find('input:first').val())
    last_index   = jQuerychoice_answer_indexs.find('.radio:not(.hidden)').length - 1
    for index in [delete_index..last_index]
      jQueryradio = jQuerychoice_answer_indexs.find('.radio:not(.hidden)').eq(index)
      jQueryradio.find('input:first').val(index - 1)
    jQuerydelete_radio.remove()

  jQuery('.form-question-single-choice').on 'submit', 'form', (evt)->
    jQuerychoice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    jQuerychoice_answer_indexs.find('.radio.hidden').remove()

  jQuery('.form-question-multi-choice').on 'click', '.add-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    next_choice_answer_index = jQuerychoice_answer_indexs.find('.checkbox:not(.hidden)').length
    dom = jQuerychoice_answer_indexs.find('.checkbox:first').clone()
    dom.removeClass('hidden')
    dom.find('input[name="question[choices][]"]').val("")
    dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
    jQuery(this).before(dom)

  jQuery('.form-question-multi-choice').on 'click', '.delete-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    jQuerydelete_checkbox = jQuery(this).closest('.checkbox')
    delete_index = parseInt(jQuerydelete_checkbox.find('input:first').val())
    last_index   = jQuerychoice_answer_indexs.find('.checkbox:not(.hidden)').length - 1
    for index in [delete_index..last_index]
      jQuerycheckbox = jQuerychoice_answer_indexs.find('.checkbox:not(.hidden)').eq(index)
      jQuerycheckbox.find('input:first').val(index - 1)

    jQuerydelete_checkbox.remove()

  jQuery('.form-question-multi-choice').on 'submit', 'form', (evt)->
    jQuerychoice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    jQuerychoice_answer_indexs.find('.checkbox.hidden').remove()

  jQuery('.form-question-mapping').on 'click','.delete',->
    position_atr = jQuery(this).closest('.item').find('input').attr('name');
    zhengze = new RegExp(/[0-9]+/)
    position = zhengze.exec(position_atr)
    item_length = jQuery(".form-question-mapping .item").length
    for x in [position...item_length]
      q = x-1
      jQuery(".form-question-mapping .item").eq(x).find("input").attr('name','question[mapping_answer]['+q+'][]')
    if item_length==1
      jQuery(".form-question-mapping .item:first input").val("")
      fuben = jQuery(".form-question-mapping .item:first").clone()
      jQuery(".form-question-mapping .item:first").after(fuben)
      jQuery(".form-question-mapping .item:last").addClass('hidden')
      jQuery(".form-question-mapping .item:last input").attr('name','question[mapping_answer][0][]')
    jQuery(this).closest('.item').remove();

  jQuery('.form-question-mapping').on 'click','.append',->
    count_hidden = jQuery('.option-key-field .hidden').length
    if count_hidden==1
      jQuery('.option-key-field .hidden input').attr('name','question[mapping_answer][0][]')
      jQuery('.option-key-field .hidden' ).removeClass('hidden')
    else
      shuzi = jQuery('.form-question-mapping .item:last input ').attr('name');
      zhengze = new RegExp(/[0-9]+/)
      shuzi = zhengze.exec(shuzi)
      shuzi = Number(shuzi)+1
      atr = jQuery(this).closest('.form-question-mapping').find(".item:last").clone()
      jQuery(this).closest('.add-items').before(atr);
      jQuery(this).closest('.form-question-mapping').find(".item:last").removeClass('hidden')
      jQuery(this).closest('.form-question-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
      jQuery(this).closest('.form-question-mapping').find(".item:last input").val('')

  jQuery('.form-question-mapping').on 'submit','form',->
    jQuery('.form-question-mapping .answer .hidden').remove()

  jQuery('.form-question-fill').on 'click','.insert',->
    str = jQuery('.form-question-fill').find("[name='question[content]']").val();
    str = str+" ___ "
    jQuery('.form-question-fill').find("[name='question[content]']").val(str);

  jQuery('.form-question-fill').on 'click','.delete ',->
    count = jQuery('.form-question-fill .answer').length
    if count ==1
      fuben = jQuery(this).closest(".answer").clone()
      fuben.addClass('hidden')
      fuben.find('input').attr('value','')
      fuben.find('input').val('')
      jQuery(this).closest(".answer").before(fuben)
    jQuery(this).closest(".answer").remove()

  jQuery('.form-question-fill').on 'click','.append',->
    blank = jQuery('.form-question-fill .answer:last').clone();
    blank.removeClass("hidden")
    blank.find("input").val("")
    jQuery('.form-question-fill .answer:last').after(blank)


  jQuery('.form-question-fill').on 'submit','form',->
    if jQuery('.form-question-fill .answer:not(.hidden)').length > 0
      jQuery('.form-question-fill .answer.hidden').remove()


