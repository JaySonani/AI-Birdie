import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';

class SupportedSpecies extends StatefulWidget {
  @override
  _SupportedSpeciesState createState() => _SupportedSpeciesState();
}

class _SupportedSpeciesState extends State<SupportedSpecies>
    with SingleTickerProviderStateMixin {
  TabController tc;
  List imageSpecies = [];
  List audioSpecies = [];
  List commonSpecies = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    tc = TabController(length: 3, vsync: this);
    loadJsonFile();
  }

  void loadJsonFile() async {
    final speciesList = jsonDecode(await DefaultAssetBundle.of(context)
        .loadString("assets/supported_species.json"));

    setState(() {
      imageSpecies.addAll(speciesList['imageSpecies']);
      audioSpecies.addAll(speciesList['audioSpecies']);
      commonSpecies.addAll(speciesList['commonSpecies']);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: darkPurple,
        // elevation: 0.0,
        title: Text(
          "List of supported species",
          style: level2w.copyWith(fontSize: 20),
        ),
        bottom: TabBar(
          indicatorColor: softGreen,
          indicatorWeight: 5.0,
          labelColor: Colors.white,
          labelStyle: level2softdp,
          unselectedLabelColor: Colors.white,
          unselectedLabelStyle: level2softdp,
          controller: tc,
          tabs: <Widget>[
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Image"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.image),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Audio"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.music_note),
                ],
              ),
            ),
                        Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Common"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.chrome_reader_mode),
                ],
              ),
            ),

          ],
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(darkPurple),
                strokeWidth: 2.0,
              ),
            )
          : TabBarView(
              controller: tc,
              children: [
                Center(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemCount: imageSpecies.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-6.00, -6.00),
                              color: Color(0xffffffff).withOpacity(0.80),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                              offset: Offset(6.00, 6.00),
                              color: Color(0xff000000).withOpacity(0.20),
                              blurRadius: 10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15.00),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: softGreen,
                            child: Text(
                              "${index + 1}",
                              style: level2softw,
                            ),
                          ),
                          title: Text(
                            imageSpecies[index],
                            style: level2softdp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemCount: audioSpecies.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-6.00, -6.00),
                              color: Color(0xffffffff).withOpacity(0.80),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                              offset: Offset(6.00, 6.00),
                              color: Color(0xff000000).withOpacity(0.20),
                              blurRadius: 10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15.00),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: softGreen,
                            child: Text(
                              "${index + 1}",
                              style: level2softw,
                            ),
                          ),
                          title: Text(
                            audioSpecies[index],
                            style: level2softdp,
                          ),
                        ),
                      );
                    },
                  ),
                ),Center(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemCount: commonSpecies.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-6.00, -6.00),
                              color: Color(0xffffffff).withOpacity(0.80),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                              offset: Offset(6.00, 6.00),
                              color: Color(0xff000000).withOpacity(0.20),
                              blurRadius: 10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15.00),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: softGreen,
                            child: Text(
                              "${index + 1}",
                              style: level2softw,
                            ),
                          ),
                          title: Text(
                            commonSpecies[index],
                            style: level2softdp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
