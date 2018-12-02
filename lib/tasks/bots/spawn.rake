namespace :bots do
  task :spawn, [:bot_type] => [:environment] do |_, args|
    Bot.new(type: args[:bot_type]).run!
  end
end