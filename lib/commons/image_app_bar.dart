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
  static const _widthBound = 600.0;

  double? _viewWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > _widthBound) {
      _viewWidth = screenWidth * 2 / 3;
    }
  }

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
          body: Center(
            child: SizedBox(
              width: _viewWidth,
              child: widget.child,
            ),
          ),
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
