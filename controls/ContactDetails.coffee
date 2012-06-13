###
Base class for the two classes, DetailsRead and DetailsEdit, which are used to
implement the read and edit modes, respectively, on a contact card. The shared
aspects of the modes' layout and API is represented in this shared base class.
###

class window.ContactDetails extends Control

  inherited:
    # Arrange content into two simple columns that can be populated by subclasses.
    content: [
      { html: "div", ref: "left" }
      { html: "div", ref: "main" }
    ]

  # The contact() property lets us set all the fields at once. Defining this
  # with Control.property lets us keep a reference to the Contact object that
  # was passed in.
  contact: Control.property ( contact ) ->
    @refresh()

  # Define the main content() of a ContactDetails to be the contact.
  content: Control.chain "contact"

  # Expose the left and main regions as properties for use by subclasses.
  left: Control.chain "$left", "content"
  main: Control.chain "$main", "content"

  # The base ContactDetails class exposes an API with getter/setter functions
  # for address(), email(), etc., but leaves it subclasses to actually define
  # where those values will be displayed. The Control.chain() helper generates
  # a function that will set/get the content of the element/control with the
  # given reference.
  address: Control.chain "$address", "content"
  email: Control.chain "$email", "content"
  name: Control.chain "$name", "content"
  phone: Control.chain "$phone", "content"
  photo: Control.chain( "$photo", "prop/src", ( photo ) ->
    # Hide img if photo is null; can't just set src to empty string.
    # See http://www.nczonline.net/blog/2009/11/30/empty-image-src-can-destroy-your-site/
    @$photo().toggle photo isnt null
  )

  # (Re)load the contact data into the control's fields. This is done when the
  # contact is set, or when the control wants to update the displayed values in
  # response to contact changes.
  refresh: ->
    contact = @contact()
    # To invoke setters, we pass an empty value if the field is undefined.
    @name contact.name() ? ""
    @email contact.email() ? ""
    @address contact.address() ? ""
    @phone contact.phone() ? ""
    @photo contact.photo() ? null
