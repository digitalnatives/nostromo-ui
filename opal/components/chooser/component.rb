# Basic Select Element
class Chooser < Fron::Component
  tag 'chooser[tabindex=-1]'

  component :label,    'chooser-label'
  component :dropdown, 'chooser-dropdown'

  on :focus,     :open
  on :blur,      :close
  on :mousedown, :mousedown

  on :click, 'chooser-option', :select

  # Selects the text and sets the nodes value
  #
  # @param event [Event] The event
  def select(event)
    select_option event.target
    trigger 'change'
    blur
  end

  # Runs when the mouse is down,
  # blurs the field if the target
  # isnt inside this element
  #
  # @param event [Event] The event
  def mousedown(event)
    return unless event.target == @label
    return unless DOM::Document.activeElement == self
    event.preventDefault
    blur
  end

  # Show the dropdown
  def open
    addClass 'open'
    toggleClass 'top', top > `(window.innerHeight / 2)`
  end

  # Hides the dropdown
  def close
    removeClass 'open'
  end

  # Returns the value
  #
  # @return [String] The value
  def value
    @value.to_s
  end

  def reset
    @value = nil
    @label.text = ''
  end

  # Sets the value, selecting an option
  def value=(value)
    option = @dropdown.children.find { |child| child[:value] == value.to_s }
    return reset unless option
    select_option option
  end

  # Populates the element with the given options
  #
  # @param options [Array] Array of options
  def populate(options)
    @dropdown.empty
    options.each do |value, text|
      option = DOM::Element.new("chooser-option[value=#{value}]")
      option.text = text
      @dropdown << option
    end
  end

  def populate_from_model(model, options = {}, scope = {})
    options = { value: :id, label: :name, sort_key: nil }.merge options
    model.manager.where(scope) do |items|
      items = items.sort_by { |item| item[options[:sort_key]].to_s } if options[:sort_key]
      items.each do |item|
        @dropdown << DOM::Element.new("chooser-option[value=#{item[options[:value]]}] #{item[options[:label]]}")
      end
      yield items if block_given?
    end
  end

  # Renders the element
  def render
    @label.text = @data
  end

  private

  def select_option(option)
    @value = option[:value]
    @label.text = option.text
  end
end
