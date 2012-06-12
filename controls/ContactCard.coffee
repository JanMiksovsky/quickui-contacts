###
A business card showing information for a single card.

This control serves as the View for an individual contact model. The model
doesn't actually have to be an object of class Contact; the model just needs
to expose getter/setter properties for name(), email(), etc.

This call mostly serves to bind together the two different UIs for read mode
and edit mode; those classes do the actual work of displaying and manipulating
the contact data.
###

class window.ContactCard extends Card
  
  inherited:
    content:
      # The Mode control shows just one child (mode) at a time.
      control: Mode, ref: "mode", content: [
        { control: "DetailsRead", ref: "modeRead" }
        { control: "DetailsEdit", ref: "modeEdit" }
      ]

  contact: Control.property( ( contact ) ->
    @$modeRead().contact contact
    @$modeEdit().contact contact
  )
  
  # True if the card is being edited
  editing: Control.chain( "applyClass/editing", ( editing ) ->
    if editing
      @$mode().activeChild @$modeEdit()
      @$modeEdit().focusField "name"
    else
      # Switching back to read mode.
      @$modeRead().refresh() # Pick up any changes made in edit mode.
      @$mode().activeChild @$modeRead()
  )
  
  initialize: ->
    @click ( event ) =>
      # A click on the card background in read mode behaves like clicking
      # on the name field.
      @_fieldClick "name"
    @on
      "done": => @editing false
      "fieldClick": ( event, fieldName ) => @_fieldClick fieldName

  # The list box invokes this when a card becomes selected or deselected.
  selected: Control.property.bool ( selected ) ->
    if !selected and @editing()
      @editing false    # Deselecting implicitly cancels editing.

  # The user clicked a field on the card. If the card is selected but not yet
  # in edit mode, switch to edit mode and put the focus in that field.
  _fieldClick: ( fieldName ) ->
    if @selected() and !@editing()
      @editing true
      @$modeEdit().focusField fieldName
