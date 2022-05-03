class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_by, :created_at, :updated_at
  #only  included attributes and association will show up
  has_many :items
end
