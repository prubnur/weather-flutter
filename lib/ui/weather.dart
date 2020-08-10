import 'dart:convert';
import 'package:weather/util/date_formatter.dart';

import '../util/utils.dart' as util;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=55077add583da0dd928c6ad9b0dd63bb&units=metric

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _city;

  Future _goToNext(BuildContext context) async {
    Map results = await Navigator.of(context).push(
        new MaterialPageRoute<Map>(builder: (BuildContext context) {
          return new ChangeCity();
        })
    );
    if (results != null && results.containsKey('enter')) {
      setState(() {
        _city = results['enter'];
      });
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Weather",
        style: TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.location_city),
              color: Colors.black,
              onPressed: () {
                _goToNext(context);
              }
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              updateTempWidget(_city)
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: forecastWidget(_city),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        ],
      )
//      body: Flex(
//        direction: Axis.vertical,
//        children: <Widget>[
//          Expanded(
//            child: Column(
//              children: <Widget>[
//                updateTempWidget(_city),
//                Flexible(
//                  child: forecastWidget(_city),
//                )
//
//              ],
//            ),
//          ),
//        ],
//      )
    );
  }


  Future<Map> getWeather(String city) async {
    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${util.appId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Future<Map> getForecast(String city) async {
    String apiUrl = "http://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=${util.appId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  ListTile(
                    title: Center(
                      child: Text(city == null ? util.defaultCity : city,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text("${content['weather'][0]['main']}",
                        style: TextStyle(
                            fontSize: 40
                        ),),
                    ),
                    subtitle: Center(
                      child: Text("${content['weather'][0]['description']}",
                        style: TextStyle(
                          fontSize: 25
                        ),),
                    ),
                  ),
                  Container(
                    child: Image.network("http://openweathermap.org/img/wn/${content['weather'][0]['icon']}@2x.png"),
                  ),
                  new ListTile(
                    title: Center(
                      child: new Text("${double.parse(content['main']['temp'].toString()).toStringAsFixed(0)}°C",
                        style: tempStyle(),),
                    ),
                    subtitle: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Min: ${double.parse(content['main']['temp_min'].toString()).toStringAsFixed(0)}°C",
                          style: TextStyle(
                            fontSize: 25
                          ),),
                          Text("Max: ${double.parse(content['main']['temp_max'].toString()).toStringAsFixed(0)}°C",
                            style: TextStyle(
                                fontSize: 25
                            ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          else {
            return new Container();
          }
        });
  }


  Widget forecastWidget(String city) {
    return new FutureBuilder(
        future: getForecast(city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              height: 220.0,
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: content['cnt'],
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Card(
//                    color: Colors.brown[50],
                    child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(content['list'][index]['weather'][0]['main'],
                            style: TextStyle(
                              fontSize: 20
                            ),),
                            Text(content['list'][index]['weather'][0]['description'],
                              style: TextStyle(
                                fontSize: 15
                              ),),
                            Container(
                              child: Image.network("http://openweathermap.org/img/wn/${content['list'][index]['weather'][0]['icon']}.png"),
                            ),
                            Text(double.parse(content['list'][index]['main']['temp'].toString()).toStringAsFixed(0)+"°C",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black
                              ),),
                            Text(dateFormatted(content['list'][index]['dt']),
                              style: TextStyle(
                                fontSize: 15
                              ),),
                            Text(timeFormatted(content['list'][index]['dt']),
                              style: TextStyle(
                              ),),
                          ],
                        ),
                    ),
                  )
              ),
            );
          }
          else {
            return new Container();
          }
        });
  }

}

class ChangeCity extends StatelessWidget {
  var _cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: new Text('Change City',
        style: TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    labelText: "Enter City",
                  ),
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'enter' : _cityController.text
                    });
                  },
                  color: Colors.black,
                  child: Text("Get Weather",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.black,
      fontSize: 42.9,
      fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.black,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 55,
  );
}