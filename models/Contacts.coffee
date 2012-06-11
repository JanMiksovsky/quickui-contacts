###
The Model for a collection of contacts.
This is the Model used by the ContactListBox View class.
###

class window.Contacts extends Backbone.Collection

  # Sort contacts by name
  comparator: ( contact ) -> contact.get "name"
  
  # Use local storage
  localStorage: new Backbone.LocalStorage "Contacts"

  # This collection holds Contact objects.
  model: Contact
