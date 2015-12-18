class NewTestPaper
  constructor: (@$el) ->
    @is_edit = @$el.hasClass 'page-edit-test_paper'

    @$modal_random_questions   = @$el.find '#modal-random-questions'
    @$modal_questions_selector = @$el.find '#modal-questions-selector'

    @$template_question          = @$el.find '.template.question'
    @$template_section           = @$el.find '.template.section'
    @$template_selector_question = @$el.find '.template.selector_question'

    @$new_test_paper = @$el.find '#new_test_paper'

    @set_scores()
    @bind_section_event()
    @_bind()

  bind_section_event: ->
    @bind_add_section_event()
    @bind_section_up_event()
    @bind_section_down_event()
    @bind_section_destroy_event()

  bind_add_section_event: ->
    @$el.on 'click', '.btn-new-section', =>
      section_count = @$el.find('.sections .section').length

      section_html  = @$template_section.clone().html()
      section_html  = section_html.replace /{{section_index_plus}}/g , section_count + 1
      section_html  = section_html.replace /{{section_index}}/g , section_count

      $template = jQuery(section_html).removeClass 'hidden'
      @$el.find('.sections').append($template)

  bind_section_up_event: ->
    @$el.on 'click', '.section_move_up', (evt)=>
      $target   = jQuery evt.target
      $section  = $target.closest '.section'
      $sections = $section.closest('.sections').find('.section:not(.hidden)')
      index = $sections.index $section
      $prev = jQuery($sections.get(index - 1))

      if $prev.length == 1

        # 移动前保存数据
        @save_section_data($section)
        @save_section_data($prev)

        $section.insertBefore $prev
        # position 需要做调整
        @reset_section_positions()
        @reset_section_title()

        # 移动后恢复数据
        @load_section_data($section)
        @load_section_data($prev)


  bind_section_down_event: ->
    @$el.on 'click', '.section_move_down', (evt)=>
      $target   = jQuery evt.target
      $section  = $target.closest '.section'
      $sections = $section.closest('.sections').find('.section:not(.hidden)')
      index = $sections.index $section
      $next = jQuery($sections.get(index + 1))

      if $next.length == 1

        # 移动前保存数据
        @save_section_data($section)
        @save_section_data($prev)

        $section.insertAfter $next
        # position 需要做调整
        @reset_section_positions()
        @reset_section_title()

        # 移动后恢复数据
        @load_section_data($section)
        @load_section_data($prev)

  bind_section_destroy_event: ->
    @$el.on 'click', '.section_destroy', (evt)=>
      $target  = jQuery evt.target
      $section = $target.closest '.section'

      if @is_edit
        # 修改时， 设置_destroy 而非单纯移除
        $section.addClass 'hidden'
        $section.find("input.section_destroy[type='hidden']").val('true')
      else
        # 新建时，直接删除
        $section.remove()

      # 删除后，还要重新计算大题数
      @reset_section_title()
      @set_scores()

  _bind: ->
    that = this

    # section 大题操作
    @$el.on 'click', '.btn-random', ->
      $this = jQuery(this)
      that.$control_section = $this.closest(".section")

      # init
      that.$modal_random_questions.find('#input_random_count').val(5)
      that.$modal_random_questions.modal('show')

    @$el.on 'click', '.btn-choose', ->
      $this = jQuery(this)
      that.$control_section = $this.parent().parent().parent().parent()

      that.get_questions
        $section: that.$control_section

      that.$modal_questions_selector.modal('show')


    @$el.on 'change', '.min_level', ->
      $this = jQuery(this)
      min = Number $this.val()
      $section = $this.parent().parent().parent().parent()
      $max = $section.find('.max_level')
      $max.children().each (index)->
        if index < min - 1
          jQuery(this).addClass('disabled').prop('disabled', true)
        else
          jQuery(this).removeClass('disabled').prop('disabled', false)

      $max.find(':not(.disabled)').first().prop('selected', true) if $max.find(':selected').hasClass('disabled')

    @$el.on 'change', '.max_level', ->
      $this = jQuery(this)
      max = Number $this.val()
      $section = $this.parent().parent().parent().parent()
      $min = $section.find('.min_level')
      $min.children().each (index)->
        if index >= max
          jQuery(this).addClass('disabled').prop('disabled', true)
        else
          jQuery(this).removeClass('disabled').prop('disabled', false)
      $min.find(':not(.disabled)').first().prop('selected', true) if $min.find(':selected').hasClass('disabled')

    # question 选题操作
    @$el.on 'click', '.question_move_up', ->
      $this = jQuery(this)
      $question_li = $this.closest("li")
      $questions = $question_li.parent().find('li')
      index = $questions.index($question)

      if that.is_edit
        $ids_in_value = $this.parent().parent().parent().find(".test_paper_sections_question_ids_str input")
        questions_atr = $ids_in_value.attr("value")
        console.log(questions_atr)
        if index > 0
          question_ids_array = questions_atr.split(',')
          this_ele = question_ids_array[index]
          pre_ele = question_ids_array[index-1]
          question_ids_array[index] = pre_ele
          question_ids_array[index-1] = this_ele
          console.log(question_ids_array.join(","))
          $ids_in_value.attr("value",question_ids_array.join(","))

      if index > 0
        $prev = jQuery($questions.get(index - 1))
        $question.insertBefore($prev) if $prev and !$prev.hasClass('empty')
        that.reset_question_positions($question)


    @$el.on 'click', '.question_move_down', ->
      $this = jQuery(this)
      $question = $this.parent().parent()
      $questions = $question.parent().find('li')
      index = $questions.index($question)
      questions_length_in_section = $questions.length
      $next = jQuery($questions.get(index + 1))

      if that.is_edit
        $ids_in_value = $this.parent().parent().parent().find(".test_paper_sections_question_ids_str input")
        questions_atr = $ids_in_value.attr("value")
        console.log(questions_atr)
        if index < questions_length_in_section-1
          question_ids_array = questions_atr.split(',')
          this_ele = question_ids_array[index]
          next_ele = question_ids_array[index+1]
          question_ids_array[index] = next_ele
          question_ids_array[index+1] = this_ele
          console.log(question_ids_array.join(","))
          $ids_in_value.attr("value",question_ids_array.join(","))

      if $next and !$next.hasClass('empty')
        $question.insertAfter($next)
        that.reset_question_positions($question)

    @$el.on 'click', '.question_destroy', ->
      $this = jQuery(this)
      $question = $this.parent().parent()
      $questions = $question.parent().find('li')
      index = $questions.index($question)
      if that.is_edit
        $ids_in_value = $this.parent().parent().parent().find(".test_paper_sections_question_ids_str input")
        questions_atr = $ids_in_value.attr("value")
        console.log(questions_atr)
        question_ids_array = questions_atr.split(',')
        question_ids_array.splice(index,1)
        console.log(question_ids_array)
        $ids_in_value.attr("value",question_ids_array.join(","))
        $question.remove()
      else
        # 新建时，直接删除
        $question.remove()
      that.set_scores()

    # modal 弹窗操作
    @$modal_random_questions.on 'click', '.button-random-questions', =>
      random_count = Number @$modal_random_questions.find('#input_random_count').val()
      # todo 读取已选题目
      if random_count == NaN or random_count == 0
        alert('选择考题数量不为数字，或者不大于0')
      else
        # todo 传入已选题目, 不重复
        @get_random_questions
          $section: @$control_section
          random_count: random_count

    @$modal_questions_selector.on 'click', '.button-questions-selector', =>
      $question = @$template_question.clone()
      $section_questions = @$control_section.find('.section_questions')
      section_index = @$el.find('.sections .section').index(@$control_section)

      @$modal_questions_selector.find(':checked').each (index)->
        $this = jQuery(this)
        $label_question = $this.parent()
        question = $label_question.find('span').html()

        # haml 不知道为什么会转为-
        #question_id = $label_question.data('question_id')
        question_id = $label_question.data('question-id')

        str_template = $question.html().replace /{{content}}/g , question

        str_template = str_template.replace /{{section_index}}/g , section_index
        str_template = str_template.replace /{{question_index}}/g , index

        str_template = str_template.replace /{{question_id}}/g , question_id
        str_template = str_template.replace /{{position}}/g , index

        $template = jQuery(str_template).removeClass('hidden')
        $section_questions.append($template)

      @set_scores()
      @$modal_questions_selector.modal('hide')


    @$el.on 'blur', '#test_paper_score, .section_score', =>
      @set_scores()

    @$el.on 'click', '.btn-submit', =>
      if @total == NaN or @total <= 0 or @surplus != 0
        alert('未分配分数不为0')
        return false
      @$new_test_paper.prop('action', '/test_papers').prop('target', '')

    @$el.on 'click', '.btn-preview', =>
      if @total == NaN or @total <= 0 or @surplus != 0
        alert('未分配分数不为0')
        return false
      @$new_test_paper.prop('action', '/test_papers/preview').prop('target', '_blank').submit()

  set_scores: ->
    @scores = Number @$el.find('#test_paper_score').val()
    @total = @calculate_total()
    @surplus = @scores - @total
    if @scores != NaN and @scores > 0
      @$el.find('.scores').html(@scores)
      @$el.find('.total').html(@total)
      @$el.find('.surplus').html(@surplus)
    else
      @$el.find('.scores').html('请先设置试卷总分')
      @$el.find('.total').html('请先设置试卷总分')
      @$el.find('.surplus').html('请先设置试卷总分')

  calculate_total: ->
    total = 0
    @$el.find('.sections .section:not(.hidden)').each ->
      $section = jQuery(this)
      score = Number $section.find('.section_score').val()
      if score != NaN and score > 0
        total += score * $section.find('ul li:not(.hidden)').length
    total

  get_questions: (params) ->
    {$section} = params
    kind = $section.find('.kind').val()
    min_level = $section.find('.min_level').val()
    max_level = $section.find('.max_level').val()
    $question_selector = @$el.find('.question_selector')
    $question_selector.html('读取中...')
    jQuery.ajax
      url: '/questions/search.json'
      method: 'GET'
      data:
        min_level: min_level
        max_level: max_level
        kind: kind
        type: 'select'
      success: (res) =>
        $question_selector.html('')
        for question, index in res
          str_template = @$template_selector_question.html()

          str_template = str_template.replace /{{content}}/g , question.content

          str_template = str_template.replace /{{question_id}}/g , question.id

          $template = jQuery(str_template).removeClass('hidden')
          $question_selector.append($template)

  get_random_questions: (params) ->
    {$section, random_count} = params
    # ajax get_random_questions
    kind = $section.find('.kind').val()
    min_level = $section.find('.min_level').val()
    max_level = $section.find('.max_level').val()
    jQuery.ajax
      url: '/questions/search.json'
      method: 'GET'
      data:
        min_level: min_level
        max_level: max_level
        kind: kind
        type: 'random'
        per: random_count
      success: (res) =>
        section_index = @$el.find('.sections .section').index($section)
        $section_questions = $section.find('.section_questions')

        $input = $section.find("input[name='test_paper[sections_attributes][#{section_index}][question_ids_str]']")
        question_ids = jQuery.map res, (question, index)->
          question.id
        question_ids_str = question_ids.join ","
        $input.val question_ids_str

        for question, index in res
          str_template = @$template_question.html()

          str_template = str_template.replace /{{content}}/g , question.content

          str_template = str_template.replace /{{question_id}}/g , question.id

          $template = jQuery(str_template).removeClass('hidden')
          $section_questions.append($template)
          @set_scores()
          @$modal_random_questions.modal('hide')


  reset_section_title: ->
    @$el.find('.sections .section:not(.hidden)').each (index, $section)->
      jQuery($section).find('h3').html("第#{index+1}大题")

  reset_question_positions: ($question)->
      $question.parent().find('li').each (index)->
        $this1 = jQuery(this)
        $this1.html $this1.html().replace(/(section_questions_attributes\]\[)\d+(\])/g , "$1#{index}$2")
        $this1.find('.question_position').val(index)

  reset_section_positions: ()->
    that = this
    @$el.find('.sections .section').each (index, $section)->
      $section = jQuery($section)
      # 替换地下所有的[x]
      $section.html $section.html().replace(/(sections_attributes\]\[)\d+\]/g, "$1#{index}]")
      $section.find('.section_position').val(index)

      if that.is_edit
        origin_index = $section.data('origin-index')
        $id = $section.parent().find("#test_paper_sections_attributes_#{origin_index}_id")
        $id.prop 'name', $id.prop('name').replace(/(sections_attributes\]\[)\d+\]/g, "$1#{index}]") if $id.length > 0

  save_section_data: ($section) ->
    if $section.length > 0
      $section.data 'section-kind', $section.find('.kind.form-control').val()
      $section.data 'section-max-level', $section.find('.max_level.form-control').val()
      $section.data 'section-min-level', $section.find('.min_level.form-control').val()
      $section.data 'section-score', $section.find('.section_score.form-control').val()

  load_section_data: ($section) ->
    if $section.length > 0
      $section.find('.kind.form-control').val $section.data('section-kind')
      $section.find('.max_level.form-control').val $section.data('section-max-level')
      $section.find('.min_level.form-control').val $section.data('section-min-level')
      $section.find('.section_score.form-control').val $section.data('section-score')

jQuery(document).on 'ready page:load', ->
  if jQuery('.form-test_paper').length > 0
    new NewTestPaper jQuery('.form-test_paper')
