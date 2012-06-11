###
A field (e.g., text) with an adjacent button that launches a page/app based on
the field's current contents.
The button is only shown if the content is non-empty.
###

class window.FieldLauncher extends Control
  
  inherited:
    content: [
      { html: "span", ref: "FieldLauncher_content" }
      {
        control: BasicButton
        ref: "launchButton"
        class: "transient"
        generic: false
      }
    ]
    
  content: Control.chain( "$FieldLauncher_content", "content", ( content ) ->
    # Hide button if content is empty
    @$launchButton().toggle content? and content.length > 0
  )

  initialize: ->
    @$launchButton().click ( event ) =>
      window.location = @launchUrl()
      event.stopPropagation()

  # The content of the launch button
  launchButtonContent: Control.chain "$launchButton", "content"

  # The URL to launch when the button is clicked. By default this opens the
  # content in the browser as is, generally triggering the user's search engine.
  # This can be overridden in subclasses.
  launchUrl: -> @content()