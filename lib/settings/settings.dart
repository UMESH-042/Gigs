import 'package:flutter/material.dart';
import 'package:gigs/themes/themes.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationValue = true; // Initial notification value
  bool _darkModeValue = true; // Initial dark mode value

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
            SettingsCard(
              title: 'Notifications',
              description: 'Enable or disable notifications',
              initialValue: _notificationValue,
              onChanged: (value) {
                // Handle notification toggle change
                setState(() {
                  _notificationValue = value;
                });
              },
            ),
            SizedBox(height: 16),
            SettingsCard(
              title: 'Dark Mode',
              description: 'Switch between light and dark themes',
              initialValue: _darkModeValue,
              onChanged: (value) {
                // Handle dark mode toggle change
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(value);
                setState(() {
                  _darkModeValue = value;
                });
              },
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
  final bool initialValue; // Initial value for the toggle button
  final Function(bool) onChanged;

  const SettingsCard({
    Key? key,
    required this.title,
    required this.description,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text(widget.description),
        trailing: Switch(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
            widget.onChanged(newValue);
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
