###
A list of contact business cards.
This is simply a ListBox that represents its list item as ContactCard controls.
A ListBox derives from List, which will takes care of populating a ContactCard
for each item in the list. The ListBox class adds support for selection. So
defining a list box of contact cards involves very little code.
###

class window.ContactListBox extends ListBox
  
  inherited:
    # We'll style this list box ourselves, so we don't need its generic style.
    generic: false
    # Similarly, we'll opt out of standard list item highlighting colors.
    highlightSelection: false
    # Each item in the list should be represented as a ContactCard control.
    itemClass: "ContactCard"
    # The list item (the model) will be passed to a card's contact() property.
    mapFunction: "contact"

  initialize: ->
    # Wire up some keyboard behavior
    $( document ).keydown ( event ) =>
      # See if the key was within the list box.
      containsTarget = ( this[0] is event.target or $.contains( this[0], event.target ) )
      if containsTarget
        switch event.which
          when 13 # Enter
            if @selectedControl()?.editing() == false
              @selectedControl().editing true
          when 27 # Esc
            @selectedControl null   # Cancel selection
          when 46 # Del
            if @selectedControl().editing() == false
              @selectedItem()?.destroy()

  # Override the ListBox._controlClick() method, which is invoked when the
  # user clicks on a card in the list.
  _controlClick: ( control ) ->
    if @selectedControl()?.editing()
      return @  # Absorb any clicks made while a card is being edited.
    super control # Do the normal thing (select the clicked card).