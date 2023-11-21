import 'dart:core';

class ForecastData {
  String? cod;
  num? message;
  num? cnt;
  List<WeatherList>? list;
  City? city;

  ForecastData({
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  ForecastData.fromJson(Map<String, dynamic> json) {
    cod = json['cod'] as String?;
    message = json['message'] as num?;
    cnt = json['cnt'] as num?;
    list = (json['list'] as List?)?.map((dynamic e) => WeatherList.fromJson(e as Map<String,dynamic>)).toList();
    city = (json['city'] as Map<String,dynamic>?) != null ? City.fromJson(json['city'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['cod'] = cod;
    json['message'] = message;
    json['cnt'] = cnt;
    json['list'] = list?.map((e) => e.toJson()).toList();
    json['city'] = city?.toJson();
    return json;
  }
}

class WeatherList {
  num? dt;
  Main? main;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  num? visibility;
  num? pop;
  Sys? sys;
  String? dtTxt;

  WeatherList({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.sys,
    this.dtTxt,
  });

  WeatherList.fromJson(Map<String, dynamic> json) {
    dt = json['dt'] as num?;
    main = (json['main'] as Map<String,dynamic>?) != null ? Main.fromJson(json['main'] as Map<String,dynamic>) : null;
    weather = (json['weather'] as List?)?.map((dynamic e) => Weather.fromJson(e as Map<String,dynamic>)).toList();
    clouds = (json['clouds'] as Map<String,dynamic>?) != null ? Clouds.fromJson(json['clouds'] as Map<String,dynamic>) : null;
    wind = (json['wind'] as Map<String,dynamic>?) != null ? Wind.fromJson(json['wind'] as Map<String,dynamic>) : null;
    visibility = json['visibility'] as num?;
    pop = json['pop'] as num?;
    sys = (json['sys'] as Map<String,dynamic>?) != null ? Sys.fromJson(json['sys'] as Map<String,dynamic>) : null;
    dtTxt = json['dt_txt'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['dt'] = dt;
    json['main'] = main?.toJson();
    json['weather'] = weather?.map((e) => e.toJson()).toList();
    json['clouds'] = clouds?.toJson();
    json['wind'] = wind?.toJson();
    json['visibility'] = visibility;
    json['pop'] = pop;
    json['sys'] = sys?.toJson();
    json['dt_txt'] = dtTxt;
    return json;
  }
}

class Main {
  num? temp;
  num? feelsLike;
  num? tempMin;
  num? tempMax;
  num? pressure;
  num? seaLevel;
  num? grndLevel;
  num? humidity;
  num? tempKf;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    pressure = json['pressure'] as num?;
    seaLevel = json['sea_level'] as num?;
    grndLevel = json['grnd_level'] as num?;
    humidity = json['humidity'] as num?;
    tempKf = json['temp_kf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['temp'] = temp;
    json['feels_like'] = feelsLike;
    json['temp_min'] = tempMin;
    json['temp_max'] = tempMax;
    json['pressure'] = pressure;
    json['sea_level'] = seaLevel;
    json['grnd_level'] = grndLevel;
    json['humidity'] = humidity;
    json['temp_kf'] = tempKf;
    return json;
  }
}

class Weather {
  num? id;
  String? main;
  String? description;
  String? icon;

  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'] as num?;
    main = json['main'] as String?;
    description = json['description'] as String?;
    icon = json['icon'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['main'] = main;
    json['description'] = description;
    json['icon'] = icon;
    return json;
  }
}

class Clouds {
  num? all;

  Clouds({
    this.all,
  });

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['all'] = all;
    return json;
  }
}

class Wind {
  num? speed;
  num? deg;
  num? gust;

  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'] as num?;
    deg = json['deg'] as num?;
    gust = json['gust'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['speed'] = speed;
    json['deg'] = deg;
    json['gust'] = gust;
    return json;
  }
}

class Sys {
  String? pod;

  Sys({
    this.pod,
  });

  Sys.fromJson(Map<String, dynamic> json) {
    pod = json['pod'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['pod'] = pod;
    return json;
  }
}

class City {
  num? id;
  String? name;
  Coord? coord;
  String? country;
  num? population;
  num? timezone;
  num? sunrise;
  num? sunset;

  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'] as num?;
    name = json['name'] as String?;
    coord = (json['coord'] as Map<String,dynamic>?) != null ? Coord.fromJson(json['coord'] as Map<String,dynamic>) : null;
    country = json['country'] as String?;
    population = json['population'] as num?;
    timezone = json['timezone'] as num?;
    sunrise = json['sunrise'] as num?;
    sunset = json['sunset'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    json['coord'] = coord?.toJson();
    json['country'] = country;
    json['population'] = population;
    json['timezone'] = timezone;
    json['sunrise'] = sunrise;
    json['sunset'] = sunset;
    return json;
  }
}

class Coord {
  num? lat;
  num? lon;

  Coord({
    this.lat,
    this.lon,
  });

  Coord.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] as num?;
    lon = json['lon'] as num?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['lat'] = lat;
    json['lon'] = lon;
    return json;
  }
}