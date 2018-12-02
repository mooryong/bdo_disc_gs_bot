class GearScoreBot::Command::Regular::Remove < GearScoreBot::Command::Base
  NO_CHAR_MSG = 'User does not have any characters'

  def initialize(event:, args:)
    super
    @_user_id = event.user.id
  end

  def call!
    find_character!
    delete_character!

    if @_character.blank?
      NO_CHAR_MSG
    else
      @_channel.send_embed('Character has been removed from the database', @_character.to_embed)
    end
  rescue => e
    e.message
  end

  private

  def find_character!
    @_character ||= Character.where(discord_id: @_user_id).last
  end

  def delete_character!
    @_character.delete
  end
end