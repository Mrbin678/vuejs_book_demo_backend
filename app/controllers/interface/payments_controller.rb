# -*- encoding : utf-8 -*-
class Interface::PaymentsController < Interface::ApplicationController
  # 企业支付
  # /interface/payments/pay?
  def pay
    request_id = rand(1000).to_s
    begin_time = Time.now.to_f
    Rails.logger.info "==== 企业支付了一笔钱 ===="
    Rails.logger.info "== request_id: #{request_id}, request begin at: #{begin_time}"

    response = Tool.pay({
          # 这里是以分作为单位。 微信企业支付接口是这么要求的。
          :amount => '101', # 企业支付每次必须大于1元 钱数
          :openid => 'o1GmjwVarmzOwWmn5J2KvCW9juMs', # 用户open_id
          :partner_trade_no => "CompanyPay#{Time.now.to_i}" # 订单号，保证唯一 必须是33位以下的数字和字母组合
        })

    render :text => response.body

    Rails.logger.info "== request_id: #{request_id}, request after at: #{Time.now.to_f - begin_time}"
  end

  # 用户支付
  # /interface/payments/user_pay?
  def user_pay
    request_id = rand(1000).to_s
    begin_time = Time.now.to_f
    Rails.logger.info "==== 用户支付了一笔钱 ===="
    Rails.logger.info "== request_id: #{request_id}, request begin at: #{begin_time}"

    customer = Customer.find_by_open_id(params[:open_id])

    Rails.logger.info "== 预支付金额 price == #{price}"
    #price = '1'  测试

    result = Tool.user_pay({
          # 这里是以分作为单位。 微信企业支付接口是这么要求的。
          :total_fee => (params[:total_cost] * 100).to_i , # 支付总金额 不能有小数点(文档要求)
          :openid => customer.open_id, # 用户open_id
          :out_trade_no => order_number, # 订单号，保证唯一
          })

    render :json => result

    Rails.logger.info "== result === #{result}"
    Rails.logger.info "== request_id: #{request_id}, request after at: #{Time.now.to_f - begin_time}"
  end

  # 微信支付成功后调用
  def notify
    Rails.logger.info "=============== 微信支付成功回调 =============="
    logger.info "== notify from weixin server: "
    logger.info params.inspect
    logger.info "== notify from weixin server( done ) : "

    # 请求是由 微信服务器 发送过来.
		result = Hash.from_xml(request.body.read)["xml"]

    Rails.logger.info "== notify result: #{result}"

		if WxPay::Sign.verify?(result)
      order_number = result["out_trade_no"].to_s
      logger.info "==  success result == #{result.inspect}"
      logger.info "==  sign verified"
      Rails.logger.info "== order_no: #{result["out_trade_no"]}-------"
			@order = Order.find_by_order_number(order_number)
      logger.info "==  #{@order.inspect} order !!!!!----"
			unless @order.blank?
        logger.info "==  order is not blank !!!!!----"
        time = Time.now.to_datetime
        payed_price = result["total_fee"].to_f / 100.0
        Order.transaction do
          if @order.group_buying_id.blank? and @order.order_status == 'group'
            #创建团
            @order.update_attributes(:payment_status => 'payed',
                                     :price => payed_price,
                                     :payed_at => time,
                                     :group_buying_id => group_buying.id,
                                     :payed_response => result.to_s
                                    )
          end
        end
			end
			render :xml => { return_code: "SUCCESS" }.to_xml(root: 'xml', dasherize: false)
		else
      logger.info "==  error result == #{result.inspect}"
      logger.error "==  sign NOT verified"
			render :xml => { return_code: "FAIL", return_msg: "" }.to_xml(root: 'xml', dasherize: false)
		end
  end


end
