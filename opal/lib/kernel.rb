module Kernel
  class Debounce
    def initialize(delay, &block)
      @id = nil
      @block = block
      @delay = delay
    end

    def call
      clear_timeout @id
      @id = timeout @delay do
        @block.call
      end
    end
  end

  def confirm(text)
    `confirm(#{text})`
  end

  # Returns the logger for the application
  #
  # @return [Fron::Logger] The logger
  def logger
    @logger ||= Fron::Logger.new
  end

  def clear_timeout(id)
    `clearTimeout(#{id})`
  end
end
