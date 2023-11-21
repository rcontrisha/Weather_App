import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'base_network.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'boxes.dart';
import 'city_hive.dart';
import 'manage_city.dart';
import 'weather_models.dart';
import 'forecast_models.dart';

class WeatherApp extends StatelessWidget {
  final String? city2; // Make it nullable
  WeatherApp({this.city2}); // Make it nullable

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WeatherPage(city2: city2),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  final String? city2;

  WeatherPage({required this.city2});

  @override
  _WeatherPageState createState() => _WeatherPageState(city2: city2);
}

class _WeatherPageState extends State<WeatherPage> {
  late String? city2;
  _WeatherPageState({required this.city2});

  String city = 'Loading...';
  String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  WeatherData? weatherData;
  ForecastData? forecastData;

  @override
  void initState() {
    super.initState();
    if (city2 == null){
      requestPermission();
    }
    else if (city2 != null){
      fetchCityAndWeather(cityName: city2);
    }
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      fetchCityAndWeather();
    } else {
      print('Location permission denied');
    }
  }

  Future<void> fetchCityAndWeather({String? cityName}) async {
    try {
      if (cityName == null || cityName.isEmpty) {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        print('Placemarks: $placemarks');

        if (placemarks.isNotEmpty) {
          final Placemark firstPlacemark = placemarks.first;
          cityName = firstPlacemark.subLocality ?? 'Unknown City';

          // Add the current city to Hive box
          addCityToHiveBox(cityName);
        } else {
          print('City not found');
          return;
        }
      }

      setState(() {
        city = cityName!;
      });

      fetchWeather(city); // Pass the value accordingly
      fetchForecast(city); // Pass the value accordingly
    } catch (e) {
      print('Error fetching city: $e');
    }
  }

  // Function to add the city to Hive box
  void addCityToHiveBox(String cityName) {
    Box<Kota> cityBox = Hive.box<Kota>(HiveBoxes.city);
    cityBox.putAt(0, Kota(city: cityName));
  }

  Future<void> fetchWeather(String cityName) async {
    try {
      var data = await WeatherApi.getWeatherData(cityName);
      if (data != null) {
        setState(() {
          weatherData = WeatherData.fromJson(data);
        });
      } else {
        print('Error: Weather data is null');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Future<void> fetchForecast(String cityName) async {
    try {
      var fdata = await WeatherApi.getForecastData(cityName);
      if (fdata != null) {
        setState(() {
          forecastData = ForecastData.fromJson(fdata);
        });
      } else {
        print('Error: Forecast data is null');
      }
    } catch (e) {
      print('Error fetching forecast data: $e');
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return 'http://openweathermap.org/img/wn/$iconCode.png';
  }

  String _getFormattedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  Widget buildWeatherCard(WeatherList weatherListItem, String formattedDate) {
    if (formattedDate.isNotEmpty) {
      return Card(
        color: Colors.pinkAccent.withOpacity(0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Image.network(
                  getWeatherIconUrl(
                      weatherListItem.weather?[0].icon ?? 'defaultIconCode'),
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 10),
                Text(
                  capitalizeEachWord(
                      '${weatherListItem.weather?[0].description}'),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${weatherListItem.main?.feelsLike?.toStringAsFixed(0) ?? 'N/A'}°C',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // Return an empty SizedBox for today's date
    }
  }

  Widget buildInfoCard(String title, String value) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeatherInfoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0,
      children: [
        buildInfoCard("Wind Speed", "${weatherData?.wind?.speed ?? 'N/A'} km/h"),
        buildInfoCard("Humidity", "${weatherData?.main?.humidity ?? 'N/A'}%"),
        buildInfoCard("Chance of Rain", "${((forecastData?.list![0].pop)! * 100).toInt()}%"),
        buildInfoCard("Pressure", "${weatherData?.main?.pressure ?? 'N/A'} hPa"),
        buildInfoCard("Sunrise", formatTime(weatherData?.sys?.sunrise)),
        buildInfoCard("Sunset", formatTime(weatherData?.sys?.sunset)),
      ],
    );
  }

  String formatTime(int? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat.Hm().format(dateTime); // Format time as HH:mm
    } else {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<String> processedDates = Set<String>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.clamp,
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xfff48fb1),
                    Color(0xfff8bbd0)
                  ],
                ),
              ),
              child: ListView(children: [
                SizedBox(
                  height: constraints.maxHeight / 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CityListPage()),
                                    );
                                  },
                                  icon: Icon(Icons.add, color: Colors.white, size: 30),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 45),
                                    child: Text(
                                      '$city',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight / 100,
                        ),
                        Center(
                          child: Text(
                            currentDate,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Image.network(
                                getWeatherIconUrl(weatherData?.weather?[0].icon ?? 'defaultIconCode'),
                                height: 150,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${weatherData?.main?.feelsLike != null ? (weatherData?.main?.feelsLike ?? 0).toStringAsFixed(0) + '°C' : 'N/A'}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight / 100,
                        ),
                        Center(
                          child: Text(
                            capitalizeEachWord(
                                '${(weatherData?.weather?[0].description) != null ? (weatherData?.weather?[0].description) : 'N/A'}'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: constraints.maxHeight / 8,
                            ),
                            Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.wind,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${(weatherData!.wind!.speed != null ? weatherData!.wind!.speed! : 'N/A')} km/h',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.cloud,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${weatherData?.clouds?.all != null ? weatherData?.clouds?.all : 'N/A'} %',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.droplet,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${weatherData?.main?.humidity != null ? weatherData?.main?.humidity : 'N/A'} %',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: constraints.maxHeight / 8,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 50, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '5-Day Forecast',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
                          child: Container(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (forecastData?.list?.length)!-1 ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                final WeatherList weatherListItem = forecastData?.list?[index+1] ?? WeatherList();
                                final formattedDate = _getFormattedDate(DateTime.parse(weatherListItem.dtTxt!));

                                // Check if it's the first forecast for the day
                                bool isFirstForecastForDay = processedDates.add(formattedDate);

                                // Display only the first forecast for each day
                                if (isFirstForecastForDay) {
                                  return buildWeatherCard(weatherListItem, formattedDate);
                                } else {
                                  return SizedBox.shrink(); // If it's not the first forecast for the day, return an empty SizedBox
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 15, 5, 10),
                          child: Container(
                            height: 300,
                            child: Card(
                              color: Colors.pinkAccent.withOpacity(0.45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: buildWeatherInfoGrid(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  String capitalizeEachWord(String input) {
    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}
