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
  editing: Control.chain( "$editable", "editing", ( editing ) ->
    if editing
      # When switching to edit mode, by default put focus in name field.
      @$editable().editControl().focusField "name"
  )

  initialize: ->
    @click ( event ) =>
      @_editIfNotEditing()
    @on
      cancel: => @$editable().cancel()
      fieldClick: ( event, fieldName ) =>
        # The user clicked a field on the card. If the card is selected but not
        # yet in edit mode, switch to edit mode and put the focus in that field.
        @_editIfNotEditing()
        if @editing()
          @$editable().editControl().focusField fieldName
      save: => @$editable().save()

  # The list box invokes this when a card becomes selected or deselected.
  selected: Control.property.bool ( selected ) ->
    if !selected and @editing()
      @$editable().cancel() # Deselecting implicitly cancels editing.

  # If we're selected but not editing yet, switch to editing.
  _editIfNotEditing: ->
    if @selected() and !@editing()
      @editing true
