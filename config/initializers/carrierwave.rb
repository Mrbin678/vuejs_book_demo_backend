# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = Settings.operator
  config.upyun_password = Settings.password
  config.upyun_bucket = Settings.bucket
  config.upyun_bucket_host = Settings.image_domain_name
end
