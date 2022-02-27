import 'package:flutter/material.dart';
import 'package:solveitapp/data/author.dart';
import 'package:solveitapp/res/res.dart';

class AuthorWidget extends StatefulWidget {
  final String topText;
  final String authorId;

  const AuthorWidget({
    Key? key,
    required this.topText,
    required this.authorId,
  }) : super(key: key);

  @override
  State<AuthorWidget> createState() => _AuthorWidgetState();
}

class _AuthorWidgetState extends State<AuthorWidget> {
  late Author _author;

  @override
  void initState() {
    super.initState();
    retrieveAuthor();
  }

  void retrieveAuthor() {
    final a = Author.retrieveAuthor(widget.authorId);

    setState(() {
      _author = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final avatar = CircleAvatar(
      radius: DimensConst.avatarRadius,
      foregroundImage:
          _author.imageLink == null ? null : NetworkImage(_author.imageLink!),
      child: Text(_author.name[0]),
    );

    final text = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.topText, style: theme.textTheme.labelMedium),
        Text(_author.name, style: theme.textTheme.labelLarge),
      ],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avatar,
        Padding(
          padding: DimensConst.minimumLeftPadding,
          child: text,
        ),
      ],
    );
  }
}
