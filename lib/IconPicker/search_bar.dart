/// IconSearchbar
/// Author Rebar Ahmad
/// https://github.com/Ahmadre
/// rebar.ahmad@gmail.com

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Helpers/icon_pack_manager.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/controllers/icon_controller.dart';
import 'package:provider/provider.dart';
import '../Models/icon_pack.dart';

class FIPSearchBar extends StatefulWidget {
  const FIPSearchBar({
    required this.iconController,
    required this.iconPack,
    required this.searchHintText,
    required this.searchIcon,
    required this.searchClearIcon,
    required this.backgroundColor,
    this.customIconPack,
    this.searchComparator,
    super.key,
  });

  final FIPIconController iconController;
  final List<IconPack>? iconPack;
  final Map<String, IconPickerIcon>? customIconPack;
  final String? searchHintText;
  final Icon? searchIcon;
  final Icon? searchClearIcon;
  final Color? backgroundColor;
  final SearchComparator? searchComparator;

  @override
  _FIPSearchBarState createState() => _FIPSearchBarState();
}

class _FIPSearchBarState extends State<FIPSearchBar> {
  final SearchComparator _defaultSearchComparator =
      (String searchValue, IconPickerIcon icon) =>
          icon.name.toLowerCase().contains(searchValue.toLowerCase());
  late final searchComparator =
      widget.searchComparator ?? _defaultSearchComparator;

  void _search(String searchValue) {
    List<MapEntry<String, IconPickerIcon>> searchResult = [];

    final Iterable<MapEntry<String, IconPickerIcon>> flatFIPPacks = widget
            .iconPack
            ?.expand((pack) => IconPackManager.getIcons(pack).entries) ??
        [];
    final flatCustomPacks = widget.customIconPack?.entries ?? [];

    for (MapEntry<String, IconPickerIcon> item in flatFIPPacks) {
      if (searchComparator.call(
          searchValue,
          IconPickerIcon(
              name: item.key, data: item.value.data, pack: item.value.pack))) {
        searchResult.add(item);
      }
    }

    for (var item in flatCustomPacks) {
      if (searchComparator.call(
          searchValue,
          IconPickerIcon(
              name: item.key,
              data: item.value.data,
              pack: IconPack.custom.name))) {
        searchResult.add(item);
      }
    }

    setState(() {
      if (searchResult.isNotEmpty) {
        widget.iconController.icons = searchResult;
      } else {
        if (searchValue != '') {
          widget.iconController.removeAll();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FIPIconController>(builder: (ctx, controller, _) {
      return TextField(
        onChanged: (val) => _search(val),
        controller: controller.searchTextController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15),
          hintText: widget.searchHintText,
          prefixIcon: widget.searchIcon,
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.searchTextController.text.isNotEmpty
                ? IconButton(
                    icon: widget.searchClearIcon!,
                    onPressed: () => setState(() {
                      controller.searchTextController.clear();
                      if (widget.customIconPack != null) {
                        controller.addAll(widget.customIconPack ?? {});
                      }

                      if (widget.iconPack != null) {
                        for (var pack in widget.iconPack!) {
                          controller.addAll(IconPackManager.getIcons(pack));
                        }
                      }
                    }),
                  )
                : const SizedBox(
                    width: 10,
                  ),
          ),
        ),
      );
    });
  }
}
