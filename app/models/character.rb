# frozen_string_literal: true
require 'discordrb/webhooks'

class Character < ActiveRecord::Base
  module Class
    ARCHER = 'archer'
    BERSERKER = 'berserker'
    DARK_KNIGHT = 'dark knight'
    KUNOICHI = 'kunoichi'
    LAHN = 'lahn'
    MAEHWA = 'maehwa'
    MUSA = 'musa'
    MYSTIC = 'mystic'
    NINJA = 'ninja'
    RANGER = 'ranger'
    SORCERESS = 'sorceress'
    STRIKER = 'striker'
    TAMER = 'tamer'
    VALKYRIE = 'valkyrie'
    WARRIOR = 'warrior'
    WITCH = 'witch'
    WIZARD = 'wizard'

    AVAILABLE = [
      ARCHER,
      BERSERKER,
      DARK_KNIGHT,
      KUNOICHI,
      LAHN,
      MAEHWA,
      MUSA,
      MYSTIC,
      NINJA,
      RANGER,
      SORCERESS,
      STRIKER,
      TAMER,
      VALKYRIE,
      WARRIOR,
      WITCH,
      WIZARD
    ]
  end

  DEFAULT_IMAGE_URL = 'https://ih1.redbubble.net/image.310165849.4415/flat,550x550,075,f.u1.jpg'

  belongs_to :user, foreign_key: :discord_id, primary_key: :discord_id, optional: true

  before_validation :set_renown_score

  def to_embed
    {
      description: "#{character_name} (#{family_name})",
      timestamp: updated_at,
      image: {
        url: image_url || DEFAULT_IMAGE_URL
      },
      fields: [
        {
          name: 'Level',
          value: level.to_s,
          inline: true
        },
        {
          name: 'Class',
          value: class_name.capitalize,
          inline: true
        },
        {
          name: 'Pre-AP',
          value: preawakening_attack_power.to_s,
          inline: true
        },
        {
          name: 'Awk-AP',
          value: awakening_attack_power.to_s,
          inline: true
        },
        {
          name: 'DP',
          value: defense_power.to_s,
          inline: true
        },
        {
          name: 'Renown Score',
          value: renown_score.to_s,
          inline: true
        }
      ]
    }
  end

  private

  def set_renown_score
    self.renown_score = ((preawakening_attack_power + awakening_attack_power) / 2) + defense_power
  end
end