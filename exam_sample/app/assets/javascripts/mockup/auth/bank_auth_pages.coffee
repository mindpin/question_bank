@AuthBankSignInPage = React.createClass
  render: ->
    manager_button_style =
      position: 'absolute'
      top: '1rem'
      left: '1rem'

    manager_sign_in_url = @props.data.manager_sign_in_url

    manager_button = 
      <a className='ui basic button' style={manager_button_style} href={manager_sign_in_url}>后台登录</a>

    <div className='auth-bank-sign-in-page'>
      {manager_button}

      <div className='ui container'>
        <div className='ui grid'>
          <div className='row'>
            <div className='six wide column' />
            <div className='eight wide column product-logo'>
              <div className='logo-img' />
            </div>
          </div>

          <div className='six wide column'>
            <div className='customer-logo' />
          </div>
          <div className='eight wide column'>
            <div className='ui segment'>
              <div className='head'>
                <i className='icon sign in' />
                <span className='sign-in link'>用户登录</span>
              </div>
              <SignInForm submit_url={@props.data.submit_url} />
            </div>
          </div>
        </div>
      </div>
    </div>