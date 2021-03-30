# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Twilio
      class MessageHandler < Stealth::Services::BaseMessageHandler
        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          Stealth::Services::HandleMessageJob.perform_async(
            'twilio',
            params,
            headers
          )

          # Relay our acceptance
          [204, 'No Content']
        end

        def process
          @service_message = ServiceMessage.new(service: 'twilio')
          service_message.sender_id = params['From']
          service_message.target_id = params['To']
          service_message.message = params['Body']
          service_message.location = { latitude: params['Latitude'], longitude: params['Longitude'] }

          # Check for media attachments
          attachment_count = params['NumMedia'].to_i

          attachment_count.times do |i|
            service_message.attachments << {
              type: params["MediaContentType#{i}"],
              url: params["MediaUrl#{i}"]
            }
          end

          service_message
        end

      end

    end
  end
end
