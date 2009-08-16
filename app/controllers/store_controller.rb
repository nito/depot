class StoreController < ApplicationController
  def index
    @products = Product.find_products_for_sale
    @time = Time.now.strftime "%Y/%m/%d %H:%M"
  end

end
