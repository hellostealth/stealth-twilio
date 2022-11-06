# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Twilio
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        ALPHA_ORDINALS = ('A'..'Z').to_a.freeze

        attr_reader :recipient_id, :reply, :translated_reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          check_text_length

          @translated_reply = reply['text']

          suggestions = generate_suggestions(suggestions: reply['suggestions'])
          buttons = generate_buttons(buttons: reply['buttons'])

          if suggestions.present?
            @translated_reply = [
              @translated_reply,
              'Reply with:'
            ].join("\n\n")

            suggestions.each_with_index do |suggestion, i|
              @translated_reply = [
                @translated_reply,
                "\"#{ALPHA_ORDINALS[i]}\" for #{suggestion}"
              ].join("\n")
            end
          end

          if buttons.present?
            buttons.each do |button|
              @translated_reply = [
                @translated_reply,
                button
              ].join("\n\n")
            end
          end

          format_response({ body: @translated_reply })
        end

        def image
          check_text_length

          format_response({ body: reply['text'], media_url: reply['image_url'] })
        end

        def audio
          check_text_length

          format_response({ body: reply['text'], media_url: reply['audio_url'] })
        end

        def video
          check_text_length

          format_response({ body: reply['text'], media_url: reply['video_url'] })
        end

        def file
          check_text_length

          format_response({ body: reply['text'], media_url: reply['file_url'] })
        end

        def delay

        end

        private

          def check_text_length
            if reply['text'].present? && reply['text'].size > 1600
              raise(ArgumentError, 'Text messages must be 1600 characters or less.')
            end
          end

          def format_response(response)
            sender_info = {
              from: Stealth.config.twilio.from_phone,
              to: recipient_id
            }
            response.merge(sender_info)
          end

          def generate_suggestions(suggestions:)
            return if suggestions.blank?

            mf = suggestions.collect do |suggestion|
              suggestion['text']
            end.compact
          end

          def generate_buttons(buttons:)
            return if buttons.blank?

            sms_buttons = buttons.map do |button|
              case button['type']
              when 'url'
                "#{button['text']}: #{button['url']}"
              when 'payload'
                "To #{button['text'].downcase}: Text #{button['payload'].upcase}"
              when 'call'
                "#{button['text']}: #{button['phone_number']}"
              else # Don't raise for unsupported buttons
                next
              end
            end.compact

            sms_buttons
          end

      end
    end
  end
end
