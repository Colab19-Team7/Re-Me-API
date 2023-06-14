# Preview all emails at http://localhost:3000/rails/mailers/weekly_reminder_mailer
class WeeklyReminderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/weekly_reminder_mailer/send
  def remind
    user = User.find(2)
    items = user.items.where("created_at >= ?", Date.today.at_beginning_of_week)
    WeeklyReminderMailer.remind(user, items)
  end

end
