module ApplicationHelper
  def title(page_title = nil)
    content_for(:title){ page_title }
    page_title
  end

  def flash_alert_type(name)
    case name.to_s
    when "notice"
      "success"
    when "warning"
      "warning"
    when "info"
      "info"
    else
      "danger"
    end
  end

  def validation_errors_notifications(object)
    return '' if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
      <div class="alert alert-danger alert-block validation-errors"> <button type="button"
      class="close" data-dismiss="alert">x</button>
      #{messages}
      </div>
    HTML

    html.html_safe
  end

  def active_list?(list_name)
    current = [params[:controller].split("/").last, params[:action]]
    if current.include?(list_name)
      true
    else
      false
    end
  end
end
