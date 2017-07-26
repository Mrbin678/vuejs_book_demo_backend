# -*- encoding : utf-8 -*-
module ApplicationHelper
  # 分页
  def pagination(records)
    render '/layouts/pagination', records: records
  end

  def show_product_status(m)
    if m == 'shangjia'
      %(
        <span class="label label-success">上架中</span>
      ).html_safe
    else
      %(
        <span class="label label-danger">已下架</span>

      ).html_safe
    end
  end

  def show_order_status(m)
    if m == 'payed'
      %(
        <span class="label label-success">已支付</span>
      ).html_safe
    else
      %(
        <span class="label label-danger">未支付</span>

      ).html_safe
    end
  end

end
