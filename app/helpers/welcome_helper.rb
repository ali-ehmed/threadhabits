module WelcomeHelper
  def heading_section(h_size = :h2, title = "")
    content_for(:heading_section) do
      content_tag :div, class: "heading_section" do
        content_tag h_size.to_sym, title
      end
    end
  end
end
