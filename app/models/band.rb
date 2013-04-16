class Band
  include Mongoid::Document
  field :name, type: String
  field :likes, type: Integer, default: 0
  field :foo, type: Boolean, default: false
  field :bar, type: Boolean, default: false

  def self.mar
    map = %Q{
      function() {
        hsh = {};
        if(this.foo) {hsh.foo = this.foo}
        if(this.bar) {hsh.bar = this.bar}
        emit(this.name, { likes: this.likes, hh: hsh });
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = { likes: 0, hh: 0 };
        values.forEach(function(value) {
          result.likes += value.likes;
          if(value.hh.foo) {result.hh += 1}
          if(value.hh.bar) {result.hh += 1}

        });
        return result;
      }
    }

    self.where(:likes.gt => 100).map_reduce(map, reduce).out(inline: true)
  end
end
