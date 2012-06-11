###
A toolbar showing the app name and the app's top-level commands.
###

class window.Toolbar extends Control
  
  inherited:
    content: [
      { html: "<h1>Contacts</h1>", ref: "logo" }
      { control: BasicButton, ref: "buttonNew", content: "+ New" }
      { control: PopupButton, ref: "buttonDebug", content: "Debug", popup: [
          { control: MenuItem, ref: "menuItemSamples", content: "Reload Sample Contacts" }
          { control: MenuItem, ref: "menuItemEraseAll", content: "Remove All" }
          { control: MenuSeparator }
          { control: MenuItem, ref: "menuAbout", content: "About This Application" }
      ]}
    ]

  initialize: ->
    @$buttonNew().click => @trigger "new"
    @$menuItemSamples().click => @trigger "samples"
    @$menuItemEraseAll().click => @trigger "eraseAll"
    @$menuAbout().click =>
      window.open "http://quickui.org/docs/contacts.html"
