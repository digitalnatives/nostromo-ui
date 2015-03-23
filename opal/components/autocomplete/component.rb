class AutoComplete < Fron::Component
  class << self
    def source(block)
      return @source if @source
      @source = block
    end

    def base(klass)
      return @base if @base
      @base = klass
    end
  end

  extend Forwardable

  def_delegators :class, :source, :base
  def_delegators :input, :focus, :blur, :value=

  tag 'auto-complete'

  component :input, 'input[placeholder=Add Member]'
  component :dropdown, 'auto-complete-dropdown'

  on :keyup,     :keyup
  on :keydown,   :keydown
  on :mousedown, :click_select
  on :select,    :on_select

  def initialize
    super
    @input.on(:blur) do
      break if findAll(':hover').map(&:tag).include?(:item)
      clear
    end

    @source = Debounce.new(300) do
      unless value
        clear
        break
      end
      source.call value do |records|
        clear
        records.each do |data|
          item = base.new
          item.update! data
          @dropdown << item
        end
      end
    end
  end

  def on_select(event)
    event.stopPropagation unless event.target.respond_to? :data
  end

  def clear
    @dropdown.empty
  end

  def value
    input.value || nil
  end

  def select_next
    select_with :first, :next
  end

  def select_previous
    select_with :last, :previous
  end

  def select_with(tail, method)
    return select dropdown.children.send(tail) if !selected || !selected.send(method)
    select selected.send(method)
  end

  def click_select
    return unless findAll(':hover').map(&:tag).include?(:item)
    findAll(':hover').find { |item| item.tag == :item }.trigger :select
    clear
  end

  def selected
    dropdown.find('.selected')
  end

  def select(item)
    selected.removeClass('selected') if selected
    return unless item
    item.addClass('selected')
  end

  def keydown(event)
    event.preventDefault if [13, 38, 40].include?(event.keyCode)
    case event.keyCode
    when 13
      selected.trigger :select if selected
    when 38
      select_previous
    when 40
      select_next
    end
  end

  def keyup(event)
    return clear if !value || value.length < 2
    return event.preventDefault if [13, 37, 38, 39, 40].include?(event.keyCode)
    @source.call
  end
end
