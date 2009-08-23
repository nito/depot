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
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
    @count = session[:counter] = 0
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    redirect_to_index("Invalid product")
  end

  def empty_cart
    session[:cart] = nil
    redirect_to :action => 'index'
  end

  def checkout
    @count = session[:counter] = 0
    @cart = find_cart
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    else
      @order = Order.new
    end
  end

  def save_order
    @count = session[:counter] = 0
    @cart = find_cart
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      redirect_to_index("Thank you for your order")
    else
      render :action => 'checkout'
    end
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
