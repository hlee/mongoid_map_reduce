class Band
  include Mongoid::Document
  field :name, type: String
  field :likes, type: Integer
end
