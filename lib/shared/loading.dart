import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      child: Center(
        child: SpinKitFadingCircle(
          color: isDarkMode ? Colors.tealAccent : Colors.blueAccent,
          size: 50,
        ),
      ),
    );
  }
}
