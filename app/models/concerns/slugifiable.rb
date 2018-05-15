module Slugifiable
    def slug
      obj = self.name.downcase
      obj.gsub(" ", "-")
    end
  end

module Slugifiable
    def search_by_name(name)
      self.all.detect{|name| s.slug == slug}
    end

    def search_or_create_by_name(name)
      self.all.search_by_name(name) || self.create(name)
    end

end
