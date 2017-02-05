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
      image_tag @listing.person.avatar.url(:medium), class: "img-responsive"
    else
      person_alphabetical_avatar(person, options)
    end
  end

  def person_alphabetical_avatar(person, options = {})
    f = person.first_name.upcase.split("")
    l = person.last_name.upcase.split("")
    content_tag :span, class: "img-responsive #{options[:class]}" do
      [f[0], l[0]].join
    end
  end
end
