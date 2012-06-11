###
The Model to hold the contact information for a single person.
This is the Model used by the ContactCard View class.
###


# Helper function: Returns a getter/setter for a model attribute. 
ModelAttribute = ( attributeName ) ->
  ( attributeValue ) ->
    if attributeValue is undefined
      @get attributeName    
    else
      @set attributeName, attributeValue


# The main Contact model
class window.Contact extends Backbone.Model
  address: ModelAttribute "address"
  email: ModelAttribute "email"
  name: ModelAttribute "name"
  phone: ModelAttribute "phone"
  photo: ModelAttribute "photo"
