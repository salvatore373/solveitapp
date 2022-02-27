import 'package:flutter/material.dart';
import 'package:solveitapp/data/author.dart';
import 'package:solveitapp/data/review.dart';
import 'package:solveitapp/res/res.dart';

/// A UI card with a minimalistic design
class MinimalCard extends StatelessWidget {
  final String mainText;
  final String? subtitle;
  final IconData? icon;
  final String? iconPath;
  final bool? centeredText;
  final GestureTapCallback? onTap;
  final MinimalCardColorScheme color;

  const MinimalCard({
    Key? key,
    required this.mainText,
    this.subtitle,
    this.icon,
    this.iconPath,
    this.centeredText,
    this.onTap,
    this.color = MinimalCardColorScheme.tertiary,
  }) : super(key: key);

  Color _getTitleColor() {
    switch (color) {
      case MinimalCardColorScheme.primary:
      case MinimalCardColorScheme.secondary:
        return Colors.white;
      case MinimalCardColorScheme.tertiary:
        return Colors.black;
    }
  }

  Color _getSubtitleColor(ThemeData theme) {
    switch (color) {
      case MinimalCardColorScheme.primary:
      case MinimalCardColorScheme.secondary:
      case MinimalCardColorScheme.tertiary:
        return (theme.textTheme.caption?.color)!;
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch (color) {
      case MinimalCardColorScheme.primary:
      case MinimalCardColorScheme.secondary:
        return Colors.white;
      case MinimalCardColorScheme.tertiary:
        return theme.colorScheme.primary;
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (color) {
      case MinimalCardColorScheme.primary:
        return theme.colorScheme.primary;
      case MinimalCardColorScheme.secondary:
        return theme.colorScheme.secondary;
      case MinimalCardColorScheme.tertiary:
        return theme.colorScheme.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget iconW;
    if (icon == null && iconPath == null) {
      iconW = Container();
    } else {
      if (icon != null) {
        iconW = Icon(
          icon!,
          size: 33.0,
          color: _getIconColor(theme),
        );
      } else {
        // iconPath != null
        iconW = Image.asset(
          iconPath!,
          height: 33.0,
          width: 33.0,
          color: _getIconColor(theme),
          fit: BoxFit.contain,
        );
      }
    }

    final titleW = Text(
      mainText,
      style: theme.textTheme.titleLarge?.copyWith(
        color: _getTitleColor(),
      ),
    );

    Widget subtitleW;
    if (subtitle == null) {
      subtitleW = Container();
    } else {
      subtitleW = Text(
        subtitle!,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.normal,
          color: _getSubtitleColor(theme),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        textAlign: centeredText == true ? TextAlign.center : null,
      );
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null || iconPath != null)
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: iconW,
          ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: centeredText == true
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              titleW,
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: subtitleW,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Card(
      color: _getBackgroundColor(theme),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: onTap,
        child: Container(
          padding: DimensConst.largeOverallPadding,
          child: content,
        ),
      ),
    );
  }
}

enum MinimalCardColorScheme { primary, secondary, tertiary }

class MinimalStarsSet extends StatelessWidget {
  final int highlightedStars;
  final int stars;

  const MinimalStarsSet({
    Key? key,
    required this.highlightedStars,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final starsSet = List.generate(
      stars,
      (index) => Icon(
        index < highlightedStars ? Icons.circle : Icons.circle_outlined,
        color: theme.colorScheme.primary,
        size: 16.0,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: starsSet,
    );
  }
}

class MinimalListTile extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  final IconData? leadingIcon;
  final bool colorWithPrimary;

  const MinimalListTile({
    Key? key,
    required this.title,
    this.trailing,
    this.leadingIcon,
    this.onTap,
    this.colorWithPrimary = false,
  }) : super(key: key);

  Color _getBackgroundColor(ThemeData theme) =>
      colorWithPrimary ? theme.colorScheme.primary : theme.colorScheme.surface;

  Color _getContentColor(ThemeData theme) => colorWithPrimary
      ? theme.colorScheme.onPrimary
      : theme.colorScheme.onSurface;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final titleW = Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: _getContentColor(theme),
      ),
    );

    Widget? leading;
    if (leadingIcon != null) {
      leading = CircleAvatar(
        child: Icon(
          leadingIcon,
          size: DimensConst.avatarRadius,
          color: _getBackgroundColor(theme),
        ),
        radius: DimensConst.avatarRadius,
        backgroundColor: colorWithPrimary
            ? theme.colorScheme.surface
            : theme.colorScheme.primary,
      );
    }

    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(width: 1.5, color: theme.colorScheme.tertiary),
        color: colorWithPrimary ? theme.colorScheme.primary : null,
      ),
      child: ListTile(
        textColor: _getContentColor(theme),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12.0),
        minVerticalPadding: 0.0,
        title: titleW,
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}

class MinimalDoubleButton extends StatelessWidget {
  final String firstBtnText;
  final IconData? firstBtnIcon;
  final String? firstBtnIconPath;
  final GestureTapCallback? onTapFirst;

  final String secondBtnText;
  final IconData? secondBtnIcon;
  final String? secondBtnIconPath;
  final GestureTapCallback? onTapSecond;

  const MinimalDoubleButton({
    Key? key,
    required this.firstBtnText,
    this.firstBtnIcon,
    this.firstBtnIconPath,
    this.onTapFirst,
    required this.secondBtnText,
    this.secondBtnIcon,
    this.secondBtnIconPath,
    this.onTapSecond,
  })  : super(key: key);

  Widget _getBtn(bool isFirst, ThemeData theme) {
    String? btnIconPath = isFirst ? firstBtnIconPath : secondBtnIconPath;
    IconData? btnIcon = isFirst ? firstBtnIcon : secondBtnIcon;
    String btnText = isFirst ? firstBtnText : secondBtnText;
    Color contentColor =
        isFirst ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    Widget? icon;
    if (btnIcon != null) {
      icon = Icon(
        btnIcon,
        size: 18.0,
        color: contentColor,
      );
    } else if (btnIconPath != null){
      icon = Image.asset(
        btnIconPath,
        height: 18.0,
        width: 18.0,
        fit: BoxFit.contain,
        color: contentColor,
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: isFirst ? onTapFirst : onTapSecond,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color:
              isFirst ? theme.colorScheme.primary : theme.colorScheme.surface,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(icon != null) icon,
            Flexible(
              child: Padding(
                padding: DimensConst.minimumLeftPadding,
                child: Text(
                  btnText,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: contentColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: DimensConst.minimumOverallPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _getBtn(true, theme)),
            Expanded(child: _getBtn(false, theme)),
          ],
        ),
      ),
    );
  }
}

class TitledSection extends StatelessWidget {
  final String title;
  final Widget child;

  const TitledSection({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        Padding(
          padding: DimensConst.minimumTopPadding,
          child: child,
        ),
      ],
    );
  }
}

class MinimalReviewCard extends StatefulWidget {
  final Review review;

  const MinimalReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  State<MinimalReviewCard> createState() => _MinimalReviewCardState();
}

class _MinimalReviewCardState extends State<MinimalReviewCard> {
  late Author _author;

  @override
  void initState() {
    super.initState();
    _retrieveAuthor();
  }

  void _retrieveAuthor() {
    final a = Author.retrieveAuthor(widget.review.userId);

    setState(() {
      _author = a;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final stars = MinimalStarsSet(
      highlightedStars: widget.review.stars,
      stars: 5,
    );

    final text = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${_author.name} - ${widget.review.title}",
          style: theme.textTheme.titleMedium?.copyWith(
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 2,
        ),
        Padding(
          padding: DimensConst.minimumTopPadding,
          child: Text(
            widget.review.text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.caption?.color,
            ),
          ),
        ),
      ],
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        stars,
        Padding(
          padding: DimensConst.mediumTopPadding,
          child: text,
        ),
      ],
    );

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          // TODO: add edit route (only if the user is the
          // author of this review)
        },
        child: Container(
          padding: DimensConst.mediumOverallPadding,
          child: content,
        ),
      ),
    );
  }
}
