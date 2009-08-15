class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url
  validates_numericality_of :price
  validate :price_must_be_at_least_a_cent
  validates_uniqueness_of :title
  validates_format_of :image_url, :with => %r{\.(gif|jpg|png)$}i,:message => 'must be a URL for GIF, JPG ' + 'or PNG image.'
end
