import 'package:flutter/material.dart';
import 'package:gigs/themes/themes.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
            Text(
              '   Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            // SettingsCard(
            //   title: 'Notifications',
            //   description: 'Enable or disable notifications',
            //   initialValue: _notificationValue,
            //   onChanged: (value) {
            //     // Handle notification toggle change
            //     setState(() {
            //       _notificationValue = value;
            //     });
            //   },
            // ),
            SizedBox(height: 16),
            SettingsCard(
              title: 'Dark Mode',
              description: 'Switch between light and dark themes',
            ),
            // ... other settings cards
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatefulWidget {
  final String title;
  final String description;

  const SettingsCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);

    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text(widget.description),
        trailing: Switch(
          value: themeprovider.isDarkMode,
          onChanged: (value) {
  
            final provider = Provider.of<ThemeProvider>(context, listen: false);
            provider.toggleTheme(value);
          },
          activeColor: Colors.green, // Color when the switch is ON
          inactiveThumbColor:
              Colors.black, // Color of the thumb when the switch is OFF
          inactiveTrackColor:
              Colors.grey, // Color of the track when the switch is OFF
        ),
      ),
    );
  }
}



