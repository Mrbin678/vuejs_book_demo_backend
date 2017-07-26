FactoryGirl.define do  factory :custom_price_category_type do
    name "MyString"
  end
  factory :notification_type do
    name "MyString"
template "MyText"
  end


  factory :customer do
    name '猴子'
    nick_name '二猴子'
    open_id '123345'
  end

  factory :gallery do
    url 'http://pintuanbao.b0.upaiyun.com/image/galleries/slider1.png'
    parent_type 'ad_images'
  end

  factory :product_category do
    name '意外险'
  end

  factory :home_special_category do
    name '拼免费'
  end

  factory :product do
    from_the_number '5'
    description '意外伤害5万元'
    price '0'
    market_price '200'
    tuiguangtongji '每邀请一个新用户奖励奖励3元'
    status 'shangjia'
    name '君龙驾乘意外险'
  end


end
