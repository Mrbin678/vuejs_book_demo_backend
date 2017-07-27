class Tool < ActiveRecord::Base

  def self.upload_image(form_object, image_column)
    require 'upyun'

    bucket = Settings.carrierwave.bucket
    operator = Settings.carrierwave.operator
    password = Settings.carrierwave.password
    Rails.logger.info  "=====form_object====#{form_object}"
    Rails.logger.info  "=====image_column====#{image_column}"
    if form_object.present? and form_object[image_column].present?
      upload_file = form_object[image_column]
      upyun = Upyun::Rest.new(bucket, operator, password)
      new_file_name = form_object[image_column].original_filename

      format_str = new_file_name.split(".")
      new_file_name = "#{rand_file_name(15)}.#{format_str.last}"

      remote_file = "/image/silulegou/#{new_file_name}"
      response = upyun.put remote_file, upload_file.read
      form_object[image_column] = "#{Settings.carrierwave.bucket_host}#{remote_file}"
    end
    form_object
  end

  def self.upload_images(images, parent_id, parent_column, image_model)
    require 'upyun'
    bucket = Settings.carrierwave.bucket
    operator = Settings.carrierwave.operator
    password = Settings.carrierwave.password             #settings 是又拍云账号的配置

    upload_files = images

    images.each do |image|
      upload_file = image
      upyun = Upyun::Rest.new(bucket, operator, password)
      Rails.logger.info "images ==== #{images}"
      Rails.logger.info "image ====== #{image}"
      new_file_name = image.original_filename

      format_str = new_file_name.split(".")
      new_file_name = "#{rand_file_name(15)}.#{format_str.last}"

      remote_file = "/image/silulegou/#{new_file_name}"       #远程保存图片的位置
      response = upyun.put remote_file, upload_file.read
      picture_url = "#{Settings.carrierwave.bucket_host}#{remote_file}"

      Rails.logger.info "picture_url  ===== #{picture_url} ===="
      image_model.create(
          image_url: picture_url,
          "#{parent_column}": parent_id
        )
      Rails.logger.info "picture_url  ===== #{picture_url} ===="

    end
  end

  def self.rand_file_name(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    new_file_name = ""
    (0..len).each do |i|
      new_file_name << chars[rand(chars.size-1)]
    end
    new_file_name
  end

  def self.upload_repaire_images(images, parent_id, parent_column, image_model)
    require 'upyun'
    bucket = Settings.carrierwave.bucket
    operator = Settings.carrierwave.operator
    password = Settings.carrierwave.password             #settings 是又拍云账号的配置

    upload_files = images

    require 'data_uri'
    images.each do |image|
      upload_file = image
      upyun = Upyun::Rest.new(bucket, operator, password)
      Rails.logger.info "images ==== #{images}"
      Rails.logger.info "image ====== #{image}"

      new_file_name = Time.now.strftime('%Y-%m-%d') + rand(10000).to_s + ".jpg"
      remote_file = "/image/queentown/#{new_file_name}"       #远程保存图片的位置
      uri = URI::Data.new(image)
      picture_url = "#{Settings.carrierwave.bucket_host}#{remote_file}"
      Rails.logger.info "picture_url  ===== #{picture_url} ===="
      Rails.logger.info "picture_url  ===== #{picture_url} ===="

      file_on_local_path = "#{Rails.root}/public/uploads/#{new_file_name}"
      File.write(file_on_local_path, uri.data.force_encoding('UTF-8'))
      response = upyun.put remote_file, File.new(file_on_local_path)

      image_model.create(
          avatar: picture_url,
          "#{parent_column}": parent_id
        )
    end
  end

  def self.upload_signature_image(image, staff_id)
    require 'upyun'
    bucket = Settings.carrierwave.bucket
    operator = Settings.carrierwave.operator
    password = Settings.carrierwave.password             #settings 是又拍云账号的配置

    require 'data_uri'
      upload_file = image
      upyun = Upyun::Rest.new(bucket, operator, password)
      Rails.logger.info "image ====== #{image}"

      new_file_name = Time.now.strftime('%Y-%m-%d') + rand(10000).to_s + ".jpg"
      remote_file = "/image/queentown/#{new_file_name}"       #远程保存图片的位置
      uri = URI::Data.new(image)
      picture_url = "#{Settings.carrierwave.bucket_host}#{remote_file}"

      Rails.logger.info "picture_url  ===== #{picture_url} ===="

      file_on_local_path = "#{Rails.root}/public/uploads/#{new_file_name}"
      File.write(file_on_local_path, uri.data.force_encoding('UTF-8'))
      response = upyun.put remote_file, File.new(file_on_local_path)

      SignatureImage.create(
          img_url: picture_url,
          staff_id: staff_id
        )
  end

  def self.upload_xiaochengxu_image(file, image_model, parent_id, parent_column)
    require 'upyun'

    bucket = Settings.carrierwave.bucket
    operator = Settings.carrierwave.operator
    password = Settings.carrierwave.password

    if file.present?
      upload_file = file
      upyun = Upyun::Rest.new(bucket, operator, password)
      new_file_name = file.original_filename

      format_str = new_file_name.split(".")

      remote_file = "/image/queentown/#{new_file_name}"
      response = upyun.put remote_file, upload_file.read
      picture_url = "#{Settings.carrierwave.bucket_host}#{remote_file}"
      image_model.create(
          avatar: picture_url,
          "#{parent_column}": parent_id
        )
    end
  end


end
