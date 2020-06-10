// import 'package:aibirdie/constants.dart';
import 'package:flutter/material.dart';
// import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/Dashboard/chips/Image_chip.dart';
import 'package:aibirdie/screens/Dashboard/chips/audio_chip.dart';
import 'package:aibirdie/screens/Dashboard/chips/overview_chip.dart';

class Dash extends StatefulWidget {
  final index;
  Dash(this.index);
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> with SingleTickerProviderStateMixin {
  // TabController controller;
  // var _lines = [
  //   "Your activity at a glance",
  //   "Images you have captured",
  //   "Audio clips recorded"
  // ];
  // var dynamicIcon = [
  //   Image.asset('images/dash.png', width: 80,),
  //   Image.asset('images/dash.png', width: 80,),
  //   Image.asset('images/dash.png', width: 80,),
    
  //   // Icon(Icons.view_quilt, size: 30,),
  //   // Icon(Icons.audiotrack, size: 30,),
    
  // ];

  final _pages = [
    OverviewChip(),
    ImageChip(),
    AudioChip(),
  ];

  @override
  void initState() {
    super.initState();
    // controller = TabController(length: 3, vsync: this,);
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 20),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
        //     children: <Widget>[
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           Text(
        //             "Dashboard",
        //             style: TextStyle(fontSize: 35, fontFamily: 'OS_semi_bold'),
        //           ),
        //           Text(_lines[_currentIndex], style: level2softdp),
        //         ],
        //       ),
        //       // dynamicIcon[_currentIndex],
        //     ],
        //   ),
        // ),
        // Container(
        //   height: 40,
        //   child: TabBar(
        //     controller: controller,
        //     indicator: BoxDecoration(
        //       color: softGreen,
        //       borderRadius: BorderRadius.circular(100),
        //     ),
        //     // indicator: CustomTabIndicator(),
        //     labelColor: Colors.white,
        //     labelStyle: level2softw,
        //     unselectedLabelColor: darkPurple,
        //     unselectedLabelStyle: level2softdp,
        //     onTap: ((index) => setState(() => _currentIndex = index)),

        //     tabs: <Widget>[
        //       Tab(
        //         text: "Overview",
        //         // child: Text("Overview"),
        //       ),
        //       Tab(
        //         text: "Image",
        //       ),
        //       Tab(
        //         text: "Audio",
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        _pages[widget.index],
      ],
    );
  }

  
}
