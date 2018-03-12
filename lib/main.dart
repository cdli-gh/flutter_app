import 'package:cdli_flutter/cdliDataObject.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(title: 'Flutter CDLI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cdliDataState dataState = new cdliDataState();
  BuildContext context;

  @override
  void initState() {
    super.initState();
    getDataFromAPI();
  }

  getDataFromAPI() async {
    if(!mounted) return;
    await dataState.getDataFromAPI();
    setState((){
      if(dataState.error){
        _showError();
      }
    });
  }

  Widget _getErrorState(){
    return new Center(
      child: new Row(),
    );
  }

  _retry(){
    Scaffold.of(context).removeCurrentSnackBar();
    dataState.reset();
    setState((){});
    getDataFromAPI();
  }

  void _showError(){
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("An unknown error occurred"),
        duration: new Duration(days: 1), // Make it permanent
        action: new SnackBarAction(
            label : "RETRY",
            onPressed : (){_retry();}
        )
    ));
  }

  Widget _getSuccessStateWidget(){
    Color color = Theme.of(context).primaryColor;
    return new ListView.builder(
        itemCount: dataState.list.length,
        itemBuilder: (context, index){
          return new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              new Image.network(dataState.list[index].thumbnail_url),

              new Text(dataState.list[index].blurb_title,
              style: new TextStyle(fontWeight: FontWeight.bold)),

              new Divider()
            ]
          );
        });
  }

  Widget _getLoadingStateWidget(){
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget getCurrentStateWidget(){
    Widget currentStateWidget;
    if(!dataState.error && !dataState.loading){
      currentStateWidget = _getSuccessStateWidget();
    }
    else if(!dataState.error){
      currentStateWidget = _getLoadingStateWidget();
    }
    else{
      currentStateWidget = _getErrorState();
    }

    return currentStateWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = getCurrentStateWidget();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('FeedMe'),
        ),
        body: new Builder(builder: (BuildContext context){
          this.context = context;
          return currentWidget;
        })
    );
  }

}
