import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/helpers/app_extension.dart';
import 'package:xtridelink_driver/core/helpers/app_helper.dart';
import 'package:xtridelink_driver/core/theme/app_colors.dart';
import 'package:xtridelink_driver/core/theme/app_textstyle.dart';
import 'package:xtridelink_driver/core/widgets/app_bars/app_bar_bottom_sheet.dart';
import 'package:xtridelink_driver/core/widgets/bottom_sheet_picker/modal_list_item.dart';
import 'package:xtridelink_driver/core/widgets/buttons/animation_button_effect.dart';
import 'package:xtridelink_driver/core/widgets/custom_text_field.dart';

class BottomSheetPicker<T> extends StatefulWidget {
  const BottomSheetPicker({
    required this.label,
    required this.items,
    super.key,
    this.hint = '',
    this.onItemSelected,
    this.value,
    this.showSearch = false,
  });

  final String label;
  final List<ModalListItem<T>> items;
  final T? value;
  final ValueChanged<T>? onItemSelected;
  final String? hint;
  final bool showSearch;

  @override
  State<BottomSheetPicker<T>> createState() => _BottomSheetPickerState<T>();
}

class _BottomSheetPickerState<T> extends State<BottomSheetPicker<T>> {
  late List<ModalListItem<T>> _items;
  T? _selectedValue;

  @override
  void initState() {
    _items = widget.items;
    _selectedValue = widget.value;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomSheetPicker<T> oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
    if (oldWidget.items.length != widget.items.length) {
      setState(() {
        _items = widget.items;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  String? get selectedValueTitle => _items.isNotEmpty && _selectedValue != null
      ? _items.where((element) => element.value == _selectedValue).isNotEmpty
          ? _items
              .where((element) => element.value == _selectedValue)
              .first
              .title
          : null
      : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTextStyle.body1.copyWith(
            fontSize: 12,
            color: AppColors.black,
          ),
        ),
        5.vSpaceBox,
        AnimationButtonEffect(
          child: GestureDetector(
            onTap: _items.isNotEmpty
                ? () {
                    WidgetsBinding.instance.focusManager.primaryFocus
                        ?.unfocus();
                    AppHelper.showCustomModalBottomSheet<T>(
                      context: context,
                      isDrag: !widget.showSearch,
                      modal: BottomSheetListPickerView(
                        label: widget.label,
                        items: _items,
                        showSearch: widget.showSearch,
                        onItemSelected: (value) {
                          widget.onItemSelected?.call(value.value);
                          setState(() {
                            _selectedValue = value.value;
                          });
                        },
                      ),
                      isDarkMode: false,
                    );
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // color: AppColors.grey.withOpacity(0.4),
                border: Border.all(
                  color: AppColors.grey3.withOpacity(0.4),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedValueTitle ?? widget.hint ?? widget.label,
                      style: TextStyle(
                        color: _selectedValue != null ? null : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.grey4,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomSheetListPickerView<T> extends StatefulWidget {
  const BottomSheetListPickerView({
    required this.label,
    required this.items,
    required this.showSearch,
    super.key,
    this.onItemSelected,
  });

  final String label;
  final List<ModalListItem<T>> items;
  final ValueChanged<ModalListItem<T>>? onItemSelected;
  final bool showSearch;

  @override
  State<BottomSheetListPickerView<T>> createState() =>
      _BottomSheetListPickerViewState<T>();
}

class _BottomSheetListPickerViewState<T>
    extends State<BottomSheetListPickerView<T>> {
  late List<ModalListItem<T>> _items;
  late TextEditingController _editingController;
  String _query = '';

  @override
  void initState() {
    _items = widget.items;
    _editingController = TextEditingController();
    _editingController.addListener(() {
      setState(() {
        _query = _editingController.text;
      });
    });
    super.initState();
  }

  List<ModalListItem<T>> get filteredItems => _items
      .where((element) =>
          element.title.toLowerCase().contains(_query.trim().toLowerCase()))
      .toList();

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarBottomSheet(title: widget.label),
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CustomTextField(
                textController: _editingController,
                hint: 'Search',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          if (widget.showSearch)
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => 12.vSpaceBox,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return AnimationButtonEffect(
                    child: GestureDetector(
                      onTap: () {
                        widget.onItemSelected?.call(item);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.iconLemon.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Text(item.title),
                      ),
                    ),
                  );
                },
                //physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredItems.length,
              ),
            )
          else
            ListView.separated(
              separatorBuilder: (context, index) => 12.vSpaceBox,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return AnimationButtonEffect(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onItemSelected?.call(item);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.iconLemon.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),
                      child: Row(
                        children: [
                          Text(item.title),
                          const Spacer(),
                          if (item.isLocked ?? false)
                            const Icon(
                              Icons.lock_rounded,
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredItems.length,
            ),
        ],
      ),
    );

    if (widget.showSearch) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: child,
      );
    } else {
      return SingleChildScrollView(child: child);
    }
  }
}
