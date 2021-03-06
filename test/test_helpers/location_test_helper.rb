module LocationTestHelper
  API_GEOSEARCH_RESPONSE = [
    {
      "place_id" => "89640023",
      "osm_type" => "relation",
      "osm_id" => "34324395",
      "lat" => 37.76,
      # LocationIQ uses 'lon'
      "lon" => -122.45,
      "display_name" => "University of California, San Francisco, Parnassus Avenue, Inner Sunset, San Francisco, San Francisco City and County, California, 94131, USA",
      "address" => {
        "university" => "University of California, San Francisco",
        "city" => "San Francisco",
        "county" => "San Francisco City and County",
        "state" => "California",
        "country" => "USA",
        "country_code" => "us",
      },
    },
  ].freeze
  API_OSM_ID_SEARCH_RESPONSE = API_GEOSEARCH_RESPONSE[0].freeze

  FORMATTED_GEOSEARCH_RESPONSE = [
    {
      "name" => "University of California, San Francisco, San Francisco, San Francisco City and County, California, USA",
      "geo_level" => "city",
      "country_name" => "USA",
      "state_name" => "California",
      "subdivision_name" => "San Francisco City and County",
      "city_name" => "San Francisco",
      "lat" => 37.76,
      "lng" => -122.45,
      "country_code" => "us",
      "osm_id" => 34_324_395,
      "osm_type" => "relation",
      "locationiq_id" => 89_640_023,
    },
  ].freeze
  API_GEOSEARCH_CALIFORNIA_RESPONSE = [
    {
      "place_id" => "214330370",
      "osm_type" => "relation",
      "osm_id" => "165475",
      "lat" => 36.70,
      # LocationIQ uses 'lon'
      "lon" => -118.76,
      "display_name" => "California, USA",
      "address" => {
        "state" => "California",
        "country" => "USA",
        "country_code" => "us",
      },
    },
  ].freeze
  FORMATTED_GEOSEARCH_CALIFORNIA_RESPONSE = [
    {
      "name" => "California, USA",
      "geo_level" => "state",
      "country_name" => "USA",
      "state_name" => "California",
      "subdivision_name" => "",
      "city_name" => "",
      "lat" => 36.7,
      "lng" => -118.76,
      "country_code" => "us",
      "osm_id" => 165_475,
      "osm_type" => "relation",
      "locationiq_id" => 214_330_370,
    },
  ].freeze
  API_GEOSEARCH_SF_COUNTY_RESPONSE = [
    {
      "place_id" => "214379825",
      "osm_type" => "relation",
      "osm_id" => "396487",
      "lat" => 37.76,
      # LocationIQ uses 'lon'
      "lon" => -122.46,
      "display_name" => "San Francisco City and County, California, USA",
      "address" => {
        "county" => "San Francisco City and County",
        "state" => "California",
        "country" => "USA",
        "country_code" => "us",
      },
    },
  ].freeze
  FORMATTED_GEOSEARCH_SF_COUNTY_RESPONSE = [
    {
      "name" => "San Francisco City and County, California, USA",
      "geo_level" => "subdivision",
      "country_name" => "USA",
      "state_name" => "California",
      "subdivision_name" => "San Francisco City and County",
      "city_name" => "",
      "lat" => 37.76,
      "lng" => -122.46,
      "country_code" => "us",
      "osm_id" => 396_487,
      "osm_type" => "relation",
      "locationiq_id" => 214_379_825,
    },
  ].freeze
  API_GEOSEARCH_DHAKA_RESPONSE = [
    {
      "place_id" => "46003496",
      "osm_type" => "relation",
      "osm_id" => "3442474911",
      "lat" => 23.76,
      "lon" => 90.38,
      "display_name" => "Dhaka, Dhaka Division, 12, Bangladesh",
      "address" => {
        "city" => "Dhaka",
        "state" => "Dhaka Division",
        "country" => "Bangladesh",
        "country_code" => "bd",
      },
    },
  ].freeze
  API_GEOSEARCH_USA_RESPONSE = [
    {
      "place_id" => "214325471",
      "osm_type" => "relation",
      "osm_id" => "148838",
      "lat" => 39.78,
      "lon" => -100.45,
      "display_name" => "USA",
      "address" => {
        "country" => "USA",
        "country_code" => "us",
      },
    },
  ].freeze
  API_GEOSEARCH_USA_ALTERNATIVE_RESPONSE = [
    {
      "place_id" => "322027963664",
      "osm_type" => "relation",
      "osm_id" => "148838",
      "lat" => 39.78,
      "lon" => -100.45,
      "display_name" => "USA",
      "address" => {
        "country" => "USA",
        "country_code" => "us",
      },
    },
  ].freeze
  API_GEOSEARCH_NODE_RESPONSE = [
    {
      "place_id" => "214325471",
      "osm_type" => "node",
      "osm_id" => "148838",
      "lat" => 39.78,
      "lon" => -100.45,
      "display_name" => "USA",
      "address" => {
        "country" => "USA",
        "country_code" => "us",
      },
    },
  ].freeze
  FORMATTED_GEOSEARCH_USA_RESPONSE = [
    {
      "name" => "USA",
      "geo_level" => "country",
      "country_name" => "USA",
      "state_name" => "",
      "subdivision_name" => "",
      "city_name" => "",
      "lat" => 39.78,
      "lng" => -100.45,
      "country_code" => "us",
      "osm_id" => 148_838,
      "osm_type" => "relation",
      "locationiq_id" => 214_325_471,
    },
  ].freeze
  FORMATTED_GEOSEARCH_DHAKA_RESPONSE = [
    {
      "name" => "Dhaka, Dhaka Division, Bangladesh",
      "geo_level" => "city",
      "country_name" => "Bangladesh",
      "state_name" => "Dhaka Division",
      "subdivision_name" => "",
      "city_name" => "Dhaka",
      "lat" => 23.76,
      "lng" => 90.38,
      "country_code" => "bd",
      "osm_id" => 3_442_474_911,
      "osm_type" => "relation",
      "locationiq_id" => 46_003_496,
    },
  ].freeze
  API_GEOSEARCH_UGANDA_RESPONSE = [
    {
      "place_id" => "214342685",
      "osm_type" => "relation",
      "osm_id" => "192796",
      "lat" => 1.53,
      "lon" => 32.22,
      "display_name" => "Uganda",
      "address" => {
        "country" => "Uganda",
        "country_code" => "ug",
      },
    },
  ].freeze
  FORMATTED_GEOSEARCH_UGANDA_RESPONSE = [
    {
      "name" => "Uganda",
      "geo_level" => "country",
      "country_name" => "Uganda",
      "state_name" => "",
      "subdivision_name" => "",
      "city_name" => "",
      "lat" => 1.53,
      "lng" => 32.22,
      "country_code" => "ug",
      "osm_id" => 192_796,
      "osm_type" => "relation",
      "locationiq_id" => 214_342_685,
    },
  ].freeze
  API_RATE_LIMIT_RESPONSE = {
    "error" => "Rate Limited Second",
  }.freeze
  API_NO_GEOCODE_RESPONSE = {
    "error" => "Unable to geocode",
  }.freeze
  API_GEOSEARCH_RESPONSE_WITH_TYPE = [
    {
      "place_id" => "223252784",
      "osm_type" => "relation",
      "osm_id" => "2835017",
      "lat" => 37.54,
      "lon" => -122.31,
      "display_name" => "San Mateo, San Mateo County, California, USA",
      "address" => {},
      "type" => "city",
    },
  ].freeze
  FORMATTED_GEOSEARCH_RESPONSE_WITH_TYPE = [
    {
      "name" => "San Mateo, San Mateo County, California, USA",
      "geo_level" => "city",
      "country_name" => "",
      "state_name" => "",
      "subdivision_name" => "",
      "city_name" => "",
      "lat" => 37.54,
      "lng" => -122.31,
      "country_code" => "",
      "osm_id" => 2_835_017,
      "osm_type" => "relation",
      "locationiq_id" => 223_252_784,
    },
  ].freeze
end
