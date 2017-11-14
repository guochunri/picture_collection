CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
    :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
    :region                 => 'ap-southeast-2' # Sydney
  }

  config.fog_directory  = ENV["BUCKET_NAME"]
  config.ignore_processing_errors = true
end
