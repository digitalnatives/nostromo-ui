# Progress Bar
class ProgressBar < Fron::Component
  tag 'div.progress'

  component :bar, 'div.progress-bar'

  # Initializes the components
  #
  # @param percent [Number] The starting percentage
  def initialize(percent)
    super nil
    set percent
  end

  # Sets the percentage
  #
  # @param percent [Number] The percentage
  def set(percent = 0)
    @bar.style.width = "#{percent}%"
    @bar.text = "#{percent}%"
    percent = 0 unless percent
    @bar.toggleClass 'progress-bar-success', percent <= 100 && percent >= 60
    @bar.toggleClass 'progress-bar-30-to-60', percent > 30 && percent < 60
  end
end
