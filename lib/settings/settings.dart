import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:gigs/settings/password.dart';
import 'package:gigs/themes/themes.dart';
import 'package:gigs/view/bottomSheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
    return Scaffold(
      //  backgroundColor: Color.fromARGB(255, 241, 241, 241),
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
      body: SingleChildScrollView(
        child: Padding(
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
              NotificationButton(),
              SizedBox(height: 16),
              SettingsCard(
                title: 'Dark Mode',
                description: 'Switch between light and dark themes',
              ),
              SizedBox(height: 16),
              PasswordCard(),
              SizedBox(height: 16),
              LogoutCard(),
                     SizedBox(height: 20),
            SizedBox(height: size.height/4,),
            Center(child: customPostButton(size)),
            ],
          ),
        ),
      ),
    );
  }

  Widget customPostButton(Size size) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.3,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF130160),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'SAVE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            15.0), // Adjust the value for more/less rounding
      ),
      child: ListTile(
        leading: Icon(Icons.dark_mode_outlined),
        title: Text(widget.title),
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

class NotificationButton extends StatefulWidget {
  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  bool _areNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            15.0), // Adjust the value for more/less rounding
      ),
      child: ListTile(
        leading: Icon(Icons.notifications_none),
        title: Text('Notifications'),
        trailing: Switch(
          value: _areNotificationsEnabled,
          onChanged: (value) {
            setState(() {
              _areNotificationsEnabled = value;
            });

            if (!value) {
              AppSettings.openAppSettings(type: AppSettingsType.notification);
            }
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

class PasswordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(Icons.lock_outline_rounded),
        title: Text('Password'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdatePasswordPage()));
        },
      ),
    );
  }
}

class LogoutCard extends StatefulWidget {
  @override
  State<LogoutCard> createState() => _LogoutCardState();
}

class _LogoutCardState extends State<LogoutCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(Icons.exit_to_app_rounded),
        title: Text('Logout'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            context: context,
            isScrollControlled: true,
            builder: (context) => bottomSheetForLogout(),
          );
        },
      ),
    );
  }
}
