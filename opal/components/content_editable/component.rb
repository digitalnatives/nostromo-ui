# Content Editable
class ContentEditable < Fron::Component
  on :blur, :change

  # Initializes the compontent:
  # * Sets the **contenteditable** attribute to true
  def initialize
    super
    self[:contenteditable] = true
    `#{@el}.spellcheck = false`
  end

  # Triggers the change event
  def change
    trigger 'change'
  end

  # Checks for new line to trigger that a changed happened
  def pressed(event)
    return unless event.keyCode == 13
  end
end
