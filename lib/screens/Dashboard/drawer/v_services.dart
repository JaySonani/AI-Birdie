import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VServices extends StatelessWidget {
  static String namesData = '''Ahmedabad Animal Care Cheritable Trust
Amreli Comando Bird Helpline
Bhavnagar Animal Helpline
Chotila Animal Helpline
Dhandra Arizen Group Helpline
Diyodar vishva hindu parisad bajrang dal
Dwarka Bird Helpline
Halvadal Bird Helpline
Jamnagar Animal Helpline
Junagadh Jivdaya Chertitable Trust
Keshod Animal Helpline
Mahesana Animal Helpline
Mahuva Mahuva Panjra Pol
Muli Bird Helpline
Navsari Bhagvan Mahavir Karuna Manal
Porbandar Prakruti Youth Soiety
Rajkot Animal Helpline
Rajkot 2 Animal Helpline 2
Suraj Karadi Mithapur Bird Helpline
Surat Karuna''';

  static String contactsData = '''9727053682
9427735202
9157109109
9909198881
9925462562
8735965800
9426432208
9725579569
9227555108
9726622108
7777989222
8128104104
9157108108
9016333303
9408189697
8264101253
9898019059
9898499954
9904279898
2613131901''';

  final List names = namesData.split('\n').toList();
  final List contacts = contactsData.split('\n').toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: darkPurple,
        // elevation: 0.0,
        title: Text(
          "Veterinary Services Helpline",
          style: level2w.copyWith(fontSize: 20),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Image.asset('images/injured_bird.png'),
          ListView.builder(
            itemCount: names.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  "${names[index]}",
                  style: level2softdp,
                ),
                subtitle: Text(
                  "${contacts[index]}",
                  style: level2softdp,
                ),
                trailing: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.phoneAlt,
                      color: softGreen,
                    ),
                    onPressed: () {
                      launch("tel://${contacts[index]}");
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
