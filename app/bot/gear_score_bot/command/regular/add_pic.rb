class GearScoreBot::Command::Regular::AddPic < GearScoreBot::Command::Base
  def initialize(event:, args:)
    super
    @_user_id = event.user.id
  end

  def call!
    validate_data!

    @_character = find_character!
    @_character.update_attributes!(image_url: @_raw_data[0])
    @_channel.send_embed('Image has been updated', @_character.to_embed)
  rescue GearScoreBot::Command::Base::InvalidData => e
    "failed to update image: #{e.message}"
  rescue => e
    e.message
  end

  private 

  def validate_data!
    data = @_raw_data[0]

    return if data.present? && URI::regexp.match?(data)

    raise GearScoreBot::Command::Base::InvalidData, "invalid URL provided"
  end

  def find_character!
    Character.where(discord_id: @_user_id).last!
  rescue ActiveRecord::RecordNotFound
    raise StandardError, 'user does not have a character in the database'
  end
end