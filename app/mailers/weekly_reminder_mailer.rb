class WeeklyReminderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.weekly_reminder_mailer.send.subject
  #
  def remind
    @user = params[:user]
    @name = @user.fullname.split(' ').first
    @visited = JSON.parse(params[:visited])
    @no_visited = JSON.parse(params[:no_visited])

    mail to: @user.email, subject: 'Reminder time'
  end
end
