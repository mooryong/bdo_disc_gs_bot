require 'yaml'

DISCORD_CONFIG = YAML.safe_load(ERB.new(File.read("#{Rails.root}/config/discord.yml")).result).with_indifferent_access[Rails.env]