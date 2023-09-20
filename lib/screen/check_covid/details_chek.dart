import 'package:flutter/material.dart';

class DetailsCheckScreen extends StatefulWidget {
  final bool showDetailsButton;

  const DetailsCheckScreen({Key? key, this.showDetailsButton = false, required String weight, required String temperature})
      : super(key: key);

  @override
  _DetailsCheckScreenState createState() => _DetailsCheckScreenState();
}

class _DetailsCheckScreenState extends State<DetailsCheckScreen> {
  // This can be any state properties or methods specific to this screen.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details Check"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // This is an example Text widget, you can replace it with any other widget you want.
            Text(
                "This is the details check screen. Here you can see the details."),

            SizedBox(height: 20),

            // Conditional rendering of the View Details button based on the flag
            widget.showDetailsButton
                ? ElevatedButton(
                    onPressed: () {
                      // Implement what should happen when this button is pressed.
                    },
                    child: Text("View Details"),
                  )
                : Container(), // Empty container if the button shouldn't be shown.

            // You can add more widgets here for your screen layout.
            // For instance, images, lists, or any other components.
          ],
        ),
      ),
    );
  }
}
