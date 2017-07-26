class GoodsController < ApplicationController
  before_action :set_good, only: [:show, :edit, :update, :destroy]

  def index
    @goods = Good.all.page(params[:page])
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
    Tool.upload_image(params[:good], :image_url)
    @good = Good.new(good_params)
    @good.save

    redirect_to goods_path, notice: '新建成功'
  end

  def update
    @good.image_url.destroy_all if @good.image_url.present?  #将原来的图片删掉

    Tool.upload_image(params[:good], :image_url)
    @good.update(good_params)

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
      params.require(:good).permit(:name, :description, :image_url, :categroy_id)
    end
end
