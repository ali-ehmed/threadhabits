module ListingsHelper
  def listing_raw_images(listing)
    uploads = listing.uploads
    images = uploads.map(&:image).map{|v| image_tag v.url(:medium), style: "width: auto;height: 160px;" }
    images_config = []
    uploads.map do |v|
      images_config << {
        'type': "image", 'caption': v.image_file_name, 'size': v.image_file_size, 'upload_id': v.id
      }
    end

    [raw(images), raw(JSON.parse(images_config.to_json).map{|v| v.to_json.gsub("=>", ":")})]
  end
end
