class GoodsController < ApplicationController
  before_action :set_good, only: [:show, :edit, :update, :destroy]

  def index
    @goods = Good.all.page(params[:page]).order("created_at desc")
    @goods = @goods.where("name like ?", "%#{params[:name]}%") if params[:name].present?
  end

  def show
  end

  def new
    @good = Good.new
  end

  def edit
  end

  def create
    @good = Good.new(good_params)
    @good.save

    if params[:photos].present?
      Tool.upload_images(params[:photos][:image_url], @good.id, "good_id", GoodsPhoto)
    end

    redirect_to goods_path, notice: '新建成功'
  end

  def update
    @good.update(good_params)

    if params[:photos].present?
      @good.goods_photos.destroy_all   #将原来的图片删掉
      Tool.upload_images(params[:photos][:image_url], @good.id, "good_id", GoodsPhoto)
    end

    redirect_to goods_path, notice: '编辑成功'
  end

  def destroy
    @good.destroy

    redirect_to goods_path, notice: '删除成功'
  end

  private
    def set_good
      @good = Good.find(params[:id])
    end

    def good_params
      params.require(:good).permit(:name, :description, :price, :category_id)
    end
end
