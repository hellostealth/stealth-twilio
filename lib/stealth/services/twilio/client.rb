# coding: utf-8
# frozen_string_literal: true

require 'twilio-ruby'

require 'stealth/services/twilio/message_handler'
require 'stealth/services/twilio/reply_handler'
require 'stealth/services/twilio/setup'

module Stealth
  module Services
    module Twilio

      class Client < Stealth::Services::BaseClient

        attr_reader :twilio_client, :reply

        def initialize(reply:)
          @reply = reply
          account_sid = Stealth.config.twilio.account_sid
          auth_token = Stealth.config.twilio.auth_token
          @twilio_client = ::Twilio::REST::Client.new(account_sid, auth_token)
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?

          response = twilio_client.messages.create(reply)
          Stealth::Logger.l(topic: "twilio", message: "Transmitting. Response: #{response.status}: #{response.error_message}")
        end

      end

    end
  end
end
