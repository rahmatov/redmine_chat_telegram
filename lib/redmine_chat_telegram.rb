require 'eventmachine'
require 'telegram'

class RedmineChatTelegram
  def first
    cli_base = '/usr/bin/telegram-cli -W -k /etc/telegram-cli/server.pub -e '


    subject = "Название проекта #114117"

    puts %x(#{cli_base} "create_group_chat \\"#{subject}\\" SouthbridgeBot" )

    cmd = "#{cli_base} \"export_chat_link #{subject.gsub(' ', '_').gsub('#', '@')}\""
    result = %x(#{cmd} )
    telegram_url = result.match(/https:\/\/telegram.me\/joinchat\/\w+/).to_s



  end

end