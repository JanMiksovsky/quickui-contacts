# Unit tests

$ ->

  contacts = undefined
  contactsPresenter = undefined
  contactsPage = undefined

  module "contacts",
    setup: ->
      contacts = new Contacts()
      contacts.localStorage = new Backbone.LocalStorage "Contacts Test"
      contactsPage = ContactsPage.create()
      contactsPresenter = new ContactsPresenter
        el: contactsPage
        model: contacts

  test "Model: add", ->
    contacts.add [
      { name: "Ann Williams" }
      { name: "Rachel Garcia" }
      { name: "Steve Thomson" }
    ]
    equal contacts.models.length, 3

  test "Presenter: handle view's new event", ->
    equal contacts.models.length, 0
    contactsPage.trigger "new"
    equal contacts.models.length, 1
    equal contactsPage.selectedIndex(), 0
    ok contactsPage.selectedCard().editing()

  test "Presenter: handle model's remove event", ->
    contact = new Contact name: "Ann Williams"
    contacts.add contact
    equal contacts.models.length, 1
    contact.destroy()
    equal contacts.models.length, 0
    equal contactsPage.contacts().length, 0
    equal contactsPage.selectedIndex(), -1

  test "View: Update contact", ->
    contact = new Contact name: "Ann"
    contacts.add contact
    card = ContactCard.create contact: contact
    card.name "Annie"
    card.save()
    equal contact.get( "name" ), "Annie"

  test "View: Save button disabled if name is empty", ->
    contact = 
    card = ContactCard.create()
    card.contact contact
    ok card.$buttonSave().disabled()
    card.name "Ann"
    ok !card.$buttonSave().disabled()