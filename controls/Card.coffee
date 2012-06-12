###
A container with effects (e.g., a shadow) to simulate a business or index card.
###

class window.Card extends Control

  inherited:
    content:
      # The Fader fades out any text that can't fit in the normal state.
      control: Fader, ref: "container", direction: "vertical", content:
        html: "div", ref: "Card_content"

  # The card's content goes inside the div defined above.
  # See http://quickui.org/docs/rendering.html for a discussion of how and why
  # a control class might want to redefine its content() property this way.
  content: Control.chain "$Card_content", "content"