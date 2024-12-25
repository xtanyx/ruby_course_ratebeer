class WeatherStackApi
  def self.weather_of(city)
    city = city.downcase

    get_weather_of(city)
  end

  def self.get_weather_of(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    return [] if response.is_a?(Hash) && response['success'] == false

    response["current"]
  end

  def self.key
    return nil if Rails.env.test?
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV.fetch('WEATHERSTACK_APIKEY')
  end
end
