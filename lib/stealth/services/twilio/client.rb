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
          api_key = Stealth.config.twilio.api_key
          auth_token = Stealth.config.twilio.auth_token

          if api_key.present?
            @twilio_client = ::Twilio::REST::Client.new(
              api_key, auth_token, account_sid
            )
          else
            @twilio_client = ::Twilio::REST::Client.new(account_sid, auth_token)
          end
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?

          begin
            response = twilio_client.messages.create(**reply)
          rescue ::Twilio::REST::RestError => e
            case e.message
            when /21610/ # Attempt to send to unsubscribed recipient
              raise Stealth::Errors::UserOptOut
            when /21211/ # Invalid 'To' Phone Number
              raise Stealth::Errors::InvalidSessionID
            when /21612/ # 'To' phone number is not currently reachable via SMS
              raise Stealth::Errors::InvalidSessionID
            when /21614/ # 'To' number is not a valid mobile number
              raise Stealth::Errors::InvalidSessionID
            when /30003/ # Unreachable destination handset
              raise Stealth::Errors::InvalidSessionID
            when /30004/ # Message Blocked
              raise Stealth::Errors::MessageFiltered
            when /30005/ # Unknown destination handset
              raise Stealth::Errors::InvalidSessionID
            when /30006/ # Landline or unreachable carrier
              raise Stealth::Errors::InvalidSessionID
            when /30007/ # Message filtered
              raise Stealth::Errors::MessageFiltered
            when /30008/ # Unknown error 🤷‍♂️
              raise Stealth::Errors::UnknownServiceError
            else
              raise
            end
          end

          Stealth::Logger.l(
            topic: "twilio",
            message: "Transmitting. Response: #{response.status}: #{response.error_message}"
          )
        end

      end
    end
  end
end
