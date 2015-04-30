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
    `#{ContentEditable.editablefix}.el.setSelectionRange(0, 0);`
    ContentEditable.editablefix.blur
    `ClearSelection()`
    trigger 'change'
  end

  # Fix for chrome...
  def self.editablefix
    return @editablefix if @editablefix
    @editablefix = DOM::Element.new 'input[tabindex=-1]'
    @editablefix.style.width = 1.px
    @editablefix.style.height = 1.px
    @editablefix.style.margin = 0
    @editablefix.style.border = 0
    @editablefix.style.padding = 0
    @editablefix >> DOM::Document.body
    @editablefix
  end
end
