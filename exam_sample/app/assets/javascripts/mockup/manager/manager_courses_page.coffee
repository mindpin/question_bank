@ManagerCoursesPage = React.createClass
  render: ->
    <div className='manager-courses-page'>
    {
      if @props.data.courses.length is 0
        data =
          header: '开课管理'
          desc: '还没有创建任何课程'
          init_action: <ManagerCoursesPage.CreateBtn data={@props.data} />
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerCoursesPage.CreateBtn data={@props.data} />
          <ManagerCoursesPage.Table data={@props.data} />
        </div>
    }
    </div>

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href={@props.data.new_course_url}>
          <i className='icon plus' />
          创建课程
        </a>

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '课程名称'
            instructor: '讲师'
            updated_at: '更新时间'
            actions: '操作'
          data_set: @props.data.courses.map (x)->
            {
              id: x.id
              name: x.name
              instructor: x.instructor
              updated_at: x.updated_at
              actions: 
                <a className='ui button mini blue basic' href={x.manager_contents_url}>
                  <i className='icon pencil' />
                  内容编排
                </a>
            }

          filters: 
            subjects:
              text: '课程分类' 
              values: @props.data.filter_subjects.map (x)-> x.name

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='开课管理' />
        </div>