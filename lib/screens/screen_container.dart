import 'package:flutter/material.dart';

class ScreenContainer extends StatefulWidget {
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
  State<ScreenContainer> createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null
          ? AppBar(
              title: Text(widget.title!,
                  style: Theme.of(context).textTheme.titleLarge),
            )
          : null,
      body: SafeArea(
        child: widget.isScrollEnabled
            ? ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                children: widget.children,
              )
            : Column(
                children: widget.children,
              ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
