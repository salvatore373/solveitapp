import 'package:flutter/material.dart';
import 'package:solveitapp/res/res.dart';

class ImageAppBar extends StatefulWidget {
  final List<String>? imagesUrl;
  final String title;
  final Widget child;
  final List<Widget>? appBarActions;

  const ImageAppBar({
    Key? key,
    required this.title,
    required this.child,
    this.imagesUrl,
    this.appBarActions,
  }) : super(key: key);

  @override
  _ImageAppBarState createState() => _ImageAppBarState();
}

class _ImageAppBarState extends State<ImageAppBar> {
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    Widget background;
    if (widget.imagesUrl == null || widget.imagesUrl?.isEmpty == true) {
      background = Container(
        color: _theme.colorScheme.primary,
      );
    } else {
      background = Image.network(
        widget.imagesUrl![0],
        fit: BoxFit.cover,
        height: DimensConst.headerWidgetHeight,
      );
    }

    return Scaffold(
      body: NestedScrollView(
          body: widget.child,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: DimensConst.headerWidgetHeight,
                floating: true,
                pinned: true,
                snap: true,
                actions: widget.appBarActions,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.title),
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[background],
                  ),
                ),
              )
            ];
          }),
    );
  }
}
