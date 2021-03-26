module Stealth
  module Services
    module Twilio
      class TwilioServiceMessage < Stealth::ServiceMessage
        attr_accessor :display_name

        def initialize(service:)
          @service = service
          @display_name = display_name
        end
      end
    end
  end
end
