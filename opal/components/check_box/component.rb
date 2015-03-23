# Check Box
class CheckBox < Fron::Component
  extend Forwardable

  tag 'check-box'

  def_delegators :@input, :checked, :checked=

  component :input, 'input[type=checkbox]'
  component :label, 'label' do
    component :icon, 'i.fa.fa-check'
  end

  on :change, :render

  # Initializes the check box
  def initialize
    super
    id = `Math.uuid(5)`
    @input[:id]   = id
    @input[:name] = id
    @label[:for]  = id
  end

  # Renders the check box
  def render
    self[:checked] = @input.checked
  end
end
