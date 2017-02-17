S3_ASSET_PATH = "https://s3-us-west-2.amazonaws.com/threadhabits"
S3_BUCKET = Aws::S3::Resource.new.bucket(ENV["S3_BUCKET"] || "threadhabits")
