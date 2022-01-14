# frozen_string_literal: true

require_relative "general_actor/version"
require_relative "ractor_actor"

##
# Module containing the ReactorActor and the general Actor.
module GeneralActor
  class Error < StandardError; end
  include ReactorActorM

  ##
  # This class represents the general implementation of an actor
  class Actor
    ##
    # Initializes a new actor
    def initialize(_obj)
      raise "Just a template actor, use the implementations instead!"
    end

    ##
    # Kill the actor
    def kill; end

    ##
    # Get the value of the object stored in the actor
    def value; end

    ##
    # Set the value of the object stored in the actor
    def value=(value); end

    def get_value_with_timeout(timeout); end
  end
end
