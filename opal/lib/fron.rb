# rubocop:disable MethodName, CyclomaticComplexity, RescueException

class Array
  def reverse_each_with_index(&block)
    (0...length).reverse_each do |i|
      block.call self[i], i
    end
  end
end

class Hash
  def difference(other)
    Hash[to_a - other.to_a]
  end
  alias_method :-, :difference
end

module Fron
  class Component
    def self.create(tag)
      klass = Class.new self
      klass.tag tag
      klass
    end
  end

  class Request
    extend Eventable

    def request(method = 'GET', data = nil, &callback)
      if readyState == 0 || readyState == 4
        @callback = callback
        if method.upcase == 'UPLOAD'
          `#{@request}.open('POST',#{@url})`
          `#{@request}.withCredentials = true`
          `#{@request}.send(#{data.toFormData})`
        elsif method.upcase == 'GET' && data
          `#{@request}.open(#{method},#{@url + '?' + data.toQueryString})`
          `#{@request}.withCredentials = true`
          setHeaders
          `#{@request}.send()`
        else
          `#{@request}.open(#{method},#{@url})`
          `#{@request}.withCredentials = true`
          setHeaders
          `#{@request}.send(#{data.to_json if data})`
        end
        self.class.trigger 'loading'
      else
        fail 'The request is already running!'
      end
    end

    def handleStateChange
      return unless readyState == 4
      begin
        response = Response.new `#{@request}.status`, `#{@request}.response`, `#{@request}.getAllResponseHeaders()`
        @callback.call response if @callback
      ensure
        self.class.trigger 'loaded'
      end
    end
  end

  module ActiveRecord
    class Manager
      extend Fron::Eventable

      def request(method, url, params = {})
        req = Fron::Request.new "#{self.class.endpoint}#{@path}#{url}", 'Content-Type' => 'application/json'
        req.request method.upcase, params do |response|
          if (200..300).cover?(response.status)
            yield response.json
          else
            self.class.trigger :error, response.json['error']
            `console.warn(#{response.json['error']})`
          end
        end
      end
    end

    def self.diff(models, data, &block)
      # Get IDS
      new_ids = data.map   { |item| item[:id] }
      old_ids = models.map { |model| model.data[:id] }

      # Delete old models
      models.each { |model| model.remove! unless new_ids.include?(model.data[:id]) }
      models.delete_if { |model| !new_ids.include?(model.data[:id]) }

      # Update exsisting models
      models.each do |model|
        model.update! data.find { |item| item[:id] == model.data[:id] }
      end

      # Create new items
      new_items = data.delete_if { |item| old_ids.include?(item[:id]) }
      new_items.each do |item|
        models << block.call(item)
      end
    end

    class Record < Fron::Component
      def update!(data)
        @data = data
        render if respond_to? :render
      end

      class List < Fron::Component
        def where(params)
          manager.where(params) do |records|
            yield records
          end
        end

        def update!(records)
          ActiveRecord.diff(@items, records) { |data| create_item(data) }
          render if respond_to? :render
          yield if block_given?
        end

        def update(params = {})
          where(params) do |records|
            yield if block_given?
          end
        end
      end
    end
  end
end
