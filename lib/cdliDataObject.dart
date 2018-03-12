import 'dart:io';
import 'dart:async';

import 'dart:convert';

class cdliDataObject {
  final String date;
  final String thumbnail_url;
  final String url;
  final String blurb_title;
  final String theme;
  final String blurb;
  final String full_title;
  final String full_info;

  cdliDataObject({this.date, this.thumbnail_url, this.url, this.blurb_title, this.theme, this.blurb, this.full_title, this.full_info});

  static List<cdliDataObject> fromJsonArray(String covariant){
    List data = JSON.decode(covariant);
    List<cdliDataObject> result = [];
    for(var i=0; i<data.length; i++){
      result.add(new cdliDataObject(date: data[i]["date"],
          thumbnail_url: data[i]["thumbnail-url"],
          url: data[i]["url"],
          blurb_title: data[i]["blurb-title"],
          theme: data[i]["theme"],
          blurb: data[i]["blurb"],
          full_title: data[i]["full-title"],
          full_info: data[i]["full-info"]));
    }
    return result;
  }
}

class cdliDataState {
  List<cdliDataObject> list;
  bool loading;
  bool error;

  cdliDataState({
    this.list = const [],
    this.loading = true,
    this.error = false,
  });

  void reset(){
    this.list = [];
    this.loading = true;
    this.error = false;
  }

  Future<void> getDataFromAPI() async {
    try{
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse('http://cdli.ucla.edu/cdlitablet_android/fetchdata'));
      var response = await request.close();
      if(response.statusCode == HttpStatus.OK){
  var json = await response.transform(UTF8.decoder).join();
  this.list = cdliDataObject.fromJsonArray(json);
  this.loading = false;
  this.error = false;
  }
  else{
  this.list = [];
  this.loading = false;
  this.error = true;
  }
  } catch (exception) {
  this.list = [];
  this.loading = false;
  this.error = true;
  }
  }
}