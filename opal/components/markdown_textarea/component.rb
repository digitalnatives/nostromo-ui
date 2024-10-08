# Markdown Textarea
class MarkdownTextarea < Fron::Component
  extend Forwardable

  attr_reader :readonly

  tag 'markdown-textarea'

  component :content,  :content
  component :textarea, 'textarea[spellcheck=false]'
  component :hints,    'span'
  component :icon,     'a[href=https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet][target=_blank] ?'

  def_delegators :@textarea, :value, :blur

  on :click,      :a,        :link
  on :click,      :edit
  on :mousedown,  :mousedown
  on :change,     :render

  def readonly=(value)
    @readonly = !!value
  end

  # Initializes the textearea
  def initialize
    super
    @hints.html = '<b>**bold**</b> <i>_italics_</i> <code>`code`</code> <code>```preformatted```</code> > quote'
    @textarea.on :blur do finish end
    @textarea.on :focus do start end
    finish
  end

  # Sets the placeholder to the given value
  #
  # @param value [String] The value
  def placeholder=(value)
    @textarea[:placeholder] = value
  end

  # Runs when a link is clicked, stopping the editing proccess.
  #
  # @param event [Event] The event
  def link(event)
    return if event.target == @icon
    event.stopImmediatePropagation
  end

  # Sets the value to the given value
  #
  # @param value [String] The value
  def value=(value)
    @textarea.value = value
    render
  end

  # Ends the editing process
  def finish
    timeout do removeClass 'editing' end
  end

  # Runs when the mouse is down in the component
  #
  # @param event [Event] The event
  def mousedown(event)
    return event.preventDefault if event.target == @icon
  end

  # Edits the texteare
  #
  # @param event [Event] The event
  def edit(event)
    return if @readonly
    return if event.target == @textarea
    @textarea.focus
  end

  # Starts the editing process
  def start
    addClass 'editing'
  end

  # Renders the value as markdown
  def render
    @content.html = `marked(Encoder.htmlEncode(#{value.to_s}), { breaks: true })`
    findAll('a').each { |link| link[:target] = '_blank' }
  end
end
