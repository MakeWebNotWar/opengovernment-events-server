class CommentObserver < Mongoid::Observer
  def after_save(comment)
    if comment.event?
      notification = Notification.new
      notification.text = "Your event \"#{comment.event.name}\" has a new comment by: #{comment.user.firstname} #{comment.user.lastname}."
      user = comment.event.user

      user.notifications.push(notification)
      user.save
    end
  end

end