class Band
  include Mongoid::Document
  field :name, type: String
  field :likes, type: Integer
  def self.mar
    map = %Q{
      function() {
        emit(this.name, { likes: this.likes });
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = { likes: 0 };
        values.forEach(function(value) {
          result.likes += value.likes;
        });
        return result;
      }
    }

    self.where(:likes.gt => 100).map_reduce(map, reduce).out(inline: true)
  end
end
