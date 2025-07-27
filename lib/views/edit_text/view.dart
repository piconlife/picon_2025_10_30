import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../icon/view.dart';
import '../text/view.dart';
import '../view/view.dart';

part 'controller.dart';
part 'drawable_state.dart';
part 'floating_visibility.dart';
part 'footer.dart';
part 'header.dart';
part 'highlight_text.dart';
part 'typedefs.dart';
part 'underline.dart';

class EditText<T extends EditTextController> extends TextView<T> {
  /// BASE PROPERTIES
  final bool autoDisposeMode;
  final String characters;
  final String hint;
  final Color? hintColor;
  final String ignorableCharacters;
  final Color? primary;
  final bool maxCharactersAsLimit;
  final int? minCharacters;
  final List<TextInputFormatter>? inputFormatters;

  /// COUNTER TEXT PROPERTIES
  final Color? counterTextColor;
  final ValueState<Color>? counterTextColorState;
  final TextStyle? counterTextStyle;
  final ValueState<TextStyle>? counterTextStyleState;
  final FloatingVisibility counterVisibility;

  /// DRAWABLE END PROPERTIES
  final dynamic drawableEnd;
  final ValueState<dynamic>? drawableEndState;
  final EditTextDrawableBuilder<T>? drawableEndBuilder;
  final double drawableEndSize;
  final ValueState<double>? drawableEndSizeState;
  final double? drawableEndPadding;
  final ValueState<double>? drawableEndPaddingState;
  final Color? drawableEndTint;
  final ValueState<Color>? drawableEndTintState;
  final bool drawableEndVisible;
  final bool drawableEndAsEye;

  /// DRAWABLE START PROPERTIES
  final dynamic drawableStart;
  final ValueState<dynamic>? drawableStartState;
  final EditTextDrawableBuilder<T>? drawableStartBuilder;
  final double drawableStartSize;
  final ValueState<double>? drawableStartSizeState;
  final double? drawableStartPadding;
  final ValueState<double>? drawableStartPaddingState;
  final Color? drawableStartTint;
  final ValueState<Color>? drawableStartTintState;
  final bool drawableStartVisible;

  /// ERROR TEXT PROPERTIES
  final FloatingVisibility errorVisibility;
  final Color? errorTextColor;
  final ValueState<Color>? errorTextColorState;
  final TextStyle? errorTextStyle;
  final ValueState<TextStyle>? errorTextStyleState;

  /// FLOATING TEXT PROPERTIES
  final Alignment? floatingAlignment;
  final String? floatingText;
  final TextStyle? floatingTextStyle;
  final ValueState<TextStyle>? floatingTextStyleState;
  final EdgeInsets floatingTextSpace;
  final FloatingVisibility floatingVisibility;

  /// HELPER TEXT PROPERTIES
  final String helperText;
  final Color? helperTextColor;
  final ValueState<Color>? helperTextColorState;
  final TextStyle? helperTextStyle;
  final ValueState<TextStyle>? helperTextStyleState;

  /// INDICATOR PROPERTIES
  final Widget? indicator;
  final double indicatorSize;
  final Color? indicatorStrokeColor;
  final ValueState<Color>? indicatorStrokeColorState;
  final double indicatorStroke;
  final Color? indicatorStrokeBackground;
  final ValueState<Color>? indicatorStrokeBackgroundState;

  /// TEXT FIELD PROPERTIES
  final bool autocorrect;
  final List<String> autofillHints;
  final bool autoFocus;
  final Clip clipBehaviorText;
  final Color? cursorColor;
  final double? cursorHeight;
  final bool cursorOpacityAnimates;
  final Radius? cursorRadius;
  final double cursorWidth;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final EditTextContextMenuBuilder? contextMenuBuilder;
  final DragStartBehavior dragStartBehavior;
  final bool enableIMEPersonalizedLearning;
  final bool? enableInteractiveSelection;
  final bool enableSuggestions;
  final bool expands;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final Brightness keyboardAppearance;
  final TextMagnifierConfiguration magnifierConfiguration;
  final int? minLines;
  final MouseCursor? mouseCursor;
  final bool? obscureText;
  final String obscuringCharacter;
  final bool readOnly;
  final String? restorationId;
  final bool scribbleEnabled;
  final ScrollController? scrollControllerText;
  final EdgeInsets scrollPaddingText;
  final ScrollPhysics? scrollPhysicsText;
  final Color? secondaryColor;
  final TextSelectionControls? selectionControls;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final bool? showCursor;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextCapitalization textCapitalization;
  final UndoHistoryController? undoController;
  final EditTextPrivateCommandListener? onAppPrivateCommand;
  final EditTextVoidListener? onEditingComplete;
  final EditTextSubmitListener? onSubmitted;
  final EditTextTapOutsideListener? onTapOutside;

  /// UNDERLINE PROPERTIES
  final Color? underlineColor;
  final ValueState<Color>? underlineColorState;
  final double? underlineHeight;
  final ValueState<double>? underlineHeightState;

  const EditText({
    /// ROOT PROPERTIES
    super.key,
    super.controller,

    /// CALLBACK PROPERTIES
    super.onActivator,
    super.onChange,
    super.onError,
    super.onHover,
    super.onValid,
    super.onValidator,

    /// CLICK PROPERTIES
    super.clickEffect,
    super.onClick,
    super.onDoubleClick,
    super.onLongClick,
    super.onToggleClick,
    super.onClickHandler,
    super.onDoubleClickHandler,
    super.onLongClickHandler,

    ///BASE PROPERTIES
    super.absorbMode,
    super.activated,
    super.background,
    super.backgroundState,
    super.backgroundBlendMode,
    super.backgroundGradient,
    super.backgroundGradientState,
    super.backgroundImage,
    super.backgroundImageState,
    super.clipBehavior,
    super.dimensionRatio,
    super.elevation,
    super.enabled,
    super.expandable,
    super.foreground,
    super.foregroundBlendMode,
    super.foregroundGradient,
    super.foregroundImage,
    super.flex,
    super.gravity,
    super.height,
    super.heightState,
    super.heightMax,
    super.heightMin,
    super.hoverColor,
    super.orientation,
    super.position,
    super.positionType,
    super.pressedColor,
    super.rippleColor,
    super.scrollable,
    super.scrollController,
    super.scrollingType,
    super.shape,
    super.transform,
    super.transformGravity,
    super.visibility,
    super.width,
    super.widthState,
    super.widthMax,
    super.widthMin,

    /// ANIMATION PROPERTIES
    super.animation,
    super.animationType,

    /// BACKDROP PROPERTIES
    super.backdropFilter,
    super.backdropMode,

    /// BORDER PROPERTIES
    super.borderColor,
    super.borderColorState,
    super.borderSize,
    super.borderSizeState,
    super.borderHorizontal,
    super.borderHorizontalState,
    super.borderVertical,
    super.borderVerticalState,
    super.borderTop,
    super.borderTopState,
    super.borderBottom,
    super.borderBottomState,
    super.borderStart,
    super.borderStartState,
    super.borderEnd,
    super.borderEndState,
    super.borderStrokeAlign,

    /// BORDER RADIUS PROPERTIES
    super.borderRadius,
    super.borderRadiusState,
    super.borderRadiusBL,
    super.borderRadiusBLState,
    super.borderRadiusBR,
    super.borderRadiusBRState,
    super.borderRadiusTL,
    super.borderRadiusTLState,
    super.borderRadiusTR,
    super.borderRadiusTRState,

    /// INDICATOR PROPERTIES
    super.indicatorVisible,

    /// MARGIN PROPERTIES
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.marginCustom,

    /// OPACITY PROPERTIES
    super.opacity,
    super.opacityState,
    super.opacityAlwaysIncludeSemantics,

    /// PADDING PROPERTIES
    super.padding,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
    super.paddingCustom,

    /// SHADOW PROPERTIES
    super.shadow,
    super.shadowBlurRadius,
    super.shadowBlurStyle,
    super.shadowColor,
    super.shadowType,
    super.shadowSpreadRadius,
    super.shadowHorizontal,
    super.shadowVertical,
    super.shadowStart,
    super.shadowEnd,
    super.shadowTop,
    super.shadowBottom,

    /// SUPER TEXT PROPERTIES
    super.maxCharacters,
    super.maxLines,
    super.letterSpacing,
    super.lineSpacingExtra,
    super.locale,
    super.wordSpacing,
    super.textFontFamily,
    super.textFontStyle,
    super.textFontWeight,
    super.textDirection,
    super.selectionColor,
    super.strutStyle,
    super.text,
    super.textAlign,
    super.textAllCaps,
    super.textColor,
    super.textHeightBehavior,
    super.textOverflow,
    super.textSize,
    super.textStyle,
    super.textWidthBasis,

    /// BASE PROPERTIES
    this.autoDisposeMode = true,
    this.characters = "",
    this.hint = "",
    this.hintColor,
    this.minCharacters,
    this.primary,

    /// COUNTER PROPERTIES
    this.counterTextColor,
    this.counterTextColorState,
    this.counterTextStyle,
    this.counterTextStyleState,
    this.counterVisibility = FloatingVisibility.hide,

    /// DRAWABLE END PROPERTIES
    this.drawableEnd,
    this.drawableEndState,
    this.drawableEndBuilder,
    this.drawableEndSize = 24,
    this.drawableEndSizeState,
    this.drawableEndPadding,
    this.drawableEndPaddingState,
    this.drawableEndTint,
    this.drawableEndTintState,
    this.drawableEndVisible = true,
    this.drawableEndAsEye = false,

    /// DRAWABLE START PROPERTIES
    this.drawableStart,
    this.drawableStartState,
    this.drawableStartBuilder,
    this.drawableStartSize = 24,
    this.drawableStartSizeState,
    this.drawableStartPadding,
    this.drawableStartPaddingState,
    this.drawableStartTint,
    this.drawableStartTintState,
    this.drawableStartVisible = true,

    /// ERROR TEXT PROPERTIES
    this.errorTextColor = const Color(0xFFFF7769),
    this.errorTextColorState,
    this.errorTextStyle,
    this.errorTextStyleState,
    this.errorVisibility = FloatingVisibility.auto,

    /// FLOATING TEXT PROPERTIES
    this.floatingAlignment,
    this.floatingText,
    this.floatingTextStyle,
    this.floatingTextStyleState,
    this.floatingTextSpace = EdgeInsets.zero,
    this.floatingVisibility = FloatingVisibility.hide,

    /// HELPER TEXT PROPERTIES
    this.helperText = "",
    this.helperTextColor,
    this.helperTextColorState,
    this.helperTextStyle,
    this.helperTextStyleState,

    /// INDICATOR PROPERTIES
    this.indicator,
    this.indicatorSize = 24,
    this.indicatorStrokeColor,
    this.indicatorStrokeColorState,
    this.indicatorStroke = 2,
    this.indicatorStrokeBackground,
    this.indicatorStrokeBackgroundState,

    /// TEXT FIELD PROPERTIES
    this.autocorrect = true,
    this.autofillHints = const [],
    this.autoFocus = false,
    this.clipBehaviorText = Clip.hardEdge,
    this.cursorColor,
    this.cursorHeight,
    this.cursorOpacityAnimates = false,
    this.cursorRadius,
    this.cursorWidth = 2,
    this.contentInsertionConfiguration,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableIMEPersonalizedLearning = true,
    this.enableInteractiveSelection,
    this.enableSuggestions = true,
    this.expands = false,
    this.ignorableCharacters = "",
    this.inputAction,
    this.inputFormatters,
    this.inputType,
    this.keyboardAppearance = Brightness.light,
    this.magnifierConfiguration = TextMagnifierConfiguration.disabled,
    this.maxCharactersAsLimit = true,
    this.minLines,
    this.mouseCursor,
    this.obscureText,
    this.obscuringCharacter = '•',
    this.readOnly = false,
    this.restorationId,
    this.scribbleEnabled = true,
    this.scrollControllerText,
    this.scrollPaddingText = const EdgeInsets.all(20),
    this.scrollPhysicsText,
    this.secondaryColor,
    this.selectionControls,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.spellCheckConfiguration,
    this.textCapitalization = TextCapitalization.none,
    this.undoController,
    // LISTENERS
    this.onAppPrivateCommand,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTapOutside,

    /// UNDERLINE PROPERTIES
    this.underlineColor,
    this.underlineColorState,
    this.underlineHeight,
    this.underlineHeightState,
  });

  @override
  ViewRoots initRootProperties() {
    return const ViewRoots(clickable: false, padding: false, margin: false);
  }

  @override
  T initController() => EditTextController() as T;

  @override
  T attachController(T controller) => controller.fromEditText(this) as T;

  @override
  void onDispose(context, controller) {
    super.onDispose(context, controller);
    return controller._dispose();
  }

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @visibleForTesting
  static Widget defaultSpellCheckSuggestionsToolbarBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoSpellCheckSuggestionsToolbar.editableText(
          editableTextState: editableTextState,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return SpellCheckSuggestionsToolbar.editableText(
          editableTextState: editableTextState,
        );
    }
  }

  static SpellCheckConfiguration inferAndroidSpellCheckConfiguration(
    SpellCheckConfiguration? configuration,
  ) {
    if (configuration == null ||
        configuration == const SpellCheckConfiguration.disabled()) {
      return const SpellCheckConfiguration.disabled();
    }
    return configuration.copyWith(
      misspelledTextStyle:
          configuration.misspelledTextStyle ??
          TextField.materialMisspelledTextStyle,
      spellCheckSuggestionsToolbarBuilder:
          configuration.spellCheckSuggestionsToolbarBuilder ??
          defaultSpellCheckSuggestionsToolbarBuilder,
    );
  }

  @override
  void onReady(BuildContext context, T controller) {
    super.onReady(context, controller);
    controller._handleEditingChange(controller.text);
  }

  @override
  Widget? attach(BuildContext context, T controller) {
    final theme = Theme.of(context);
    final themeStyle = theme.textTheme.bodyLarge ?? const TextStyle();
    final primaryColor = controller.primary;
    final secondaryColor = controller.secondaryColor ?? const Color(0xffbbbbbb);

    var style = (controller.textStyle ?? themeStyle).copyWith(
      fontSize: controller.textSize ?? 18,
      height: 1.2,
    );
    var hintStyle = (controller.hintStyle ?? themeStyle).copyWith(
      fontSize: controller.textSize ?? 18,
      height: 1.2,
      color: controller.text.isNotEmpty
          ? Colors.transparent
          : controller.hintTextColor ?? secondaryColor,
    );
    final colors = ValueState(
      primary: secondaryColor,
      secondary: primaryColor,
      disable: secondaryColor,
    );

    final defaultColor = colors.fromController(controller);

    return GestureDetector(
      onTap: () => controller.showKeyboard(context),
      child: Container(
        color: Colors.transparent,
        padding: controller.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: controller.textDirection,
          children: [
            if (drawableStartBuilder != null)
              drawableStartBuilder!(context, controller)
            else
              IconView(
                visibility: controller.drawableStart != null,
                icon: controller.drawableStart,
                size: controller.drawableStartSize,
                tint: controller.drawableStartTint ?? defaultColor,
                marginCustom: controller.drawableStartSpace,
              ),
            Expanded(
              child: TextField(
                canRequestFocus: true,
                enabled: controller.enabled,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  isCollapsed: true,
                  hintText: controller.hintText,
                  hintStyle: hintStyle,
                  hintTextDirection: controller.textDirection,
                ),
                autocorrect: controller.autocorrect,
                autofillHints: controller.autofillHints,
                autofocus: controller.autoFocus,
                clipBehavior: controller.clipBehaviorText,
                controller: controller._editor,
                cursorColor: controller.cursorColor ?? primaryColor,
                cursorHeight: controller.cursorHeight,
                cursorOpacityAnimates: controller.cursorOpacityAnimates,
                cursorRadius: controller.cursorRadius,
                cursorWidth: controller.cursorWidth,
                contentInsertionConfiguration:
                    controller.contentInsertionConfiguration,
                contextMenuBuilder: controller.contextMenuBuilder,
                dragStartBehavior: controller.dragStartBehavior,
                enableIMEPersonalizedLearning:
                    controller.enableIMEPersonalizedLearning,
                enableInteractiveSelection:
                    controller.enableInteractiveSelection,
                enableSuggestions: controller.enableSuggestions,
                expands: controller.expands,
                focusNode: controller._node,
                inputFormatters: controller._formatter,
                keyboardAppearance: controller.keyboardAppearance,
                keyboardType: controller.inputType,
                maxLines: controller.maxLines,
                magnifierConfiguration: controller.magnifierConfiguration,
                maxLength: null,
                minLines: controller.minLines,
                mouseCursor: controller.mouseCursor,
                obscureText: controller.obscureText,
                obscuringCharacter: controller.obscuringCharacter,
                onAppPrivateCommand: controller.onAppPrivateCommand,
                onChanged: controller._handleEditingChange,
                onEditingComplete: controller.onEditingComplete,
                onSubmitted: controller.onSubmitted,
                onTapOutside: controller.onTapOutside,
                readOnly: controller.isReadMode,
                restorationId: controller.restorationId,
                scribbleEnabled: controller.scribbleEnabled,
                scrollController: controller.scrollControllerText,
                scrollPadding: controller.textScrollPadding,
                scrollPhysics: controller.textScrollPhysics,
                selectionControls: controller.selectionControls,
                selectionHeightStyle: controller.selectionHeightStyle,
                selectionWidthStyle: controller.selectionWidthStyle,
                showCursor: controller.showCursor,
                smartDashesType: controller.smartDashesType,
                smartQuotesType: controller.smartQuotesType,
                spellCheckConfiguration: controller.spellCheckConfiguration,
                strutStyle: controller.strutStyle,
                style: style,
                textAlign: controller.textAlign ?? TextAlign.start,
                textCapitalization: controller.textCapitalization,
                textDirection: controller.textDirection,
                textInputAction: controller.textInputAction,
                undoController: controller.undoController,
              ),
            ),
            if (controller.isIndicatorVisible)
              Container(
                width: controller.indicatorSize,
                height: controller.indicatorSize,
                padding: EdgeInsets.all(controller.indicatorSize * 0.05),
                margin: controller.drawableEndSpace,
                child: CircularProgressIndicator(
                  strokeWidth: controller.indicatorStroke,
                  color: controller.indicatorStrokeColor ?? defaultColor,
                  backgroundColor:
                      controller.indicatorStrokeBackground ??
                      defaultColor?.withOpacity(0.1),
                ),
              )
            else if (drawableEndBuilder != null)
              drawableEndBuilder!(context, controller)
            else
              IconView(
                visibility: controller.drawableEnd != null,
                icon: controller.drawableEnd,
                size: controller.drawableEndSize,
                tint: controller.drawableEndTint ?? defaultColor,
                marginCustom: controller.drawableEndSpace,
                onToggleClick: controller.drawableEndAsEye
                    ? controller.onChangeEye
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, T controller, Widget parent) {
    final floatingVisible = controller.floatingVisible;
    final underlineVisible = controller.underlineVisible;
    final footerVisible = controller.footerVisible;

    final visible = floatingVisible || footerVisible || underlineVisible;

    final child = visible
        ? Column(
            textDirection: controller.textDirection,
            children: [
              if (floatingVisible) _Header(controller),
              parent,
              if (underlineVisible)
                Underline(
                  active: controller.isFocused,
                  color: controller.underlineColor,
                  height: controller.underlineHeight,
                ),
              if (footerVisible) _Footer(controller),
            ],
          )
        : parent;

    if (controller._isMargin) {
      return Container(padding: controller.margin, child: child);
    } else {
      return child;
    }
  }
}
