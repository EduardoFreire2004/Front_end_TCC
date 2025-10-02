
import 'package:flutter/material.dart';

class ListConfig {

  static const double defaultScrollbarThickness = 6.0;
  static const double defaultScrollbarRadius = 8.0;

  static const EdgeInsets defaultListPadding = EdgeInsets.all(16.0);
  static const EdgeInsets defaultItemPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  static const double defaultItemHeight = 72.0;
  static const double compactItemHeight = 56.0;
  static const double largeItemHeight = 88.0;

  static const double defaultDividerHeight = 1.0;
  static const double defaultDividerIndent = 16.0;
  static const double defaultDividerEndIndent = 16.0;

  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  static const ScrollPhysics defaultScrollPhysics = BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
  );

  static Scrollbar defaultScrollbar({
    required Widget child,
    ScrollController? controller,
    bool? thumbVisibility,
    bool? trackVisibility,
  }) {
    return Scrollbar(
      controller: controller,
      thickness: defaultScrollbarThickness,
      radius: const Radius.circular(defaultScrollbarRadius),
      thumbVisibility: thumbVisibility ?? true,
      trackVisibility: trackVisibility ?? false,
      child: child,
    );
  }

  static Widget defaultDivider() {
    return Divider(
      height: defaultDividerHeight,
      indent: defaultDividerIndent,
      endIndent: defaultDividerEndIndent,
    );
  }

  static ListView defaultListView({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    ScrollController? controller,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return ListView(
      controller: controller,
      padding: padding ?? defaultListPadding,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      children: children,
    );
  }

  static ListView defaultSeparatedListView({
    required List<Widget> children,
    required Widget Function(BuildContext, int) separatorBuilder,
    EdgeInsetsGeometry? padding,
    ScrollController? controller,
  }) {
    return ListView.separated(
      controller: controller,
      padding: padding ?? defaultListPadding,
      itemCount: children.length,
      separatorBuilder: separatorBuilder,
      itemBuilder: (context, index) => children[index],
    );
  }
}

