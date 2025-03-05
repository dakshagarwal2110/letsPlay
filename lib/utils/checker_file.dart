import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SVG Image Test")),
      body: Center(
        child: SvgPicture.network(
          'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/displayWebStats.svg',
          height: 100, // Adjust as needed
          width: 100,
          placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
