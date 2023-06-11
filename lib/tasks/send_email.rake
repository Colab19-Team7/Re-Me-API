namespace :weekly_task do
    desc 'Send weekly email to all the users'
    task send_mails: :environment do
        puts "email sent"
        User.all.each do |user|
            items = user.items.where("created_at >= ?", Date.today.at_beginning_of_week)

        end
    end
end