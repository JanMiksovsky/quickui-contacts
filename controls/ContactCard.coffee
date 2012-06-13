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
      # The Editable control gives us read and edit modes.
      control: Editable
      ref: "editable"
      readClass: "DetailsRead"
      editClass: "DetailsEdit"

  contact: Control.chain "$editable", "content"
  
  # The card's edit state is delegated to (and managed by) the Editable control.
  editing: Control.chain "$editable", "editing"
  
  initialize: ->
    @click ( event ) =>
      # Clicking on card background behaves like clicking on the name field.
      @_fieldClick "name"
    @on
      cancel: => @$editable().cancel()
      fieldClick: ( event, fieldName ) => @_fieldClick fieldName
      save: => @$editable().save()

  # The list box invokes this when a card becomes selected or deselected.
  selected: Control.property.bool ( selected ) ->
    if !selected and @editing()
      @$editable().cancel() # Deselecting implicitly cancels editing.

  # The user clicked a field on the card. If the card is selected but not yet
  # in edit mode, switch to edit mode and put the focus in that field.
  _fieldClick: ( fieldName ) ->
    if @selected() and !@editing()
      @editing true
      @$editable().editControl().focusField fieldName
