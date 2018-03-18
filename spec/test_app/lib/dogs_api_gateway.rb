class DogsApiGateway
  API_URL = "https://dog.ceo/api"

  def all
    fetch_all.map { |node| DogBreed.new(node, -> (breed) { breed_images(breed) }) }
  end

  def find(breed_slug)
    all.find { |dog_breed| dog_breed.slug == breed_slug }
  end

  private

  def fetch_all
    @fetch_all ||= fetch_from("#{API_URL}/breeds/list/all")
  end

  def breed_images(breed)
    fetch_from("#{API_URL}/breed/#{breed}/images")
  end

  def fetch_from(url)
    Rails.cache.fetch(url, expires_in: 10.hours) do
      JSON.parse(open(url).read).fetch("message")
    end
  end

  class DogBreed
    attr_reader :name, :sub_breeds, :slug, :images_source

    def initialize(node, images_source)
      @name = node.first.capitalize
      @slug = node.first
      @sub_breeds = node.last
      @images_source = images_source
    end

    def sub_breeds_list
      @sub_breeds_list ||= sub_breeds.map(&:capitalize).join(", ")
    end

    def images
      @images ||= images_source.call(slug)
    end
  end
end
