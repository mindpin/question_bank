@ManagerNewCoursePage = React.createClass
  render: ->
    <div className='manager-new-course-page'>
      <ManagerNewCoursePage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      getInitialState: ->
        errors: {}

      render: ->
        {
          TextInputField
          TextAreaField
          OneImageUploadField
          Submit
        } = DataForm

        layout =
          label_width: '100px'
          wrapper_width: '50%'

        <div className='ui segment'>
          <SimpleDataForm
            model='course'
            post={@props.data.create_course_url}
            done={@done}  
          >
            <TextInputField {...layout} label='课程名：' name='name' required />
            <TextAreaField {...layout} label='课程简介：' name='desc' rows={10} />
            <OneImageUploadField {...layout}  label='课程封面：' name='cover_file_entity_id' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (res)->
        location.href = res.jump_url