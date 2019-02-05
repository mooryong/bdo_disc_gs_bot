class GearScoreBot::Command::Regular::List < GearScoreBot::Command::Base
  NO_CHAR_MSG = 'There are no characters'
  ROWS_PER_PAGE = 12
  MSG_FORMATTER = '```'

  def initialize(event:, args:)
    super
    @_user_id = event.user.id
  end

  def call!
    characters = Character.order('renown_score DESC')

    if characters.exists?
      table = build_table(characters)

      table.each do |page|
        @_channel.send_message(page.join(''))
      end

      nil
    else
      NO_CHAR_MSG
    end
  rescue => e
    e.message
  end

  private

  def build_table(characters)
    table = []

    table << build_header

    characters.each do |character|
      table << build_row(character)
    end

    table.partition.with_index { |_, idx| idx + 1 % 15 != 0}.select { |page| page.present? }.tap do |paginated_table|
      paginated_table.each do |page|
        next if page.blank?
        page.unshift(MSG_FORMATTER)
        page << MSG_FORMATTER
      end
    end
  end

  def build_header
    "#{'Character (Family)'.ljust(30)} #{'AP'.ljust(6)} #{'AWK AP'.ljust(8)} #{'DP'.ljust(6)} #{'Renown'.ljust(9)} #{'Lvl'.ljust(5)} #{'Class'.ljust(14)} Updated At" + "\n" + '-'.ljust(128, '-') + "\n"
  end

  def build_row(character)
    "#{character.full_name.ljust(30)} #{character.preawakening_attack_power.to_s.ljust(6)} #{character.awakening_attack_power.to_s.ljust(8)} #{character.defense_power.to_s.ljust(6)} #{character.renown_score.to_s.ljust(9)} #{character.level.to_s.ljust(5)} #{character.class_name.ljust(14)} #{character.updated_at}" + "\n"
  end
end