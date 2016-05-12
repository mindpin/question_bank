@ManagerCsubjectsPage = React.createClass
  getInitialState: ->
    subjects = @props.data.subjects || []
    subjects: subjects

  render: ->
    <div className='manager-csubjects-page'>
    {
      if @state.subjects.length is 0
        data =
          header: '课程分类'
          desc: '还没有创建任何课程分类'
          init_action: 
            <ManagerCsubjectsPage.CreateBtn />
        <ManagerFuncNotReady data={data} />
      else
        tdp = new TreeArrayParser @state.subjects
        flatten_subjects = tdp.get_depth_first_array()

        <div>
          <ManagerCsubjectsPage.Table flatten_subjects={flatten_subjects} />
          <div className='ui segment btns'>
            <ManagerCsubjectsPage.CreateBtn />
          </div>
        </div>
    }
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @, @state.subjects

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href='javascript:;' onClick={@create_root_subject}>
          <i className='icon plus' /> 增加新分类
        </a>

      create_root_subject: ->
        Actions.add_subject
          name: "新分类 #{new Date().getTime()}"

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '分类名称'
            ops: ''
            slug: '链接名称'
            courses_count: '课程数'
          data_set: @props.flatten_subjects.map (x)=> 
            {
              id: x.id
              name:
                <ManagerCsubjectsPage.TreeItemTD data={x} />
              slug:
                <InlineInputEdit value={x.slug} on_submit={@update_slug(x)} />
              courses_count: x.courses_count
              ops:
                <div>
                  <a href='javascript:;' className='ui green basic button mini' onClick={@create_subject_on(x)}>
                    <i className='icon plus' /> 增加子级
                  </a>
                  <a href='javascript:;' className='ui red basic button mini' onClick={@confirm_remove(x)}>
                    <i className='icon remove' /> 删除
                  </a>
                </div>
            }
          th_classes: {
            courses_count: 'collapsing'
          }
          td_classes: {
            slug: 'slug'
            actions: 'collapsing'
            ops: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='课程分类' />
        </div>

      update_slug: (subject)->
        (slug)->
          Actions.update_subject subject, {
            slug: slug
          }

      create_subject_on: (subject)->
        ->
          Actions.add_subject_on subject, {
            name: "新分类 #{new Date().getTime()}"
          }

      confirm_remove: (subject)->
        ->
          jQuery.modal_confirm
            text: '确定要删除吗？'
            yes: =>
              Actions.remove_subject subject


    TreeItemTD: React.createClass
      render: ->
        x = @props.data

        <div className='tree-item'>
          <div className='tree-pds'>
          {
            for flag, idx in x._depth_array
              klass = new ClassName
                'pd': true
                'flag': flag 

              <div key={idx} className={klass}></div>
          }
          </div>
          <div className='item-name'>
            <InlineInputEdit value={x.name} on_submit={@update_name(x)} />
          </div>
        </div>

      update_name: (subject)->
        (name)->
          Actions.update_subject subject, {
            name: name
          }



# ----------------------

class DataStore
  constructor: (@page, subjects)->
    @subjects = Immutable.fromJS subjects
    @create_subject_url = @page.props.data.create_subject_url

  create_subject: (data)->
    if not @create_subject_url?
      console.warn '没有传入 create_subject_url 接口'
      return

    jQuery.ajax
      type: 'POST'
      url: @create_subject_url
      data: 
        subject: data
    .done (res)=>
      if res.id?
        @_push_data_into_tree res
      else
        console.warn '创建课程分类请求没有返回正确数据'

    .fail (res)->
      console.log res.responseJSON

  _push_data_into_tree: (res)->
    new_subject = Immutable.fromJS res
    subjects = @subjects.push new_subject
    @reload_page subjects

  delete_subject: (subject)->
    if not subject.delete_url?
      console.warn '没有传入 subject.delete_url 接口'
      return

    jQuery.ajax
      type: 'DELETE'
      url: subject.delete_url
    .done (res)=>
      subjects = @_delete_data_from_tree @subjects, subject
      @reload_page subjects
    .fail (res)->
      console.log res.responseJSON

  _delete_data_from_tree: (subjects, subject)->
    children = subjects.filter (r)->
      r.get('parent_id') == subject.id

    children.forEach (c)=>
      subjects = @_delete_data_from_tree subjects, c.toJS()

    subjects = subjects.filter (x)->
      x.get('id') != subject.id

  update_subject: (subject, data)->
    if not subject.update_url?
      console.warn '没有传入 subject.update_url 接口'
      return

    jQuery.ajax
      type: 'PUT'
      url: subject.update_url
      data:
        subject: data
    .done (res)=>
      @reload_page @subjects.map (x)->
        x = x.merge data if x.get('id') is subject.id
        x
    .fail (res)->
      console.log res.responseJSON

  reload_page: (subjects)->
    # console.log subjects.toJS()
    @subjects = subjects
    @page.setState
      subjects: subjects.toJS()


Actions = class
  @set_store: (store)->
    @store = store

  @add_subject: (data)->
    @store.create_subject {
      name: data.name
    }

  @add_subject_on: (subject, data)->
    @store.create_subject {
      name: data.name
      parent_id: subject.id
    }

  @remove_subject: (subject)->
    @store.delete_subject subject

  @update_subject: (subject, data)->
    @store.update_subject subject, data