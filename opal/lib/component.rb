module DOM
  class Event
    def position
      Core::Point.new pageX, pageY
    end
  end

  class Element
    def []=(name, value)
      if value
        `#{@el}.setAttribute(#{name},#{value})`
      else
        `#{@el}.removeAttribute(#{name})`
      end
    end

    def readonly=(value)
      self[:readonly] = value ? true : nil
    end

    def value
      `#{@el}.value || Opal.NIL`
    end

    # Blurs the element
    def blur
      `#{@el}.blur()`
    end

    def show
      @style.display = ''
    end

    def previous
      value = `#{@el}.previousElementSibling || false`
      value ? DOM::Element.fromNode(value) : nil
    end

    # Returns whether or not the given node
    # is inside the node.
    #
    # @param other [DOM::NODE] The other node
    #
    # @return [Boolean] True if contains false if not
    def include?(other)
      `#{@el}.contains(#{DOM::NODE.getElement(other)})`
    end
  end
end
