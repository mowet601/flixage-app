import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
