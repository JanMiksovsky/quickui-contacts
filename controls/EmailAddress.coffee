###
A read-only email address that includes a Send button.
###

class window.EmailAddress extends FieldLauncher

  inherited:
    launchButtonContent: "<img src='resources/mail_alt_16x12.png'/>"

  launchUrl: -> "mailto:#{@content()}"
