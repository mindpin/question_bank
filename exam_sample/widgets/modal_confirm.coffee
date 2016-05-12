jQuery.modal_confirm = (config)->
  $dom = jQuery """
    <div class="ui modal confirm">
      <div class="content">
        <p>#{config.text}</p>
      </div>
      <div class="actions">
        <div class="ui green mini button ok">
          <i class="checkmark icon"></i> 是
        </div>
        <div class="ui mini button cancel">
          <i class="remove icon"></i> 否
        </div>
      </div>
    </div>
  """
    .appendTo document.body

  $dom
    .modal
      blurring: true
      onApprove: -> 
        config.yes?()
      onDeny: -> 
        config.no?()
    .modal('show')


# ModalConfirm = React.createClass
#   render: ->
#     <div className="ui modal confirm">
#       <div className="content">
#         <p>{@props.text}</p>
#       </div>
#       <div className="actions">
#         <div className="ui green mini button ok">
#           <i className="checkmark icon"></i> 是
#         </div>
#         <div className="ui mini button cancel">
#           <i className="remove icon"></i> 否
#         </div>
#       </div>
#     </div>