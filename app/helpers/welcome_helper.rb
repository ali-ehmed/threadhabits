module WelcomeHelper
  def heading_section(h_size = :h2, title = "")
    content_for(:heading_section) do
      content_tag :div, class: "heading_section" do
        content_tag h_size.to_sym, title
      end
    end
  end

  def person_avatar(person, options = {})
    if person.has_image?(:avatar)
      image_tag person.avatar.url(:medium), class: "img-responsive #{options[:outer_class]}"
    else
      person_alphabetical_avatar(person, options)
    end
  end

  def person_alphabetical_avatar(person, options = {})
    f = person.first_name.upcase.split("")
    l = person.last_name.upcase.split("")
    content_tag :span, class: "img-responsive #{options[:outer_class]} #{options[:inner_class]}" do
      [f[0], l[0]].join
    end
  end

  def person_mobile_view_avatar(person, options = {})
    avatar    = person_avatar(person, options.merge({outer_class: "img-circle #{options[:outer_class]}"}) )
    full_name = content_tag :div, person.full_name, class:  "name"
    username  = content_tag :div, person.tagged_username, class: "username"

    html = %Q{<div class="#{options[:class] || 'person-avatar-thumbnail'}">}

    html += link_to profiles_path(person.username), class: "thumbnail" do
      avatar
    end

    html << (full_name +  username)
    html += %Q{</div>}

    html.html_safe
  end
end
