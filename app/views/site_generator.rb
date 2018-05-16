class SiteGenerator
  attr_reader :path

  def initialize(path)
    @path = path
    FileUtils.mkdir_p path
    FileUtils.mkdir_p "#{path}/recipes"
  end

  def generate_index(temp_path)
    # first load template string
    temp_string = File.read("./lib/views/index.htmo.erb")
    # instantiate the ERB template instance
    temp = ERB.new(temp_string)
    html = temp.result

    File.write("#{path}/index.html", html)
  end

  # def generate_recipe_index(template)
  #   # first load template string
  #   template_string = File.read("./lib/views/#{{template}}/.erb")
  #   # instantiate the ERB template instance
  #   template = ERB.new(template_string)
  #   html = template.result
  #
  #   File.write("#{path}/recipes/#{recipe.name}.html", html)
  # end

  def call
    generate_index("index.html")
    generate_index("recipes/index.html")
    generate_index("locations/index.html")
    generate_index("users/index.html")
  end
end
