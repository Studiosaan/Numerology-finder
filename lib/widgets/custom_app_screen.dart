import 'package:flutter/material.dart';
import 'package:numerology/screens/info_screen.dart';
import 'package:numerology/screens/setting_screen.dart';

// This widget was converted to a StatefulWidget to manage the state of the BottomNavigationBar.
class CustomAppScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget body; // This will be the "Home" page content.
  final Color? iconColor;

  const CustomAppScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.body,
    this.iconColor,
  });

  @override
  State<CustomAppScreen> createState() => _CustomAppScreenState();
}

class _CustomAppScreenState extends State<CustomAppScreen> {
  int _selectedIndex = 0; // State for the currently selected tab index.

  // This method updates the state when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of widgets to display in the body, corresponding to the tabs.
    final List<Widget> _widgetOptions = <Widget>[
      widget.body, // The original body is now the Home screen (index 0).
      const SettingScreen(), // Placeholder for Settings screen.
      const InfoScreen(), // Placeholder for Info screen.
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.iconColor ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        // The body now displays the widget from the list based on the selected index.
        child: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      // The new BottomNavigationBar.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '세팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: '인포',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Making the navigation bar look good with the app's theme.
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
