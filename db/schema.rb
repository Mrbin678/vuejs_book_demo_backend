# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170307110240) do

  create_table "abouts", force: true, comment: "关于我们" do |t|
    t.string   "title",      comment: "标题"
    t.text     "content",    comment: "内容"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "account_details", force: true, comment: "账户交易明细表" do |t|
    t.integer  "account_id",              comment: "对应账户表(收入表)"
    t.datetime "time",                    comment: "交易发生时间"
    t.string   "operation",               comment: "事宜"
    t.float    "in_amount",    limit: 24, comment: "入账金额"
    t.string   "cash_account",            comment: "提现账户"
    t.string   "balance",                 comment: "余额"
    t.float    "total_income", limit: 24, comment: "累计收入"
    t.integer  "product_id",              comment: "对应产品"
    t.text     "description",             comment: "交易明细描述"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "hongbao",      limit: 24, comment: "红包金额：为operation收红包和使用红包使用"
    t.integer  "order_id",                comment: "订单的外键"
  end

  create_table "accounts", force: true, comment: "账单明细表(用户收入信息表)" do |t|
    t.integer  "customer_id",                   comment: "对应用户"
    t.integer  "ranking",                       comment: "收入排名"
    t.float    "balance",            limit: 24, comment: "账户余额"
    t.float    "total_income",       limit: 24, comment: "累计收入"
    t.integer  "total_order",                   comment: "累计出单"
    t.integer  "total_group",                   comment: "发起拼团"
    t.float    "total_cash",         limit: 24, comment: "累计提现金额"
    t.integer  "total_home",                    comment: "累计发展下家"
    t.float    "total_yongjinfanli", limit: 24, comment: "佣金返利"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_hongbao",      limit: 24, comment: "累计收到红包"
  end

  create_table "bonus", force: true, comment: "返利表" do |t|
    t.integer  "customer_id",    comment: "用户外键"
    t.string   "bonus",          comment: "奖金"
    t.string   "bonus_id",       comment: "返利编号"
    t.string   "operation",      comment: "事宜"
    t.string   "platform_bonus", comment: "平台返利"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "claims", force: true, comment: "理赔表" do |t|
    t.integer  "policy_id",         comment: "对应保单"
    t.string   "status",            comment: "理赔状态"
    t.string   "identity",          comment: "身份"
    t.string   "claim_no",          comment: "理赔单号"
    t.text     "description",       comment: "事件描述"
    t.datetime "happen_time",       comment: "发生时间"
    t.string   "happen_place",      comment: "发生地点"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "check_description", comment: "审核描述"
    t.datetime "check_time",        comment: "审核时间"
  end

  create_table "comments", force: true, comment: "评论表" do |t|
    t.string   "content",     comment: "评论内容"
    t.integer  "customer_id", comment: "用户ID"
    t.integer  "product_id",  comment: "产品ID"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_products", force: true, comment: "代金券产品中间表" do |t|
    t.integer  "product_id", comment: "对应产品"
    t.integer  "coupon_id",  comment: "对应代金券s"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", force: true, comment: "代金券表" do |t|
    t.string   "name",        comment: "名称"
    t.string   "amount",      comment: "金额"
    t.string   "release",     comment: "发放标准"
    t.string   "validity",    comment: "有效期"
    t.string   "range",       comment: "使用范围"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      comment: "状态(used: 已使用，unused: 未使用)"
    t.string   "reach_money", comment: "满多少钱可以使用"
  end

  create_table "coverages", force: true, comment: "保单保障范围表" do |t|
    t.string   "title",                            comment: "标题"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "custom_price_category_content_id", comment: "产品价格分类内容外键（给保障计划类使用的）"
    t.string   "amount",                           comment: "将保险责任中的万放到该字段里面"
    t.text     "description",                      comment: "责任描述"
  end

  create_table "custom_price_categories", force: true, comment: "自定义价格分类" do |t|
    t.string   "name",                          comment: "名称"
    t.integer  "product_id",                    comment: "用户外键"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "custom_price_category_type_id", comment: "自定义分类类型外键"
  end

  create_table "custom_price_category_contents", force: true, comment: "产品有效期表" do |t|
    t.string   "name",                     comment: "有效期时长"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "custom_price_category_id"
  end

  create_table "custom_price_category_types", force: true, comment: "自定义价格分类类型表" do |t|
    t.string   "name",       comment: "名称"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_groups", force: true, comment: "用户和团中间表" do |t|
    t.integer  "group_buying_id", comment: "对应团"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "share_man_id",    comment: "分享人的id"
    t.integer  "order_id",        comment: "增加order_id的外键"
  end

  create_table "customers", force: true do |t|
    t.string   "name",                                       comment: "姓名"
    t.string   "register_id",                                comment: "注册ID"
    t.string   "invitation_id",                              comment: "邀请人ID"
    t.string   "sex",                                        comment: "性别"
    t.string   "nick_name",                                  comment: "昵称"
    t.string   "phone",                                      comment: "电话号码"
    t.string   "wechat",                                     comment: "微信号"
    t.integer  "level_id",                                   comment: "领队级别ID"
    t.string   "avatar",                                     comment: "用户头像"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "open_id",                                    comment: "微信授权openid"
    t.string   "role",                                       comment: "用户角色"
    t.string   "sms_token",                                  comment: "短信验证码"
    t.string   "initial",                                    comment: "开头首字母"
    t.string   "id_card",                                    comment: "身份证号"
    t.float    "hongbao",           limit: 24, default: 0.0, comment: "红包金额"
    t.datetime "become_lingdui_at",                          comment: "成为领队的时间"
  end

  add_index "customers", ["register_id"], name: "index_customers_on_register_id", unique: true, using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "feedbacks", force: true, comment: "意见反馈管理" do |t|
    t.string   "content",     comment: "用户提交意见的内容"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  create_table "galleries", force: true, comment: "图库" do |t|
    t.string   "url",         comment: "图片路径"
    t.string   "parent_id",   comment: "所属父类id"
    t.string   "parent_type", comment: "所属类别，例如: product"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description", comment: "图片描述"
    t.string   "link",        comment: "图片点击后的链接（只有首页广告图有用）"
  end

  create_table "group_buyings", force: true, comment: "拼团表" do |t|
    t.string   "name",                                comment: "团名称"
    t.string   "status",                              comment: "团状态"
    t.datetime "start_time",                          comment: "开团日期"
    t.integer  "validity",                            comment: "团有效期"
    t.integer  "product_id",                          comment: "对应产品"
    t.integer  "customer_id",                         comment: "参与成员"
    t.string   "groupid",                             comment: "团ID"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "start_person_number",                 comment: "当时的起团人数"
    t.integer  "product_price_id",                    comment: "产品的price外键(从中可以获取到产品的自定义价格分类信息),如果不存在或者对应的自定义分类不存在则无法拼团"
    t.boolean  "delete_status",       default: false, comment: "用户删除状态"
  end

  create_table "home_special_categories", force: true, comment: "首页特惠分类表" do |t|
    t.string   "name",       comment: "分类名称"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insureds", force: true do |t|
    t.integer  "policy_id",  comment: "对应保单"
    t.string   "name",       comment: "姓名"
    t.string   "sex",        comment: "性别"
    t.string   "phone",      comment: "联系方式"
    t.date     "birthday",   comment: "出生日期"
    t.string   "idcard",     comment: "身份证"
    t.string   "email",      comment: "邮箱"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: true, comment: "产品标签表" do |t|
    t.string   "name",       comment: "名称"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", force: true do |t|
    t.string   "name",               comment: "级别名称"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_up_condition", comment: "领队升级人数"
    t.integer  "weight",             comment: "权重，数字(1,2..) 权重越高代表等级越高，每次设置levels的内容的时候自动排序并设置权重"
  end

  create_table "logs", force: true, comment: "记录日志的表" do |t|
    t.string   "controller",     comment: "rails 控制器"
    t.string   "action",         comment: "rails action"
    t.string   "user_name",      comment: "当前登录用户名"
    t.text     "parameters",     comment: "rails的 params"
    t.datetime "created_at",     comment: "创建时间"
    t.string   "remote_ip",      comment: "远程IP"
    t.string   "restful_method", comment: "get/post/put/delete"
  end

  create_table "notification_types", force: true do |t|
    t.string   "name",       comment: "名称"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true, comment: "消息管理" do |t|
    t.string   "title",                comment: "消息标题"
    t.string   "level",                comment: "消息可见人群"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content",              comment: "内容"
    t.integer  "customer_id"
    t.integer  "notification_type_id", comment: "消息类别外键"
  end

  create_table "orders", force: true, comment: "订单表" do |t|
    t.string   "order_number",                    comment: "订单号"
    t.string   "payment_status",                  comment: "支付状态"
    t.integer  "customer_id",                     comment: "用户外键"
    t.integer  "product_id",                      comment: "产品外键"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",                limit: 24, comment: "下订单时的金额"
    t.datetime "start_baozhangqixian",            comment: "保障期限开始时间"
    t.datetime "end_baozhangqixian",              comment: "保障期限结束时间"
    t.string   "pay_way",                         comment: "支付方式"
    t.float    "discount_amount",      limit: 24, comment: "优惠金额"
    t.integer  "group_buying_id",                 comment: "团的外键, 可以知道是从哪个团拼的团，没有则是单独购买的"
    t.integer  "current_fee",                     comment: "当交易完成的时候产品佣金比例"
    t.integer  "share_man_id",                    comment: "分享人的id"
    t.integer  "product_price_id",                comment: "产品价格的id"
    t.datetime "payed_at",                        comment: "支付时间"
    t.string   "order_status",                    comment: "订单状态(是团购的还是单买的)"
    t.text     "payed_response",                  comment: "订单返回的response"
  end

  create_table "policies", force: true, comment: "保单表" do |t|
    t.integer  "order_id",                comment: "订单外键"
    t.string   "policy_holder_name",      comment: "投保人姓名"
    t.string   "policy_holder_sex",       comment: "投保人性别"
    t.string   "policy_holder_phone",     comment: "投保人联系电话"
    t.datetime "policy_holder_birthday",  comment: "投保人出生日期"
    t.string   "policy_holder_id_card",   comment: "投保人身份证"
    t.string   "policy_holder_email",     comment: "投保人邮箱"
    t.string   "insured_person_sex",      comment: "被保人性别"
    t.string   "insured_person_phone"
    t.datetime "insured_person_birthday", comment: "被保人出生日期"
    t.string   "insured_person_id_card",  comment: "被保人身份证"
    t.string   "insured_person_email",    comment: "被保人邮箱"
    t.string   "relation",                comment: "被保人和投保人"
    t.string   "status",                  comment: "保单状态, 例子：已退保，保障中，已过期"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "policy_number",           comment: "保单号"
    t.string   "insured_person_name"
    t.string   "insured_person_type",     comment: "被保人类型"
    t.text     "tuibaoyuanyin",           comment: "退保原因"
    t.string   "product_name",            comment: "购买时产品名称"
    t.text     "coverage",                comment: "购买时保障内容('||'和'|'分隔开)"
  end

  create_table "product_categories", force: true, comment: "产品类型" do |t|
    t.string   "name",       comment: "类型名, 例子：健康险"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_labels", force: true, comment: "产品标签多对多中间表" do |t|
    t.integer  "label_id",   comment: "标签外键"
    t.integer  "product_id", comment: "产品外键"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_prices", force: true do |t|
    t.float   "group_price", limit: 24, comment: "团购价格"
    t.float   "price",       limit: 24, comment: "单独购买价格"
    t.integer "product_id",             comment: "产品外键"
    t.string  "content_ids",            comment: "对应产品自定义分类内容"
  end

  create_table "products", force: true, comment: "商品表" do |t|
    t.string   "company_name",                                      comment: "公司名, 例子：新华保险"
    t.string   "name",                                              comment: "产品名称，例子：老年健康险"
    t.string   "status",                                            comment: "状态，例子：上架中"
    t.integer  "product_category_id",                               comment: "产品分类外键(1:n关系)"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "introduce",                                         comment: "产品介绍"
    t.integer  "fee",                                               comment: "佣金（占实际支付价格的百分比）"
    t.string   "valid_date",                                        comment: "产品有效期，产品到达有效期后，所有相关这个产品的团都会失效"
    t.integer  "home_special_category_id",                          comment: "首页特殊优惠分类外键"
    t.text     "description",                                       comment: "产品描述"
    t.integer  "tuiguangtongji",                                    comment: "推广奖励"
    t.integer  "from_the_number",                                   comment: "起团人数"
    t.float    "price",                    limit: 24, default: 0.0, comment: "价格"
    t.float    "market_price",             limit: 24,               comment: "市场价格"
    t.text     "explain",                                           comment: "详细说明"
    t.string   "baoe",                                              comment: "保额"
    t.datetime "xiajiashijian",                                     comment: "下架时间"
    t.float    "max_hongbao",              limit: 24, default: 0.0, comment: "最大可使用红包数量"
    t.string   "url",                                               comment: "图片url"
    t.text     "insurance_information",                             comment: "投保须知"
    t.text     "claims_service",                                    comment: "理赔服务"
    t.text     "common_problems",                                   comment: "常见问题"
    t.text     "health_told",                                       comment: "健康告知"
  end

  create_table "rankings", force: true do |t|
    t.integer  "customer_id",     comment: "用户外键"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_amount", comment: "下家出单量"
    t.string   "amount",          comment: "自己出单量"
    t.string   "rank",            comment: "排名"
  end

  create_table "send_and_receive_coupons", force: true, comment: "发送/接收代金券表" do |t|
    t.integer  "send_customer_id",    comment: "发送人id"
    t.integer  "receive_customer_id", comment: "接收人id"
    t.integer  "coupon_id",           comment: "代金券id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_rqrcodes", force: true, comment: "客服二维码表" do |t|
    t.string   "url",        comment: "二维码图片"
    t.string   "name",       comment: "姓名"
    t.string   "phone",      comment: "电话"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
