import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class CardShimmer extends StatelessWidget {
  final double width;
  final double height;
  final Color baseColor = Color.fromARGB(121, 210, 209, 209);

  CardShimmer({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(milliseconds: 900),
      direction: ShimmerDirection.ltr,
      highlightColor: Color.fromARGB(255, 225, 225, 225),
      baseColor: baseColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: this.baseColor,
        ),
      ),
    );
  }
}