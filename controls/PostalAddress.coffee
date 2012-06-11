###
A read-only postal address that includes a map button.
###

class window.PostalAddress extends FieldLauncher
  
  inherited:
    launchButtonContent: "<img src='resources/map_pin_fill_16x16.png'/>"

  launchUrl: ->
    address = @content().replace "\n", " "
    "http://maps.google.com/?q=#{address}"

  # Render the address in a pre so we can preserve line breaks.
  tag: "pre"
