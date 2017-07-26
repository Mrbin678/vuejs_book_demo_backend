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
    product_price = ProductPrice.find(params[:product_price_id])
    product = Product.find(params[:product_id])
    if product != product_price.product
      Rails.logger.info "== 并不是当前产品的价格"
      return
    end
    price = product_price.pay_depend_on_role(customer, params[:order_status])
    Rails.logger.info "== 预支付金额 price == #{price}"
    #price = '1'  测试
    order_number = "UserPay-#{Time.now.to_i}"

    policy = Policy.handle_policy_params params[:policy], params[:insure_for_me]
    Rails.logger.info "== policy ==#{policy.inspect}"

    order =  {
            product_id: product.id,
            customer_id: customer.id,
            product_price_id: product_price.id,
            order_status: params[:order_status],
            current_fee: product.fee,
            share_man_id: params[:share_man_id],
            price: price,
            order_number: order_number,
            payment_status: 'not_payed',
            pay_way: 'wechat',
            start_baozhangqixian: product_price.start_baozhangqixian,
            end_baozhangqixian: product_price.end_baozhangqixian
          }

    result = Tool.user_pay({
          # 这里是以分作为单位。 微信企业支付接口是这么要求的。
          :total_fee => (price * 100).to_i , # 支付总金额 不能有小数点(文档要求)
          :openid => customer.open_id, # 用户open_id
          :out_trade_no => order_number, # 订单号，保证唯一
          :order => order,
          :policy => policy
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
            group_buying = GroupBuying.create(status: 'doing',
                               start_time: time,
                               validity: Settings.validity,
                               product_id: @order.product_id,
                               customer_id: @order.customer_id,
                               start_person_number: @order.product.from_the_number,
                               product_price_id: @order.product_price_id
                              )
            @order.update_attributes(:payment_status => 'payed',
                                     :price => payed_price,
                                     :payed_at => time,
                                     :group_buying_id => group_buying.id,
                                     :payed_response => result.to_s
                                    )
            #扣除红包
            @order.customer.change_hongbao @order.discount_amount, 'reduce'

            #参团
            CustomerGroup.create(customer_id: @order.customer_id,
                                 group_buying_id: group_buying.id,
                                 share_man_id: @order.share_man_id,
                                 order_id: @order.id
                                )
          else
            #参团或者单独购买
            @order.update_attributes(:payment_status => 'payed',
                                     :price => payed_price,
                                     :payed_at => time,
                                     :payed_response => result.to_s
                                    )
            #单独购买就不参团了
            if @order.order_status == 'group'
              CustomerGroup.create(customer_id: @order.customer_id,
                                   group_buying_id: @order.group_buying_id,
                                   share_man_id: @order.share_man_id,
                                   order_id: @order.id
                                  )
            end
          end
          AccountDetail.create operation: 'zhifucaozuo',
            order_id: @order.id,
            description: "您成功支付了#{payed_price}元",
            in_amount: payed_price,
            account_id: @order.customer_id
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
