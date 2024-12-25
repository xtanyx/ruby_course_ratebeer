class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    # places = Rails.cache.read(city)
    # return places if places

    # places = get_places_in(city)
    # Rails.cache.write(city, places)
    # places

    Rails.cache.fetch(city, expires_in: 1.weeks) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "https://studies.cs.helsinki.fi/beermapping/locations/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  # This block is not used since the application does not use the beermappingAPI
  # but uses the university provided one
  def self.key
    return nil if Rails.env.test? # while testing api is not needed, return nil
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?

    ENV.fetch('BEERMAPPING_APIKEY')
  end
end
