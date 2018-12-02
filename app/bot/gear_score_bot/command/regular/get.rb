class GearScoreBot::Command::Regular::Get < GearScoreBot::Command::Base
  NO_CHAR_MSG = 'Character and Family name is case sensitive, please verify that the name is correct'

  def initialize(event:, args:)
    super
    @_user_id = event.user.id
  end

  def call!
    find_character!

    if @_character.blank?
      NO_CHAR_MSG
    else
      @_channel.send_embed('Character has been retrieved from the database', @_character.to_embed)
    end
  rescue => e
    e.message
  end

  private

  def find_character!
    return if @_character.present?

    if @_raw_data.blank? || @_raw_data.length == 0
      @_character ||= Character.where(discord_id: @_user_id).last
    else
      @_character ||= Character.where(character_name: @_raw_data[0]).or(Character.where(family_name: @_raw_data[0])).last
    end
  end
end