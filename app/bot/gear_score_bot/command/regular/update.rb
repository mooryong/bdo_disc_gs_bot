class GearScoreBot::Command::Regular::Update < GearScoreBot::Command::Base
  NO_CHAR_MSG = 'User does not have any characters'

  ARG_INDEX_MAP = {
    family_name: 0,
    character_name: 1,
    preawakening_ap: 2,
    awakening_ap: 3,
    dp: 4,
    level: 5,
    class: 6,
    image_url: 7
  } 

  MIN_RAW_DATA_LENGTH = 7
  MAX_RAW_DATA_LENGTH = 8
  MIN_NAME_LENGTH = 3
  MAX_NAME_LENGTH = 16
  MIN_NUMERIC_VALUE = 0
  MAX_NUMERIC_VALUE = 999

  def initialize(event:, args:)
    super
    @_user_id = event.user.id
  end

  def call!
    validate_data!
    format_data!

    find_character!

    if @_character.blank?
      NO_CHAR_MSG
    else
      update_character!
      @_channel.send_embed('Character has been updated', @_character.to_embed)
    end
  rescue GearScoreBot::Command::Base::InvalidData => e
    "failed to update character: #{e.message}"
  rescue => e
    e.message
  end

  private

  def find_character!
    @_character ||= Character.where(discord_id: @_user_id).last
  end

  def update_character!
    @_character.update_attributes!(@_formatted_data)
  end

  def format_data!
    @_formatted_data ||= {
      family_name: @_raw_data[ARG_INDEX_MAP[:family_name]],
      character_name: @_raw_data[ARG_INDEX_MAP[:character_name]],
      preawakening_attack_power: @_raw_data[ARG_INDEX_MAP[:preawakening_ap]],
      awakening_attack_power: @_raw_data[ARG_INDEX_MAP[:awakening_ap]],
      defense_power: @_raw_data[ARG_INDEX_MAP[:dp]],
      level: @_raw_data[ARG_INDEX_MAP[:level]],
      class_name: @_raw_data[ARG_INDEX_MAP[:class]]
    }.tap do |data|
      data.merge!({ image_url: @_raw_data[ARG_INDEX_MAP[:image_url]] }) if @_raw_data[ARG_INDEX_MAP[:image_url]].present?
    end
  end

  def validate_data!
    validate_raw_data!
    validate_family_name!
    validate_character_name!
    validate_preawakening_ap!
    validate_awakening_ap!
    validate_dp!
    validate_level!
    validate_class!
    validate_image_url!
  end

  def validate_raw_data!
    if @_raw_data.blank?
      raise GearScoreBot::Command::Base::InvalidData, 'arguments cannot be blank'
    elsif !@_raw_data.is_a?(Array)
      raise GearScoreBot::Command::Base::InvalidData, "arguments invalid type, expected Array but received #{@_raw_data.class}"
    elsif @_raw_data.length < MIN_RAW_DATA_LENGTH || @_raw_data.length > MAX_RAW_DATA_LENGTH
      raise GearScoreBot::Command::Base::InvalidData, "incorrect number of arguments"
    end
  end

  def validate_family_name!
    data = @_raw_data[ARG_INDEX_MAP[:family_name]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "family_name is missing"
    elsif data.length < MIN_NAME_LENGTH && data.length > MAX_NAME_LENGTH
      raise GearScoreBot::Command::Base::InvalidData, "family_name cannot be shorter than #{MIN_NAME_LENGTH} characters and longer than #{MAX_NAME_LENGTH} characters"
    end
  end

  def validate_character_name!
    data = @_raw_data[ARG_INDEX_MAP[:character_name]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "character_name is missing"
    elsif data.length < MIN_NAME_LENGTH && data.length > MAX_NAME_LENGTH
      raise GearScoreBot::Command::Base::InvalidData, "character_name cannot be shorter than #{MIN_NAME_LENGTH} characters and longer than #{MAX_NAME_LENGTH} characters"
    end
  end

  def validate_preawakening_ap!
    data = @_raw_data[ARG_INDEX_MAP[:preawakening_ap]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "preawakening_ap is missing"
    elsif data.to_i < MIN_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "preawakening_ap cannot be negative"
    elsif data.to_i > MAX_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "preawakening_ap cannot be greater than #{MAX_NUMERIC_VALUE}"
    end
  end

  def validate_awakening_ap!
    data = @_raw_data[ARG_INDEX_MAP[:awakening_ap]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "awakening_ap is missing"
    elsif data.to_i < MIN_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "awakening_ap cannot be negative"
    elsif data.to_i > MAX_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "awakening_ap cannot be greater than #{MAX_NUMERIC_VALUE}"
    end
  end

  def validate_dp!
    data = @_raw_data[ARG_INDEX_MAP[:dp]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "dp is missing"
    elsif data.to_i < MIN_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "dp cannot be negative"
    elsif data.to_i > MAX_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "dp cannot be greater than #{MAX_NUMERIC_VALUE}"
    end
  end

  def validate_level!
    data = @_raw_data[ARG_INDEX_MAP[:level]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "level is missing"
    elsif data.to_f < MIN_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "level cannot be negative"
    elsif data.to_f > MAX_NUMERIC_VALUE
      raise GearScoreBot::Command::Base::InvalidData, "level cannot be greater than #{MAX_NUMERIC_VALUE}"
    end
  end

  def validate_class!
    data = @_raw_data[ARG_INDEX_MAP[:class]]

    if data.blank?
      raise GearScoreBot::Command::Base::InvalidData, "class is missing"
    elsif !Character::Class::AVAILABLE.include?(data.downcase)
      raise GearScoreBot::Command::Base::InvalidData, "invalid class provided"
    end
  end

  def validate_image_url!
    data = @_raw_data[ARG_INDEX_MAP[:image_url]]

    return if data.blank? || URI::regexp.match?(data)

    raise GearScoreBot::Command::Base::InvalidData, "invalid URL provided" 
  end
end