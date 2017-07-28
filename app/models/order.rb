class Order < ActiveRecord::Base
  has_many :buy_goods

  #生成下一个六位号码
  #  #默认从000001开始
  def gener_number(number)
    number.succ
  end

  #当前时间(年月日)
  def gener_date(date=Time.now().strftime("%Y%m%d"))
    date
  end

  def generate_order_id
    last_order_id = Order.last.order_id rescue ''

    init_id = "#{gener_date}#{gener_number('000000')}"

    if last_order_id.present? and last_order_id[0..7] == gener_date
      self.order_id = last_order_id.succ
    else
      self.order_id = init_id
    end
  end

  def order_status_text
    case self.order_status
    when false
      '未支付'
    when true
      '已支付'
    end
  end

  def self.order_status_list
    [ 'yixiadan', 'yizhifu']
  end

end
