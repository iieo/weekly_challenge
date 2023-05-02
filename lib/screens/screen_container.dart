import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  final String? title;
  final Widget? floatingActionButton;
  final List<Widget> children;
  final bool isScrollEnabled;
  const ScreenContainer(
      {super.key,
      required this.children,
      this.title,
      this.floatingActionButton,
      this.isScrollEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title:
                  Text(title!, style: Theme.of(context).textTheme.titleLarge),
            )
          : null,
      body: SafeArea(
        child: isScrollEnabled
            ? ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                children: children,
              )
            : Column(
                children: children,
              ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
