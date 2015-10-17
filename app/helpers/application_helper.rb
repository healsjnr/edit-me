module ApplicationHelper
  def full_title(page_title)
    base_title = 'Edit.me'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def current_user_valid(c_user, user_id)
    current_user_id = c_user.id.to_s
    if user_id == current_user_id
      yield
    else
      respond_to do |format|
        format.html { redirect_to root_url, alert: "You cannot access that part of the website." }
        format.xml { head :forbidden }
        format.json { head :forbidden }
      end
    end
  end
end
