# frozen_string_literal: true

# require_relative "general_actor"

require "timeout"

module ReactorActorM
  ##
  # A shared state actor driven by Ruby Ractors.
  class RactorActor
    ##
    # Internally used RactorMessage with Backchannel
    class RactorMessage
      def initialize(method, obj = nil)
        @obj = Ractor.make_shareable obj, copy: true
        @method = method
        @backchannel = Ractor.new do
          val = Ractor.recv
          Ractor.yield val
        end
      end

      attr_reader :obj, :method, :backchannel
    end

    private_constant :RactorMessage

    def initialize(data)
      @ractor = Ractor.new do
        state = nil
        loop do
          incoming = Ractor.recv
          case incoming.method
          when :get
            incoming.backchannel.send state
          when :set
            state = incoming.obj
            incoming.backchannel.send true
          when :kill
            break
          end
        end
      end

      @ractor.send RactorMessage.new :set, data
      _ = @value
    end

    def value
      m = RactorMessage.new :get
      @ractor.send m
      m.backchannel.take
    end

    def value=(new_value)
      m = RactorMessage.new :set, new_value
      @ractor.send m
      _ = m.backchannel.take
    end

    def get_value_with_timeout(timeout)
      m = RactorMessage.new :get
      @ractor.send m
      val = nil
      Timeout.timeout(timeout) do
        val = m.backchannel.take
      end
      val
    end
  end
end
