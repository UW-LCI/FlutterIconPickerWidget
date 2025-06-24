import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/controllers/icon_controller.dart';
import 'package:provider/provider.dart';
import 'multiple_icon_picker.dart';
import '../Models/icon_picker_icon.dart';
import '../Dialogs/fullscreen_dialog.dart';
import '../Dialogs/adaptive_dialog.dart';
import '../Helpers/color_brightness.dart';
import 'icon_picker.dart';
import 'search_bar.dart';
import '../Models/icon_pack.dart';

class FIPWidget extends StatelessWidget {
  const FIPWidget({
    super.key,
    required this.controller,
    this.selectedIconBackgroundColor,
    this.showSearchBar,
    this.routedView = false,
    this.showTooltips,
    this.barrierDismissible,
    this.iconSize,
    this.iconColor,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.iconPickerShape,
    this.backgroundColor,
    this.constraints,
    this.title,
    this.closeChild,
    this.searchIcon,
    this.searchHintText,
    this.searchClearIcon,
    this.searchComparator,
    this.noResultsText,
    this.iconPackMode,
    this.customIconPack,
    required this.onPicked,
  });

  final FIPIconController controller;
  final Color? selectedIconBackgroundColor;
  final bool? showSearchBar;
  final bool routedView;
  final bool? showTooltips;
  final bool? barrierDismissible;
  final double? iconSize;
  final Color? iconColor;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final ShapeBorder? iconPickerShape;
  final Color? backgroundColor;
  final BoxConstraints? constraints;
  final Widget? title;
  final Widget? closeChild;
  final Icon? searchIcon;
  final String? searchHintText;
  final Icon? searchClearIcon;
  final SearchComparator? searchComparator;
  final String? noResultsText;
  final List<IconPack>? iconPackMode;
  final Map<String, IconPickerIcon>? customIconPack;
  final Function(IconPickerIcon icon) onPicked;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (ctx, w) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: title!,
                      ),
                    ],
                  ),
                ),
                if (showSearchBar!)
                  FIPSearchBar(
                    iconController: controller,
                    iconPack: iconPackMode,
                    customIconPack: customIconPack,
                    searchIcon: searchIcon,
                    searchClearIcon: searchClearIcon,
                    searchHintText: searchHintText,
                    backgroundColor: backgroundColor,
                    searchComparator: searchComparator,
                  ),
                Expanded(
                  child: FIPMultipleIconPicker(
                    iconController: controller,
                    selectedIconBackgroundColor: selectedIconBackgroundColor,
                    showTooltips: showTooltips,
                    iconPack: iconPackMode,
                    customIconPack: customIconPack,
                    iconColor: iconColor,
                    backgroundColor: backgroundColor,
                    noResultsText: noResultsText,
                    iconSize: iconSize,
                    mainAxisSpacing: mainAxisSpacing,
                    crossAxisSpacing: crossAxisSpacing,
                    onPicked: onPicked,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
