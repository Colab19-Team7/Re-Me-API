namespace :weekly_task do
    desc 'Send weekly email to all the users'
    task send_mails: :environment do
        User.all.each do |user|
            items = user.items.where("created_at >= ?", Date.today.at_beginning_of_week)

            if items.any?
                visited = Item.get_visited_items(user).where("created_at >= ?", Date.today.at_beginning_of_week).to_json
                no_visited = Item.get_no_visited_items(user).where("created_at >= ?", Date.today.at_beginning_of_week).to_json
                WeeklyReminderMailer.with(user: user, visited: visited, no_visited: no_visited).remind.deliver_now
                puts "Email sent to #{user.fullname}"
            end
        end
    end
end