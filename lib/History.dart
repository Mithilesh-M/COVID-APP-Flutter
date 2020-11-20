import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Drawer.dart';
import './main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './User Credentials.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[700],
            ),
            height: 50,
            width: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(),
                  new Text(
                    "Loading",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var app_bar=AppBar(
    backgroundColor: Colors.grey[900],
    title: Text('COVID X-RAY PREDICTOR'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: app_bar,
      drawer: drawer(),
      body: Builder(
        builder: (contextHist) => RefreshIndicator(
          onRefresh: () async {
            await history.get_history();
            Scaffold.of(contextHist)
                .showSnackBar(SnackBar(content: Text("Refreshed.")));
            setState(() {
              print('Refreshed');
            });
          },
          child: history.count != 0
              ? ListView.builder(
                  itemCount: history.count,
                  itemBuilder: (BuildContext contextlist, int index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: UniqueKey(),
                      onDismissed: (direction) async {
                        _onLoading();
                        await history.delete_history(index);
                        Navigator.pop(context);
                        setState(() {});
                        Scaffold.of(contextlist).showSnackBar(
                            SnackBar(content: Text("Result Deleted.")));
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          size: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.05,
                        ),
                      ),
                      child: ListTile(
                        tileColor: Colors.grey[500],
                        leading: Icon(
                          Icons.circle,
                          color:
                              history.predictions[index]['Result'] == 'Negative'
                                  ? Colors.green
                                  : Colors.red,
                          size: (MediaQuery.of(context).size.height -
                              app_bar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) *
                              0.04,
                        ),
                        trailing: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: (MediaQuery.of(context).size.height -
                                  app_bar.preferredSize.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom) *
                                  0.03,
                            ),
                            Text(
                              history.predictions[index]['Date'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.03),
                            ),
                          ],
                        ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.accessibility,
                                  size: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.0325,
                                ),
                                Text(
                                  history.predictions[index]['Result'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (MediaQuery.of(context).size.height -
                                          app_bar.preferredSize.height -
                                          MediaQuery.of(context).padding.top -
                                          MediaQuery.of(context).padding.bottom) *
                                          0.03,),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.av_timer_rounded,
                                  size: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.0325,
                                ),
                                Text(
                                  history.predictions[index]['Time'],
                                  style: TextStyle(
                                      fontSize:
                                      (MediaQuery.of(context).size.height -
                                          app_bar.preferredSize.height -
                                          MediaQuery.of(context).padding.top -
                                          MediaQuery.of(context).padding.bottom) *
                                          0.03),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : SingleChildScrollView(
                  child: Container(
                    width: (MediaQuery.of(context).size.width -
                        MediaQuery.of(context).padding.left -
                        MediaQuery.of(context).padding.right) *
                        0.96,
                    height: (MediaQuery.of(context).size.height -
                        app_bar.preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom) *
                        1.05,
                    child: Center(
                      child: Container(
                        height: (MediaQuery.of(context).size.height -
                            app_bar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                            0.5,
                        width: (MediaQuery.of(context).size.width -
                            MediaQuery.of(context).padding.left -
                            MediaQuery.of(context).padding.right) *
                            0.75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                image: AssetImage('Assets/Image/History.png'),
                                height:
                                (MediaQuery.of(context).size.height -
                                    app_bar.preferredSize.height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) *
                                    0.35),
                            Text(
                              'No History Found',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.height -
                                      app_bar.preferredSize.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom) *
                                      0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
