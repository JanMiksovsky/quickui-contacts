###
Edit mode for contact information

Provides the various input fields and some keyboard handling.
###

class window.DetailsEdit extends ContactDetails

  inherited:
    left: [
      { html: "div", ref: "photoContainer", content:
        { html: "img", ref: "photo" }
      }
      {
        control: BasicButton, ref: "buttonDelete", generic: false, content: 
          # Trash icon from Iconic icon set. http://somerandomdude.com/work/iconic/
          "<img src='resources/trash_stroke_16x16.png' title='Delete contact'/>"
      }
    ]
    main: [
      {
        control: ValidatingTextBox,
        placeholder: "Name"
        ref: "name"
        required: true
        validateOnBlur: false
        validateOnSet: false
      }
      { control: TextBox, ref: "email", class: "optional", placeholder: "Email" }
      {
        control: AutoSizeTextBox
        ref: "address"
        class: "optional"
        minimumLines: 2
        placeholder: "Address"
      }
      { control: TextBox, ref: "phone", class: "optional", placeholder: "Phone" }
      {
        html: "div", ref: "buttonPanel", content: [
          { control: BasicButton, ref: "buttonSave", content: "Save", class: "prominent" }
          { control: BasicButton, ref: "buttonCancel", content: "Cancel" } 
        ]
      }
    ]
  
  # Cancel any edit in progress.
  cancel: ->
    if @contact().isNew()
      @delete()
    else
      @trigger "cancel"

  delete: ->
    @contact().destroy()

  # Set the focus to the input or textarea with the given named field.
  focusField: ( fieldName ) ->
    control = @[ "$" + fieldName ]()
    control.find( "input, textarea" ).andSelf().focus()

  initialize: ->
    # Wire up event handlers.
    # The keyboard and click handlers triggered here in edit mode generally
    # override the behavior provided by the overall card and the list box,
    # hence the need to stop these events from propagating up.
    @$buttonCancel().click ( event ) =>
      @cancel()
      event.stopPropagation()
    @$buttonDelete().click ( event ) =>
      @delete()
      event.stopPropagation()
    @$buttonSave().click ( event ) =>
      @save()
      event.stopPropagation()

    # In the keyboard handlers, we check to see if we're still visible before
    # deciding whether to handle. Right after leaving edit mode, the keyboard
    # focus may still be in one of this control's fields, even though this
    # control itself is hidden.
    @find( "input" ).keydown ( event ) =>
      # Pressing Enter in single-line input fields saves the contact.
      if @is( ":visible" ) and event.which == 13 # Enter
        @save()
        event.stopPropagation()
    @keydown ( event ) =>
      if @is( ":visible" )
        if event.which == 27 # Esc
          @cancel()
        event.stopPropagation()
    @$name().keyup ( event ) =>
      if @is( ":visible" )
        @_validate()
    @find( ".optional, .optional input, .optional textarea" ).focus =>
      # When focus moves into an optional field, validate the name field.
      # We don't do this simply when the name field blurs, because then a click
      # on Cancel would validate, and that'd be annoying.
      @$name().validate true

  name: ( name ) ->
    result = super name
    if name isnt undefined
      @_validate()
    result

  # Save the contact data to the model.
  save: ->
    contact = @contact()
    contact.set
      name: @name()
      email: @email()
      address: @address()
      phone: @phone()
    # If the user changed the name, the save() operation may cause the contact
    # to be resorted, which will cause this card to be removed. So do the save
    # last, and don't try to manipulate the card afterwards.
    contact.save()
    @trigger "save"

  # See if we've got a valid contact
  _validate: ->
    @$buttonSave().disabled !@$name().valid()
