jQuery(document).on "ready page:load", ->
  jQuery(document).on 'click', '.form-question-single-choice .add-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    next_choice_answer_index = jQuerychoice_answer_indexs.find('.radio:not(.hidden)').length
    dom = jQuerychoice_answer_indexs.find('.radio:first').clone()
    dom.removeClass('hidden')
    dom.find('input[name="question[choices][]"]').val("")
    dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
    jQuery(this).before(dom)

  jQuery(document).on 'click', '.form-question-single-choice .delete-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')

    jQuerydelete_radio = jQuery(this).closest('.radio')
    delete_index = parseInt(jQuerydelete_radio.find('input:first').val())
    last_index   = jQuerychoice_answer_indexs.find('.radio:not(.hidden)').length - 1
    for index in [delete_index..last_index]
      jQueryradio = jQuerychoice_answer_indexs.find('.radio:not(.hidden)').eq(index)
      jQueryradio.find('input:first').val(index - 1)

    jQuerydelete_radio.remove()


  jQuery(document).on 'submit', '.form-question-single-choice form', (evt)->
    jQuerychoice_answer_indexs = jQuery('.form-question-single-choice .question_choice_answer_indexs')
    jQuerychoice_answer_indexs.find('.radio.hidden').remove()


  jQuery(document).on 'click', '.form-question-multi-choice .add-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    next_choice_answer_index = jQuerychoice_answer_indexs.find('.checkbox:not(.hidden)').length
    dom = jQuerychoice_answer_indexs.find('.checkbox:first').clone()
    dom.removeClass('hidden')
    dom.find('input[name="question[choices][]"]').val("")
    dom.find('input[name="question[choice_answer_indexs][]"]').val(next_choice_answer_index)
    jQuery(this).before(dom)

  jQuery(document).on 'click', '.form-question-multi-choice .delete-choice', ->
    jQuerychoice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')

    jQuerydelete_checkbox = jQuery(this).closest('.checkbox')
    delete_index = parseInt(jQuerydelete_checkbox.find('input:first').val())
    last_index   = jQuerychoice_answer_indexs.find('.checkbox:not(.hidden)').length - 1
    for index in [delete_index..last_index]
      jQuerycheckbox = jQuerychoice_answer_indexs.find('.checkbox:not(.hidden)').eq(index)
      jQuerycheckbox.find('input:first').val(index - 1)

    jQuerydelete_checkbox.remove()

  jQuery(document).on 'submit', '.form-question-multi-choice form', (evt)->
    jQuerychoice_answer_indexs = jQuery('.form-question-multi-choice .question_choice_answer_indexs')
    jQuerychoice_answer_indexs.find('.checkbox.hidden').remove()

  jQuery(document).on 'click','.page-new-question-mapping .delete',->
    position_atr = jQuery(this).closest('.item').find('input').attr('name');
    zhengze = new RegExp(/[0-9]+/)
    position = zhengze.exec(position_atr)
    item_length = jQuery(".page-new-question-mapping .item").length
    for x in [position...item_length]
      q = x-1
      jQuery(".page-new-question-mapping .item").eq(x).find("input").attr('name','question[mapping_answer]['+q+'][]')
    if item_length==1
      jQuery(".page-new-question-mapping .item:first input").val("")
      fuben = jQuery(".page-new-question-mapping .item:first").clone()
      jQuery(".page-new-question-mapping .item:first").after(fuben)
      jQuery(".page-new-question-mapping .item:last").addClass('hidden')
    jQuery(this).closest('.item').remove();
  jQuery(document).on 'click','.page-new-question-mapping .append',->
    count_hidden = jQuery('.option-key-field .hidden').length
    if count_hidden==1
      jQuery('.option-key-field .hidden input').attr('name','question[mapping_answer][0][]')
      jQuery('.option-key-field .hidden' ).removeClass('hidden')
    else
      shuzi = jQuery('.page-new-question-mapping .item:last input ').attr('name');
      zhengze = new RegExp(/[0-9]+/)
      shuzi = zhengze.exec(shuzi)
      shuzi = Number(shuzi)+1
      atr = jQuery(this).closest('.page-new-question-mapping').find(".item:last").clone()
      jQuery(this).closest('.add-items').before(atr);
      jQuery(this).closest('.page-new-question-mapping').find(".item:last").removeClass('hidden')
      jQuery(this).closest('.page-new-question-mapping').find(".item:last input").attr('name','question[mapping_answer]['+shuzi+'][]')
      jQuery(this).closest('.page-new-question-mapping').find(".item:last input").val('')
  jQuery(document).on 'submit','.page-new-question-mapping',->
    jQuery('.page-new-question-mapping .answer .hidden').remove()

  jQuery(document).on 'click','.form-question-fill .insert',->
    str = jQuery('.form-question-fill').find("[name='question[content]']").val();
    str = str+" ___ "
    jQuery('.form-question-fill').find("[name='question[content]']").val(str);

  jQuery(document).on 'click','.page-new-question-fill .delete ',->
    count = jQuery('.page-new-question-fill .answer').length
    if count ==1
      fuben = jQuery(this).closest(".answer").clone()
      fuben.addClass('hidden')
      jQuery(this).closest(".answer").before(fuben)
    jQuery(this).closest(".answer").remove()

  jQuery(document).on 'click','.form-question-fill .append',->
    blank = jQuery('.form-question-fill .answer:last').clone();
    blank.removeClass("hidden")
    blank.find("input").val("")
    jQuery('.form-question-fill .answer:last').after(blank)

  jQuery(document).on 'submit','.page-new-question-fill ',->
    jQuery('.page-new-question-fill .answer.hidden').remove()


