@ManagerFinanceTellerWarePreviewPage = React.createClass
  getInitialState: ->
    ware: @props.data
  render: ->
    data = 
      baseinfo: @state.ware
      actioninfo:
        actions: @state.ware.actions

    <div>
      <TellerCourseWare data={data} />
    </div>