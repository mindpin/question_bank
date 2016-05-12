@ManagerCoursesPublishPage = React.createClass
  getInitialState: ->
    prepared_courses: @props.data.prepared_courses
    paginate: @props.data.paginate
  render: ->
    <div className='manager-courses-publish-page'>
    {
      if @state.prepared_courses.length is 0
        data =
          header: '课程发布'
          desc: '目前没有待发布或撤回的课程'
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerCoursesPublishPage.Table {...@state} parent={@}/>
        </div>
    }
    </div>

  publish_response: (course)->
    prepared_courses = Immutable.fromJS @state.prepared_courses
    prepared_courses = prepared_courses.map (x)->
      if x.get('id') == course.id
        x = x.set('published', true)
      x
    @setState prepared_courses: prepared_courses.toJS()

  recall_response: (course)->
    prepared_courses = Immutable.fromJS @state.prepared_courses
    prepared_courses = prepared_courses.map (x)->
      if x.get('id') == course.id
        x = x.set('published', false)
      x
    @setState prepared_courses: prepared_courses.toJS()

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '课程名称'
            instructor: '讲师'
            updated_at: '更新时间'
            published: '已发布'
            actions: '操作'
          data_set: @props.prepared_courses.map (x)=>
            id: x.id
            name: x.name
            instructor: x.instructor
            updated_at: x.updated_at
            published:
              if x.published
                <i className='icon check green' />
              else
                <span> - </span>
            actions:
              <div>
                <a className='ui button mini basic' href='javascript:;'>
                  <i className='icon eye' />
                  预览
                </a>
                {
                  unless x.published
                    <a className='ui button mini green basic' href='javascript:;' onClick={@confirm_publish(x)}>
                      <i className='icon send' /> 发布
                    </a>
                  else
                    <a className='ui button mini basic' href='javascript:;' onClick={@confirm_recall(x)}>
                      <i className='icon arrow left' /> 撤回
                    </a>
                }
              </div>

          th_classes: 
            published: 'collapsing'
          td_classes: 
            instructor: 'collapsing'
            updated_at: 'collapsing'
            actions: 'collapsing'
          paginate: @props.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='开课管理' />
        </div>

      confirm_publish: (course)->
        (evt)=>
          unless course.publish_url?
            console.warn "没有设置 course.publish_url"
            return

          jQuery.modal_confirm
            text: """
              <div>
                <div>确定要发布这个课程吗？</div>
                <strong>#{course.name}</strong>
              </div>
            """
            yes: =>
              jQuery.ajax
                url: course.publish_url
                type: 'POST'
              .done (res)=>
                @props.parent.publish_response(course)

      confirm_recall: (course)->
        (evt)=>
          unless course.recall_url?
            console.warn "没有设置 course.recall_url"
            return

          jQuery.modal_confirm
            text: """
              <div>
                <div>要撤回这个课程吗？</div>
                <strong>#{course.name}</strong>
              </div>
            """
            yes: =>
              jQuery.ajax
                url: course.recall_url
                type: 'DELETE'
              .done (res)=>
                @props.parent.recall_response(course)