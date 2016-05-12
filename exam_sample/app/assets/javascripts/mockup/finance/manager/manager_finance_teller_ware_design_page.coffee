@ManagerFinanceTellerWareDesignPage = React.createClass
  getInitialState: ->
    actions: @props.data.ware.actions || {}
    ware: @props.data.ware
    search_clip_url: @props.data.search_clip_url

  render: ->
    {
      Sidebar, Previewer
    } = ManagerFinanceTellerWareDesignPage

    <div className='manager-finance-teller-ware-designer-page'>
      <Sidebar actions={@state.actions} ware={@state.ware} search_clip_url={@state.search_clip_url}/>
      <Previewer actions={@state.actions} />
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @

  statics:
    Sidebar: React.createClass
      render: ->
        actions_array = (action for id, action of @props.actions)

        table_data = {
          fields:
            name_label: '名称'
            ops: '操作'

          data_set: actions_array.map (x)=>
            jQuery.extend {
              name_label:
                <div>
                  {x.role}: {x.name}
                </div>
              ops:
                <div className='ops'>
                  <a href='javascript:;' className='ui button basic mini blue' onClick={@edit(x)}>
                    <i className='icon pencil' />
                  </a>
                  {
                    klass = new ClassName
                      'ui button mini blue': true
                      'basic': not (x.linked_screen_ids? and x.linked_screen_ids.length > 0)
                    <a href='javascript:;' className={klass} onClick={@link_screen(x)}>
                      <i className='icon desktop' />
                    </a>
                  }
                  {
                    klass = new ClassName
                      'ui button mini blue': true
                      'basic': not (x.linked_clip_ids? and x.linked_clip_ids.length > 0)
                    <a href='javascript:;' className={klass} onClick={@link_clip(x)}>
                      <i className='icon attach' />
                    </a>
                  }
                  <a href='javascript:;' className='ui button basic mini red' onClick={@remove(x)}>
                    <i className='icon delete' />
                  </a>
                </div>
            }, x

          th_classes:
            {}
          td_classes:
            ops: 'collapsing'
        }

        <div className='sidebar'>
          <div className='bar-header'>
            <div className='btns'>
              <a href='javascript:;' className='ui button mini green' onClick={@show_edit_info_modal}>
                <i className='icon pencil' />
              </a>
              <a href={@props.ware.preview_url} className='ui button mini green' target='_blank'>
                预
              </a>
              <a href='javascript:;' className='ui button mini green' onClick={@show_add_modal}>
                <i className='icon plus' />
              </a>
            </div>
            <div className='name'>{@props.ware.name}</div>
            <div className='number'>{@props.ware.number}</div>
          </div>
          <div className='table-scroller'>
            {
              if actions_array.length > 0
                <ManagerTable data={table_data} title='流程节点' />
              else
                <div style={padding: '0.5rem'}>没有数据</div>
            }

          </div>
        </div>

      edit: (x)->
        =>
          jQuery.open_modal(
            <ManagerFinanceTellerWareDesignPage.UpdateModal action={x} actions={@props.actions}/>, {
              closable: false
            }
          )

      remove: (x)->
        ->
          jQuery.modal_confirm
            text: '确定要删除吗？<br/>关联关系将被自动解除。'
            yes: ->
              Actions.remove(x)

      link_screen: (x)->
        =>
          trade_url = window.trade_url
          unless trade_url?
            console.warn '未设置 window.trade_url'
            return

          jQuery.ajax
            url: trade_url
            data: number: @props.ware.number
          .done (res)->
            hmdms = res.all_hmdms

            jQuery.open_modal(
              <ManagerFinanceTellerWareDesignPage.ScreenModal action={x} hmdms={hmdms} />, {
                closable: false
              }
            )

      link_clip: (x)->
        =>
          jQuery.open_modal(
            <ManagerFinanceTellerWareDesignPage.ClipModal action={x} search_clip_url={@props.search_clip_url} />, {
              closable: false
            }
          )

      show_add_modal: ->
        jQuery.open_modal(
          <ManagerFinanceTellerWareDesignPage.AddModal />, {
            closable: false
          }
        )

      show_edit_info_modal: ->
        jQuery.open_modal(
          <ManagerFinanceTellerWareDesignPage.EditInfoModal ware={@props.ware} />, {
            closable: false
          }
        )


    Previewer: React.createClass
      render: ->
        actioninfo =
          actions: @props.actions
          action_desc: []
          screens: []
          screens_desc: []

        <div className='previewer'>
          <TellerCourseWare.Panel data={actioninfo} />
        </div>

    EditInfoModal: React.createClass
      render: ->
        {
          TextInputField
          TextAreaField
          SelectField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        kinds =
          none: '无'
          day_begin_ops:                '日初处理',
          day_end_ops:                  '日终处理',

          saving_ops:                   '储蓄业务',
          personal_loan_ops:            '个人贷款业务',
          company_saving_and_loan_ops:  '对公存贷业务',
          delegate_ops:                 '代理业务',
          pay_and_settle_ops:           '支付结算',
          public_ops:                   '公共业务',
          stock_ops:                    '股金业务',

        <div>
          <h3 className='ui header'>修改课件信息</h3>
          <DataForm.Form onSubmit={@submit} onCancel={@cancel} ref='form' data={@props.ware}>
            <TextInputField {...layout} label='交易名称：' name='name' required />
            <TextInputField {...layout} label='交易代码：' name='number' required />
            <SelectField {...layout} label='业务类型：' name='business_kind' values={kinds}/>
            <TextAreaField {...layout} label='交易概述：' name='desc' placeholder='根据操作手册填写' />
            <TextInputField {...layout} label='编辑人备注：' name='editor_memo' />
            <Submit {...layout} text='确定保存' with_cancel='关闭' />
          </DataForm.Form>
        </div>

      submit: (data)->
        @refs.form.set_submiting true
        Actions.update_ware data, =>
          @state.close()

      cancel: ->
        @state.close()


    AddModal: React.createClass
      render: ->
        {
          TextInputField
          SelectField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        roles = 
          '柜员': '柜员'
          '客户': '客户'

        <div>
          <h3 className='ui header'>新增操作节点</h3>
          <DataForm.Form onSubmit={@submit} ref='form' onCancel={@cancel}>
            <TextInputField {...layout} label='操作名称：' name='name' required />
            <SelectField {...layout} label='操作角色：' name='role' values={roles}/>
            <Submit {...layout} text='确定保存' with_cancel='关闭' />
          </DataForm.Form>
        </div>

      submit: (data)->
        @refs.form.set_submiting true
        Actions.add data, =>
          @state.close()

      cancel: ->
        @state.close()

    UpdateModal: React.createClass
      render: ->
        {
          TextInputField
          SelectField
          MultipleSelectField
          TextAreaField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        roles = 
          '柜员': '柜员'
          '客户': '客户'

        all_pres_action_ids = Object.keys @get_all_pres_actions @props.action
        optional_actions = Immutable.fromJS []
        for a_id, _action of @props.actions
          if all_pres_action_ids.indexOf(_action.id) < 0
            optional_actions = optional_actions.push Immutable.fromJS(_action)

        grid_values = {}
        for x in optional_actions.toJS()
          grid_values[x.id] = x.name

        <div>
          <h3 className='ui header'>修改操作节点</h3>
          <DataForm.Form onSubmit={@submit} onCancel={@cancel} ref='form' data={@props.action}>
            <TextInputField {...layout} label='操作名称：' name='name' required />
            <SelectField {...layout} label='操作角色：' name='role' values={roles} />
            <MultipleSelectField {...layout} label='后续操作：' name='post_action_ids' values={grid_values} />
            <TextAreaField {...layout} label='操作概述' name='desc' placeholder='根据操作手册填写' />
            <Submit {...layout} text='确定保存' with_cancel='关闭' />
          </DataForm.Form>
        </div>

      submit: (data)->
        @refs.form.set_submiting true
        Actions.update data, =>
          @state.close()

      cancel: ->
        @state.close()

      # 获取所有直接前置节点
      get_pre_actions: (action)->
        pre_actions = {}
        for _id, _action of @props.actions
          if (_action.post_action_ids || []).indexOf(action.id) > -1
            pre_actions[_action.id] = _action
        pre_actions 

      get_all_pres_actions: (action)->
        all_pres_actions = {}
        @_r_ga action, all_pres_actions
        all_pres_actions

      _r_ga: (action, all_pres_actions)->
        all_pres_actions[action.id] = action
        for _id, _action of @get_pre_actions(action)
          @_r_ga _action, all_pres_actions


    ScreenModal: React.createClass
      getInitialState: ->
        linked_screen_ids: @props.action.linked_screen_ids || []

      render: ->
        linked_screen_ids = @state.linked_screen_ids
        hmdms = @props.hmdms

        <div className='teller-ware-design-screens-modal'>
          <h3 className='ui header'>关联模拟屏幕</h3>
          <div className='screens'>
          {
            for hmdm in hmdms
              selected = linked_screen_ids.indexOf(hmdm) >= 0

              klass = new ClassName
                'screen': true
                'selected': selected

              params = 
                checked: selected
                onChange: @change(hmdm)

              <div key={hmdm} className={klass}>
                <div className='ui checkbox'>
                  <input type='checkbox' {...params} />
                  <label>
                    <TellerScreenButton hmdm={hmdm} />
                  </label>
                </div>
              </div>
          }
          </div>
          <div style={textAlign: 'right', marginTop: '2rem'}>
            <a href='javascript:;' className='ui button green' onClick={@submit}>
              <i className='icon checkmark' /> 确定
            </a>
            <a href='javascript:;' className='ui button' onClick={@close}>关闭</a>
          </div>
        </div>

      close: ->
        @state.close()

      change: (hmdm)->
        (evt)=>
          linked_screen_ids = Immutable.fromJS @state.linked_screen_ids

          if evt.target.checked
            linked_screen_ids = linked_screen_ids.push hmdm
          else
            linked_screen_ids = linked_screen_ids.filter (x)->
              x != hmdm

          @setState linked_screen_ids: linked_screen_ids.toJS()

      submit: ->
        action = Immutable.fromJS @props.action
        action = action.set 'linked_screen_ids', @state.linked_screen_ids || []
        action = action.toJS()

        Actions.update action, =>
          @close()

    ClipModal: React.createClass
      getInitialState: ->
        linked_clip_ids: @props.action.linked_clip_ids || []
        clips: []

      render: ->
        # console.log @state.linked_clip_ids

        <div>
          <h3>关联媒体资源</h3>
          <div>
            <div className='ui input'>
              <input type='text' placeholder='查找...' onChange={@search} />
            </div>
            <div className='ui divided list'>
            {
              for clip in @state.clips
                selected = @state.linked_clip_ids.indexOf(clip.cid) >= 0

                params = 
                  checked: selected
                  onChange: @checkbox(clip.cid)

                <div key={clip.cid} className='item'>
                  <div className='ui checkbox'>
                    <input type='checkbox' {...params} />
                    <label>
                    {clip.name}
                    <a style={marginLeft: '0.5rem'} href={clip.file_info.url} target='_blank'><i className='icon external' /></a>
                    </label>
                  </div>
                </div>
            }
            </div>
          </div>

          <div style={textAlign: 'right', marginTop: '2rem'}>
            <a href='javascript:;' className='ui button green' onClick={@submit}>
              <i className='icon checkmark' /> 确定
            </a>
            <a href='javascript:;' className='ui button' onClick={@close}>关闭</a>
          </div>
        </div>

      checkbox: (cid)->
        (evt)=>
          linked_clip_ids = Immutable.fromJS @state.linked_clip_ids

          if evt.target.checked
            linked_clip_ids = linked_clip_ids.push cid
          else
            linked_clip_ids = linked_clip_ids.filter (x)->
              x != cid

          @setState linked_clip_ids: linked_clip_ids.toJS()

      close: ->
        @state.close()

      search: (evt)->
        value = jQuery.trim evt.target.value

        clearTimeout @timer if @timer

        @timer = setTimeout =>
          if value != ''
            jQuery.ajax
              url: @props.search_clip_url
              data: key: value
            .done (res)=>
              @setState clips: res

        , 500

      submit: ->
        action = Immutable.fromJS @props.action
        action = action.set 'linked_clip_ids', @state.linked_clip_ids || []
        action = action.toJS()

        Actions.update action, =>
          @close()
          


class DataStore
  constructor: (@page)->
    @actions = Immutable.fromJS(@page.state.actions || {})
    @ware = Immutable.fromJS(@page.state.ware)

    @update_url = @page.props.data.ware?.design_update_url
    @ware_update_url = @page.props.data.ware?.update_url

  remove_action: (action)->
    actions = @actions.filter (x)->
      x.get('id') != action.id

    actions = actions.map (x)->
      x = x.update 'post_action_ids', (ids)->
        ids = if ids?
          ids.filter (pid)->
            pid != action.id
        else
          Immutable.fromJS []
      x

    @ajax_update actions

  add_action: (action, callback)->
    actions = @actions.set action.id, Immutable.fromJS(action)
    @ajax_update actions, callback

  update_action: (action, callback)->
    actions = @actions.set action.id, Immutable.fromJS(action)
    @ajax_update actions, callback

  update_ware: (data, callback)->
    ware = @ware
      .set 'name', data.name
      .set 'number', data.number
      .set 'desc', data.desc
      .set 'business_kind', data.business_kind
      .set 'editor_memo', data.editor_memo

    ware = ware.toJS()

    jQuery.ajax
      type: 'PUT'
      url: @ware_update_url
      data:
        ware:
          name: ware.name           
          number: ware.number
          desc: ware.desc           
          business_kind: ware.business_kind
          editor_memo: ware.editor_memo

    .done (res)=>
      @page.setState
        ware: ware
      callback?()

  update_action_ids: (action, screen_ids)->
    console.log action, screen_ids

  ajax_update: (actions, callback)->
    jQuery.ajax
      type: 'PUT'
      url: @update_url
      data:
        actions: actions.toJS()
    .done (res)=>
      @reload_page actions
      callback?()


  reload_page: (actions)->
    @actions = actions
    @page.setState
      actions: actions.toJS()


Actions = class
  @set_store: (store)->
    @store = store

  @remove: (action)->
    @store.remove_action action

  @add: (data, callback)->
    action = jQuery.extend {
      id: "id#{new Date().getTime()}"
      post_action_ids: []
    }, data

    @store.add_action action, callback

  @update: (data, callback)->
    action = data
    @store.update_action action, callback

  @update_ware: (ware, callback)->
    @store.update_ware ware, callback