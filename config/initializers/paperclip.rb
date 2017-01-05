# default URL structure
Paperclip::Attachment.default_options[:url] = '/threadhabits/profile-icon.png'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'

# Try setting the specified endpoint with the s3_host_name
# Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'
