# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Twilio

      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          check_text_length

          format_response({ body: reply['text'] })
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
              raise(ArgumentError, "Text messages must be 1600 characters or less.")
            end
          end

          def format_response(response)
            sender_info = { from: Stealth.config.twilio.from_phone, to: recipient_id }
            response.merge(sender_info)
          end

      end

    end
  end
end
