module MapsHelper
  def include_google_map(options = {})
    javascript_include_tag google_api(options)
  end

  def google_api(options = {})
    api = [Threadhabits::Application.secrets.google_map_api_url, Threadhabits::Application.secrets.google_api_key]
    if options[:places]
      api << places_library
    end

    api.join
  end

  # Place Autocomplete search
  def places_library
    "&libraries=places"
  end
end
