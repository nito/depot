class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url, :message => '空であってはなりません'
  validates_length_of :title, :minimum => 10, :message => "最低10文字入力して下さい"
  validates_numericality_of :price
  validate :price_must_be_at_least_a_cent
  validates_uniqueness_of :title
  validates_format_of :image_url, :with => %r{\.(gif|jpg|png)$}i,:message => 'PNG/GIF/JPGのいずれかでなければなりません'
  protected
  def price_must_be_at_least_a_cent
    errors.add(:price, '最低1セントでなければなりません') if price.nil? || price < 0.01
  end

end
