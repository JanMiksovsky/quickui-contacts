###
Presenter responsible for wiring together the top-level View (a ContactsPage)
and the top-level model (a Contacts collection).

For convenience, we derive this presenter from Backbone's View class to pick
up some benefits like automatic references to the model and the View's
top-level DOM element. The real View role, however, is filled by the QuickUI
controls.

Backbone defines a $el member for us, which is designed to hold a jQuery
instance. Since a QuickUI control *is* a jQuery reference, we can use the $el
member to directly hold a reference to the QuickUI control serving as the View.
###

class window.ContactsPresenter extends Backbone.View
  
  # A new contact has been added.
  add: ( contact, contacts, options ) ->
    @$el
      .insertItemBefore( contact, options.index ) # Add contact to the list.
      .selectedIndex( options.index ) # Select the card for the new contact.
    
  # The contact's name has changed. We resort the card in response. We could
  # easily accomplish this by invoking the collection's own sort() method,
  # but that will cause a complete reset of the collecction, and therefore a
  # complete (and slow) repopulation of the list box. Instead, we remove the
  # card from the collection, then reinsert it at the correct position.
  change: ( contact ) ->
    @model.remove contact
    index = findInsertLocation contact, @contacts(), @model.comparator
    @model.add contact, options: at: index
    @$el.selectedIndex index  # Keep the contact selected.
      
  # Shorthand for referring to the set of contacts
  contacts: -> @model.models
      
  # Erase all contacts.
  # REVIEW: Is there a better way to do this in Backbone?
  eraseAll: ->
    contacts = @contacts()
    while contacts.length > 0
      contacts[0].destroy silent: true
    @model.reset()

  # The View events we're interested in.    
  events:
    eraseAll: "eraseAll"
    new: "newContact"
    samples: "samples"

  initialize: ->
    @model.on "add", @add, this
    @model.on "change:name", @change, this
    @model.on "reset", @render, this
    @model.on "remove", @remove, this
    @render()
    
  # The View has raised a new event.
  newContact: ->
    # Create a new contact with an empty name.
    # (The empty name will sort the new contact to the beginning of the list.)
    @model.add name: ""
    # Put the card for the new contact in editing mode.
    @$el.selectedContact()?.editing true

  # Render all the contacts.
  render: -> @$el.contacts @contacts()
  
  # Remove the indicated contact.
  remove: ( contact, contacts, options ) ->
    @$el.selectedContact().editing false
    @$el.removeItemAt options.index
    # Select the new item at the previous position, or the last item.
    @$el.selectedIndex Math.max options.index, @contacts.length
    
  # Replace set of contacts with sample contact set.
  # REVIEW: Is there a better way to do this in Backbone?
  samples: ->
    $.getJSON( "contacts.json" ).success ( data ) =>
      @eraseAll()
      @model.reset data.contacts
      contact.save() for contact in @contacts()

  # Return the index of the location where the given model should be inserted
  # in order to preserve sort order. Note that this function is defined with
  # "=" instead of ":", making the function private to the class scope.
  findInsertLocation = ( model, models, comparator ) ->
    min = 0
    max = models.length - 1
    key = comparator model
    # A simple binary search
    while max >= min
      mid = Math.floor ( min + max ) / 2
      considerKey = comparator models[ mid ]
      if considerKey < key
        min = mid + 1
      else if considerKey > key
        max = mid - 1
      else
        return mid # Position of an existing model with the same key
    return max + 1 # Where the model would be if it were already in the list