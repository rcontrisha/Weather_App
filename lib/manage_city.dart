import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:projek_akhir/home.dart';
import 'base_network.dart';
import 'boxes.dart';
import 'city_hive.dart';
import 'weather_models.dart';

class CityListPage extends StatefulWidget {
  @override
  _CityListPageState createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  TextEditingController _cityController = TextEditingController();
  WeatherData? weatherData;

  void _onAddButtonPressed() {
    String cityName = _cityController.text.trim();
    if (cityName.isNotEmpty) {
      Box<Kota> cityBox = Hive.box<Kota>(HiveBoxes.city);
      cityBox.add(Kota(city: cityName));
      _cityController.clear();
      setState(() {});
    }
  }

  void _onDeleteButtonPressed(Kota city) {
    Box<Kota> cityBox = Hive.box<Kota>(HiveBoxes.city);
    city.delete();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Cities'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey[600],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 35,
                      ),
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Enter Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ElevatedButton(
                    onPressed: _onAddButtonPressed,
                    child: Text('Add'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xff557c93))
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Kota>(HiveBoxes.city).listenable(),
                builder: (context, Box<Kota> box, _) {
                  if (box.values.isEmpty) {
                    return Center(
                      child: Text('City list is empty.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      Kota? city = box.getAt(index);
                      if (index == 0){
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          color: Color(0xff557c93),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherApp(city2: city.city)));
                              },
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                        city!.city,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        ),
                                    ),
                                  ],
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(Icons.location_on, color: Colors.white),
                                ),
                                subtitle: Text('${weatherData?.main?.temp != null ? (weatherData?.main?.temp ?? 0).toStringAsFixed(0) + '°C' : 'N/A'}')
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          color: Color(0xff557c93),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherApp(city2: city.city)));
                              },
                              child: ListTile(
                                title: Text(
                                    city!.city,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      _onDeleteButtonPressed(city);
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                ),
                                subtitle: Text('${weatherData?.main?.temp != null ? (weatherData?.main?.temp ?? 0).toStringAsFixed(0) + '°C' : 'N/A'}')
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
