class GearScoreBot::Command::Base
  InvalidData = Class.new(StandardError)

  class << self
    def call!(event:, args:)
      return 'invalid channel' unless valid_channel?(event.channel.id)
      new(event: event, args: args).call!
    end

    def valid_channel?(channel_id)
      GearScoreBot::CHANNEL_ID == channel_id
    end
  end

  def initialize(event:, args:)
    @_raw_data = args
    @_event = event
    @_channel = @_event.channel
  end
end