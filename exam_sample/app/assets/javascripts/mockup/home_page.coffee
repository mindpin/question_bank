@HomePage = React.createClass
  getInitialState: ->
    current_user: @props.data.current_user
  render: ->
    <div>
      <div className='ui container'>
        <div className='ui segment basic'>
          <FinanceCourseSelectWizard posts={@props.data.posts} result_wares={@props.data.result_wares}/>
        </div>
      </div>
    </div>