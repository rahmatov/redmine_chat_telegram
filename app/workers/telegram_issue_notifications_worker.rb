class TelegramIssueNotificationsWorker
  include Sidekiq::Worker
  include IssuesHelper

  TELEGRAM_ISSUE_NOTIFICATIONS_LOG = Logger.new(Rails.root.join('log/chat_telegram', 'telegram-issue-notifications.log'))

  def perform(telegram_id, journal_id)
    I18n.locale = Setting['default_language']

    journal = Journal.find(journal_id)

    chat_name = "chat##{telegram_id.abs}"

    message = if journal.details.any?
                details_to_strings(journal.visible_details, no_html: true).join("\\n")
              else
                ''
              end

    message << "\\n" << journal.notes unless journal.notes.blank?

    message.prepend("\\n====================\\n")
    message.prepend(journal.user.name)

    cmd = "msg #{chat_name} '#{message}'"
    RedmineChatTelegram.run_cli_command(cmd, TELEGRAM_ISSUE_NOTIFICATIONS_LOG)
  rescue ActiveRecord::RecordNotFound => e
    # ignore
  end
end
