import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/domain/model/api/location_prediction.dart';
import 'package:xtridelink/core/services/location/index.dart';

import 'package:xtridelink/injector.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class SearchFieldListItem<T> {
  Key? key;
  final String searchText, searchKey;
  final T? item;
  final Widget? child;
  SearchFieldListItem(this.searchText,
      {required this.searchKey, this.child, this.item, this.key});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchFieldListItem &&
            runtimeType == other.runtimeType &&
            searchText == other.searchText;
  }

  @override
  int get hashCode => searchText.hashCode;
}

/// extension to check if a Object is present in List<Object>
extension ListContainsObject<T> on List {
  bool containsObject(T object) {
    for (var item in this) {
      if (object == item) {
        return true;
      }
    }
    return false;
  }
}

class SearchField<T> extends StatefulWidget {
  final FocusNode? focusNode;
  final List<SearchFieldListItem<T>> suggestions;
  final Function(SearchFieldListItem<T>)? onSuggestionTap;
  final void Function(String)? onChanged;
  final bool? enabled;
  final bool readOnly;
  final Function(String)? onSubmit;
  final Function(LocationData) onMapLocationPicked;
  final String? hintText;
  final TextInputAction? textInputAction;
  final SearchFieldListItem<T>? initialValue;

  /// Specifies [TextStyle] for suggestions when no child is provided.
  final TextStyle? suggestionStyle;
  final double itemHeight;
  final int maxSuggestionsInViewPort;
  final TextEditingController controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final Offset? offset;
  final void Function(String?)? onSaved;
  final Color? fillColor, borderColor;
  final String? prefixIcon, suffixIcon;
  final bool autofocus;
  final void Function(PointerDownEvent)? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final ScrollbarDecoration? scrollbarDecoration;
  final TextCapitalization textCapitalization;

  SearchField(
      {super.key,
      required this.suggestions,
      this.autofocus = false,
      required this.controller,
      this.enabled,
      this.focusNode,
      this.hintText,
      this.initialValue,
      this.inputFormatters,
      this.inputType,
      required this.itemHeight,
      required this.onMapLocationPicked,
      this.maxSuggestionsInViewPort = 5,
      this.readOnly = false,
      this.onChanged,
      this.onSaved,
      this.onSubmit,
      this.onTapOutside,
      this.offset,
      this.fillColor,
      this.borderColor,
      this.prefixIcon,
      this.suffixIcon,
      this.onSuggestionTap,
      this.scrollbarDecoration,
      this.suggestionStyle,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.validator})
      : assert(
            (initialValue != null &&
                    suggestions.containsObject(initialValue)) ||
                initialValue == null,
            'Initial value should either be null or should be present in suggestions list.');

  @override
  State<SearchField<T>> createState() => _SearchFieldState();
}

class _SearchFieldState<T> extends State<SearchField<T>> {
  late FocusNode _focus;
  bool isSuggestionExpanded = false;
  ScrollbarDecoration? _scrollbarDecoration;
  final LayerLink _layerLink = LayerLink();
  GlobalKey key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  final StreamController<List<SearchFieldListItem<T>>?> suggestionStream =
      StreamController<List<SearchFieldListItem<T>>?>.broadcast();

  void initialize() {
    if (widget.scrollbarDecoration == null) {
      _scrollbarDecoration = ScrollbarDecoration();
    } else {
      _scrollbarDecoration = widget.scrollbarDecoration;
    }

    _focus = widget.focusNode ?? FocusNode();

    _focus.addListener(() {
      if (mounted && isSuggestionExpanded != _focus.hasFocus) {
        setState(() => isSuggestionExpanded = _focus.hasFocus);
      }
      if (isSuggestionExpanded) {
        _overlayEntry = _createOverlay();
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry?.remove();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayEntry = _createOverlay();
        if ((widget.initialValue?.searchText ?? '').isEmpty) {
          suggestionStream.sink.add(null);
        } else {
          suggestionStream.sink.add([widget.initialValue!]);
        }
      }
    });
  }

  @override
  void dispose() {
    suggestionStream.close();
    _scrollController.dispose();
    _focus.dispose();
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchField<T> oldWidget) {
    if (oldWidget.scrollbarDecoration != widget.scrollbarDecoration) {
      if (widget.scrollbarDecoration == null) {
        _scrollbarDecoration = ScrollbarDecoration();
      } else {
        _scrollbarDecoration = widget.scrollbarDecoration;
      }
    }
    if (oldWidget.suggestions != widget.suggestions) {
      suggestionStream.sink.add(widget.suggestions);
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _suggestionsBuilder() {
    return StreamBuilder<List<SearchFieldListItem<T>>?>(
        stream: suggestionStream.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<SearchFieldListItem<T>>?> snapshot) {
          if ((snapshot.data ?? []).isEmpty || !isSuggestionExpanded) {
            return const SizedBox();
          }
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: (snapshot.data!.length > widget.maxSuggestionsInViewPort
                    ? widget.maxSuggestionsInViewPort
                    : snapshot.data!.length) *
                widget.itemHeight,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.01),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 0)),
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 0))
              ],
            ),
            child: RawScrollbar(
              thumbVisibility: _scrollbarDecoration!.thumbVisibility,
              controller: _scrollController,
              padding: EdgeInsets.zero,
              shape: _scrollbarDecoration!.shape,
              fadeDuration: _scrollbarDecoration!.fadeDuration,
              radius: _scrollbarDecoration!.radius,
              thickness: _scrollbarDecoration!.thickness,
              thumbColor: _scrollbarDecoration!.thumbColor,
              minThumbLength: _scrollbarDecoration!.minThumbLength,
              trackRadius: _scrollbarDecoration!.trackRadius,
              trackVisibility: _scrollbarDecoration!.trackVisibility,
              timeToFade: _scrollbarDecoration!.timeToFade,
              pressDuration: _scrollbarDecoration!.pressDuration,
              trackBorderColor: _scrollbarDecoration!.trackBorderColor,
              trackColor: _scrollbarDecoration!.trackColor,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  physics: snapshot.data!.length == 1
                      ? const NeverScrollableScrollPhysics()
                      : const ScrollPhysics(),
                  itemBuilder: (context, index) => TextFieldTapRegion(
                      child: InkWell(
                    onTap: () {
                      widget.controller.text = snapshot.data![index].searchText;
                      widget.controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: widget.controller.text.length));
                      _focus.unfocus();
                      if (widget.onSuggestionTap != null) {
                        widget.onSuggestionTap!(snapshot.data![index]);
                      }
                    },
                    child: Container(
                      height: widget.itemHeight,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.grey.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: snapshot.data![index].child ??
                          Text(
                            snapshot.data![index].searchText,
                            style: widget.suggestionStyle,
                          ),
                    ),
                  )),
                ),
              ),
            ),
          );
        });
  }

  OverlayEntry _createOverlay() {
    final textFieldRenderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final textFieldSize = textFieldRenderBox.size;
    final offset = textFieldRenderBox.localToGlobal(Offset.zero);
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: offset.dx,
        width: textFieldSize.width,
        child: CompositedTransformFollower(
            offset: widget.offset ?? Offset(0, textFieldSize.height),
            link: _layerLink,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Material(
                child: _suggestionsBuilder(),
              ),
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
          key: key,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          onTapOutside: widget.onTapOutside,
          readOnly: widget.readOnly,
          onFieldSubmitted: widget.onSubmit,
          onTap: () {
            if (!isSuggestionExpanded && mounted) {
              setState(() => isSuggestionExpanded = true);
            }
          },
          onSaved: widget.onSaved,
          inputFormatters: widget.inputFormatters,
          controller: widget.controller,
          focusNode: _focus,
          validator: widget.validator,
          style: AppTextStyles.regularText(fontSize: 13),
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          keyboardType: widget.inputType,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon == null
                ? null
                : Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    child: SvgPicture.asset(widget.prefixIcon!,
                        color: AppColors.grey.withValues(alpha: .8))),
            suffixIcon: widget.suffixIcon == null
                ? null
                : GestureDetector(
                    onTap: () => getIt<LocationMapService>()
                        .showMapLocationPicker(onPicked: (v) {
                      widget.controller.text = v.address;
                      widget.onMapLocationPicked(v);
                    }),
                    child: SvgPicture.asset(widget.suffixIcon!,
                            color: AppColors.grey.withValues(alpha: .8))
                        .pd(EdgeInsets.symmetric(
                            vertical: 12.5.h, horizontal: 13.w)),
                  ),
            hintText: widget.hintText,
            hintStyle: AppTextStyles.regularText(
                color: Colors.black.withValues(alpha: 0.5)),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            border: widget.borderColor == null
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: widget.borderColor!)),
            fillColor:
                widget.fillColor ?? AppColors.grey.withValues(alpha: 0.1),
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: widget.borderColor == null
                    ? BorderSide.none
                    : BorderSide(color: widget.borderColor!)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                    color: widget.borderColor ?? AppColors.secColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide:
                    BorderSide(color: widget.borderColor ?? Colors.red)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide:
                  BorderSide(color: widget.borderColor ?? AppColors.secColor),
            ),
          ),
          onChanged: widget.onChanged),
    );
  }
}

class ScrollbarDecoration {
  /// The [OutlinedBorder] of the scrollbar's thumb.
  ///
  /// Only one of [radius] and [shape] may be specified. For a rounded rectangle,
  /// it's simplest to just specify [radius]. By default, the scrollbar thumb's
  /// shape is a simple rectangle.
  OutlinedBorder? shape;

  /// The [Radius] of the scrollbar's thumb.
  /// Only one of [radius] and [shape] may be specified. For a rounded rectangle,
  Radius? radius;

  /// The thickness of the scrollbar's thumb.
  double? thickness;

  /// Mustn't be null and the value has to be greater or equal to `minOverscrollLength`, which in
  /// turn is >= 0. Defaults to 18.0.
  double minThumbLength;

  /// The [Color] of the scrollbar's thumb.
  Color? thumbColor;

  /// The [Color] of the scrollbar's track.
  bool? trackVisibility;

  /// The [Radius] of the scrollbar's track.
  Radius? trackRadius;

  /// The [Color] of the scrollbar's track.
  Color? trackColor;

  /// The [Color] of the scrollbar's track border.
  Color? trackBorderColor;

  /// The [Duration] of the fade animation.
  Duration fadeDuration;

  /// Defines whether to show the scrollbar always or only when scrolling.
  /// defaults to `true`
  final bool? thumbVisibility;

  /// The [Duration] of time until the fade animation begins.
  /// Cannot be null, defaults to a [Duration] of 600 milliseconds.
  Duration timeToFade;

  /// The [Duration] of time that a LongPress will trigger the drag gesture of the scrollbar thumb.
  /// Cannot be null, defaults to [Duration.zero].
  Duration pressDuration;

  ScrollbarDecoration({
    this.minThumbLength = 18.0,
    this.thumbVisibility = true,
    this.radius,
    this.thickness,
    this.thumbColor,
    this.shape,
    this.trackVisibility,
    this.trackRadius,
    this.trackColor,
    this.trackBorderColor,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.timeToFade = const Duration(milliseconds: 600),
    this.pressDuration = const Duration(milliseconds: 100),
  });
}
