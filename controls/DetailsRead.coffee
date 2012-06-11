###
Read mode for contact information
Fairly simple presentation of contact data as static content.
###

class window.DetailsRead extends ContactDetails

  inherited:
    left: [
      { html: "div", ref: "photoContainer", content:
        { html: "img", ref: "photo" }
      }
    ]
    main: [
      { html: "div", ref: "name" }
      { control: "EmailAddress", ref: "email" }
      { control: "PostalAddress", ref: "address" }
      { html: "div", ref: "phone" }
    ]

  initialize: ->
    # A click on a specific field generates an event that lets the card know
    # which *semantic* field was clicked.
    @$name().click ( event ) => @_fieldClick event, "name"
    @$email().click ( event ) => @_fieldClick event, "email"
    @$address().click ( event ) => @_fieldClick event, "address"
    @$phone().click ( event ) => @_fieldClick event, "phone"

  _fieldClick: ( event, fieldName ) ->
    @trigger "fieldClick", [ fieldName ]
