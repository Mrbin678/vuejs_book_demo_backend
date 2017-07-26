require 'upyun'
class Tool < ActiveRecord::Base

  # 上传图片
  def self.upload_image(form_object, image_column)
    bucket = Settings.bucket
    operator = Settings.operator
    password = Settings.password
    Rails.logger.info  "=====form_object====#{form_object}"
    Rails.logger.info  "=====image_column====#{image_column}"
    if form_object.present? and form_object[image_column].present?
      upload_file = form_object[image_column]
      upyun = Upyun::Rest.new(bucket, operator, password)
      new_file_name = form_object[image_column].original_filename
      remote_file = "/image/galleries/#{new_file_name}"
      response = upyun.put remote_file, upload_file.read
      form_object[image_column] = "#{Settings.image_domain_name}#{remote_file}"
    end
    form_object
  end

  include HTTParty
  pkcs12 File.read(File.join(Rails.root, 'apiclient_cert.p12')), Settings.wechat.mch_sid

  # 微信用户支付
  def self.user_pay options
    Rails.logger.info "========== 金额是 #{options[:total_fee]} ============"

    WxPay.appid = Settings.wechat.app_id
    WxPay.key = Settings.wechat.key
    WxPay.mch_id = Settings.wechat.mch_bid

    params = {
      :appid => Settings.wechat.app_id,
      :mch_id => Settings.wechat.mch_bid,
      :nonce_str => '5K8264ILTKCH16CQ2502SI' + ('a'..'z').to_a.shuffle[0,10].join,
      :body => Settings.wechat.body,
      :out_trade_no => options[:out_trade_no],
      :total_fee => options[:total_fee],
      :spbill_create_ip => Settings.wechat.spbill_create_ip,
      :notify_url => Settings.wechat.notify_url,
      :trade_type => 'JSAPI',
      :openid => options[:openid] #公众号支付必传
    }

    Rails.logger.info "== params: #{params}"
    Rails.logger.info "=== 分割线 ===="
    r = WxPay::Service.invoke_unifiedorder params
    Rails.logger.info "== user_pay, r: #{r}"

    if r.success? # => true
      params = {
        prepayid: r['prepay_id'],
        noncestr: r['nonce_str']
      }

      # 生成JSAPI支付签名
      result = WxPay::Service.generate_js_pay_req params

      Rails.logger.info "== user_pay generate_pay_sign, result: #{result}"

      if result[:paySign].present?

        #创建订单和未生效保单
        Order.transaction do
          order = Order.new(options[:order])
          order.set_discount_amount
          order.save
          policy = Policy.new(options[:policy])
          policy.order_id = order.id
          policy.product_name = order.product.name
          policy.set_coverage
          policy.save
        end

        return {
          message: '生成支付签名成功',
          appId: result[:appId],
          timeStamp: result[:timeStamp],
          nonceStr: result[:nonceStr],
          package: result[:package],
          signType: result[:signType],
          paySign: result[:paySign]
        }
      else
        return {
          message: '生成支付签名失败'
        }
      end

    else
      return {
        message: '生成prepayid失败',
        return_code: r['return_code'],
      }
    end
  end

  # 微信企业支付
  def self.pay options

    WxPay.appid = Settings.wechat.app_id
    WxPay.key = Settings.wechat.key
    WxPay.mch_id = Settings.wechat.mch_sid

    Rails.logger.info "========== 金额是 #{options[:amount]} ============"

    params = {
      :mch_appid => Settings.wechat.app_id,
      :mchid => Settings.wechat.mch_sid,
      :nonce_str => '5K8264ILTKCH16CQ2502SI' + ('a'..'z').to_a.shuffle[0,10].join,
      :partner_trade_no => options[:partner_trade_no],
      :openid => options[:openid],
      :check_name => 'NO_CHECK',
      :amount => options[:amount],
      :desc => Settings.wechat.desc,
      :spbill_create_ip => Settings.wechat.spbill_create_ip
    }

    xml_body = WxPay::Service.send :make_payload, params
    Rails.logger.info "== xml_body to server: #{xml_body}"
    result = Tool.post Settings.wechat.pay_url, :body => xml_body
    Rails.logger.info "== response from server: #{ result.body.inspect }"

    AccountDetail.transaction do
      customer = Customer.find_by_open_id(options[:openid])
      withdraw_money = options[:amount].to_i / 100
      description = "您成功提现了#{withdraw_money}到您的账户"
      AccountDetail.generate_account_detail_when_withdraw customer,
        withdraw_money,
        description
    end


    return result
  end


  # 生成二维码
  def self.generate_rqrcode url
    Rails.logger.info "==生成二维码=="
    qrcode = RQRCode::QRCode.new( url )
    png = qrcode.as_png(
              resize_gte_to: false,
              resize_exactly_to: false,
              fill: 'white',
              color: 'black',
              size: 400,
              border_modules: 7,
              module_px_size: 3,
              file: nil # path to write
              )
    new_file_name = Time.now.to_i.to_s + rand(10000000).to_s + '.png'
    path = "#{Rails.root}/public/uploads/rqrcode/#{new_file_name}"
    png.save(path)
    #binary_string = png.to_blob
    #Rails.logger.info "== binary_string == #{binary_string.inspect}"

    upyun = Upyun::Rest.new(Settings.bucket, Settings.operator, Settings.password)
    remote_file = "/image/rqrcode/#{new_file_name}"
    upyun_result = upyun.put remote_file, File.new(path)
    url = "#{Settings.image_domain_name}#{remote_file}"
    Rails.logger.info "==生成二维码成功=url=#{url}"

    return url
  end

  # 从微信中上传图片到图库(一次一张)
  def self.generate_claim_pictures parent_id, media_id
    include HTTParty
    $wechat_client ||= WeixinAuthorize::Client.new(Settings.wechat.app_id, Settings.wechat.app_secret)
    access_token = $wechat_client.access_token
    #access_token = "cf2IQ3OnhXT89UyMrGUfKXX1zUqzAkhSv58UEGfLiqcKE8rrpmzLffktUfkWVNWtSGg1Y-d84XUzNoeb8LnmRbfO2hwRqA55594dCVUO-8_qt9b_-sJWAP5aZplc73k5VPKhACAOID"
    #media_id = "MK7MGgxho_plCqom-m0rglRmz2Pg7Ekz8Ehcrlw9ExvDsolL4a9U9we4S25l_4ra"
    url = "#{Settings.wechat_download_image_url}?access_token=#{access_token}&media_id=#{media_id}"
    body = HTTParty.get(url)
    begin
      if body.errcode != nil
        Rails.logger.info "== upload claim pictures error == #{body.inspect}"
      end
    rescue Exception => e
      bucket = Settings.bucket
      operator = Settings.operator
      password = Settings.password
      upload_file = body
      upyun = Upyun::Rest.new(bucket, operator, password)
      new_file_name = Time.now.to_i.to_s + rand(10000000).to_s + '.png'
      remote_file = "/image/galleries/#{new_file_name}"
      response = upyun.put remote_file, upload_file
      url = "#{Settings.image_domain_name}#{remote_file}"
      params = {
        parent_id: parent_id,
        parent_type: 'claim',
        url: url
      }
      Gallery.transaction do
        Gallery.create params
      end
    end
  end


end
