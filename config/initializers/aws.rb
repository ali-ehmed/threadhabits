S3_ASSET_PATH = "https://s3-us-west-2.amazonaws.com/threadhabits"

Aws.config.update({
    region: 'us-west-2',
    credentials: Aws::Credentials.new("AKIAJK4T2CFKLIWSFR2A", "wlzgitosQ3XfKSkjGfcSaQ5HMJiLhWZe17toaNXa"),
})

S3_BUCKET = Aws::S3::Resource.new.bucket("threadhabits")
