class MultiSelect < Fron::Component
  class << self
    def base(klass)
      return @base if @base
      @base = klass
    end

    def placeholder(text)
      return @placeholder if @placeholder
      @placeholder = text
    end
  end

  extend Forwardable

  tag 'multi-select'

  component :input, 'input'
  component :dropdown, 'multi-select-dropdown'

  def_delegators :class, :base, :placeholder

  on :input, :filter
  on :change, :render_label

  def self.create(base, placeholder = '')
    klass = super 'multi-select'
    klass.base base
    klass.placeholder placeholder
    klass
  end

  def initialize
    super
    @items = []
    @input.on(:focus) { on_focus }
    @input.on(:blur)  { on_blur  }
    render_label
  end

  def on_focus
    show_all
    @input.value = ''
    @input[:placeholder] = ''
    addClass 'open'
  end

  def on_blur
    removeClass 'open'
    render_label
  end

  def reset
    items.each { |item| item.checked = false }
    render_label
  end

  def render_label
    return if DOM::Document.activeElement == @input
    @input[:placeholder] = placeholder
    @input.value = selected.map(&:label).join(', ')
  end

  def items=(items)
    Fron::ActiveRecord.diff(@items, items) do |data|
      item = base.new
      item.update! data
      item
    end
    render
  end

  def render
    @items.each do |item|
      @dropdown << item
    end
    render_label
  end

  def items
    @dropdown.children
  end

  def selected
    items.select(&:checked)
  end

  def show_all
    items.each { |item| item.removeClass('hidden') }
  end

  def filter
    return show_all unless @input.value
    regexp = Regexp.new @input.value, 'i'
    items.each do |item|
      item.toggleClass 'hidden', !(item.label =~ regexp)
    end
  end

  def value
    selected.map(&:value)
  end
end
