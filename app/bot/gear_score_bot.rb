require 'discordrb'

class GearScoreBot
  CHANNEL_ID = DISCORD_CONFIG[:channel_id]
  def initialize
    @_bot = Discordrb::Commands::CommandBot.new(token: DISCORD_CONFIG[:bot_token], prefix: Bot::COMMAND_PREFIX)

    define_commands!
  end

  def run!
    @_bot.run
  end

  private
  
  attr_reader :_bot

  def define_commands!
    define_regular_commands!
    define_admin_commands!
  end

  def define_regular_commands!
    _bot.command :add do |event, *args|
      GearScoreBot::Command::Regular::Add.call!(event: event, args: args)
    end

    _bot.command :add_pic do |event, *args|
      GearScoreBot::Command::Regular::AddPic.call!(event: event, args: args)
    end

    _bot.command :get do |event, *args|
      GearScoreBot::Command::Regular::Get.call!(event: event, args: args)
    end

    _bot.command :remove do |event|
      GearScoreBot::Command::Regular::Remove.call!(event: event, args: nil)
    end

    _bot.command :update do |event, *args|
      GearScoreBot::Command::Regular::Update.call!(event: event, args: args)
    end

    _bot.command :list do |event, *args|
      GearScoreBot::Command::Regular::List.call!(event: event, args: args)
    end
  end

  def define_admin_commands!
    _bot.command :add_m do |event, *args|

    end

    _bot.command :update_m do |event, *args|

    end

    _bot.command :remove_m do |event, *args|

    end
  end

  def valid_channel?(event)
    event.channel.id == @_channel_id
  end
end