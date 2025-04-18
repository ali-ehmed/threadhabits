S3_ASSET_PATH = "https://s3-us-west-2.amazonaws.com/threadhabits"

Aws.config.update({
    region: 'us-west-2',
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
