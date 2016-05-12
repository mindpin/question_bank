@WareQuestionModal = React.createClass
  getInitialState: ->
    questions: null

  render: ->
    ware = @props.ware

    {
      TextInputField
      TextAreaField
      Submit
    } = DataForm

    layout =
      label_width: '60px'

    form = 
      <div className='data-form-c'>
        <h4 className='ui header'>提一个问题：</h4>
        <DataForm.Form ref='form' onSubmit={@submit}>
          <TextInputField {...layout} label='问题：' name='title' required />
          <TextAreaField {...layout} label='描述：' name='content' rows={5} required />
          <Submit {...layout} text='确定提问' />
        </DataForm.Form>
      </div>

    <div className='ware-question-modal'>
      {
        if @state.questions == null
          <div className='ui segment basic'>
          <div className="ui active inverted dimmer">
            <div className="ui text loader">正在加载</div>
          </div>
          </div>

        else 
          <div>
          {
            if @state.questions.length is 0
              <div>还没有人提问</div>
            else
              for question in @state.questions
                <div key={question.id} className='question'>
                  <div>
                    <a href='javascript:;'>
                      <i className='icon question' />
                      {question.title}
                    </a>
                  </div>
                </div>
          }
          {form}
          </div>
      }
      <div className='ops' style={marginTop: '2rem'}>
        <a className='ui button' onClick={@close} style={marginLeft: '60'}>
          <i className='icon close' /> 关闭
        </a>
      </div>
    </div>

  submit: ->
    jQuery.ajax
      type: 'POST'
      url: '/questions'
      data:
        question: @refs.form.get_data()
        ware_id: @props.ware.id
    .done (res)=>
      questions = @state.questions
      questions.push res
      @setState questions: questions

      @refs.form.clear()

  close: ->
    @state.close()

  componentDidMount: ->
    jQuery.ajax
      url: '/questions/ware'
      data:
        ware_id: @props.ware.id
    .done (res)=>
      @setState questions: res.questions
      @state.refresh()