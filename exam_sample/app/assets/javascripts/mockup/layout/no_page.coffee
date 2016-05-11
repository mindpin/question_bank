@LayoutNoPage = React.createClass
  render: ->
    <div className='layout-no-page'>
      <div className='ui container'>
        <div className='ui segment nomtop basic'>
          <h1 className='ui header'>这里是{@props.name}页面，UI 还没设计好</h1>
        </div>
      </div>
    </div>