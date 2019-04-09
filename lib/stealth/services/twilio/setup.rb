# coding: utf-8
# frozen_string_literal: true

require 'stealth/services/twilio/client'

module Stealth
  module Services
    module Twilio

      class Setup

        class << self
          def trigger
            Stealth::Logger.l(
              topic: "twilio",
              message: "There is no setup needed!"
            )
          end
        end

      end

    end
  end
end
