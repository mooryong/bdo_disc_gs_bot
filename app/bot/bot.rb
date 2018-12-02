class Bot
  module Type
    GEAR_SCORE = 'gear_score'
  end

  COMMAND_PREFIX = '!'

  def initialize(type:)
    @_type = type
    @_bot = instantiate_bot
  end

  def run!
    @_bot.run!
  end

  private

  def instantiate_bot
    case @_type
    when Type::GEAR_SCORE
      GearScoreBot.new
    else
      raise 'Error'
    end
  end
end