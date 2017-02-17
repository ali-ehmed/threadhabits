class UploadPresigner
  def self.presign(prefix, filename = "${filename}", limit = 5.megabyte)
    extname = File.extname(filename)
    filename = "#{SecureRandom.uuid}#{extname}"
    upload_key = Pathname.new(prefix).join(filename).to_s

    obj = S3_BUCKET.object(upload_key)
    params = { acl: 'public-read' }
    params[:content_length] = limit if limit

    {
        presigned_url: obj.presigned_url(:put, params),
        public_url: obj.public_url
    }
  end
end