class StoreController < ApplicationController
  def index
    @products = Product.find_products_for_sale
    # code added by nito@gilt.jp 2009/08/16
    @time = Time.now.strftime "%Y/%m/%d %H:%M"
    # code added by nito@gilt.jp 2009/08/17
    @count = increment_count
    # code added by nito@gilt.jp 2009/08/22
    @cart = find_cart
  end

  def increment_count
    session[:counter] ||= 0
    session[:counter] += 1
  end

  def add_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @current_item = @cart.add_product(product)
    respond_to do  |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
    @count = session[:counter] = 0
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    #redirect_to_index("Invalid product")
    redirect_to :action => 'index'
  end

  def empty_cart
    session[:cart] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
#    redirect_to_index unless request.xhr?
#    redirect_to_index("Your cart is currently empty")
#    flash[:notice] = "Your cart is currently empty"
#    redirect_to :action => 'index'
  end

private
def redirect_to_index(msg = nil)
  flash[:notice] = msg if msg
  redirect_to :action => 'index'
end


private

  def find_cart
    session[:cart] ||= Cart.new
  end


end
