part of flutter_parsed_text;

/// Parse text and make them into multiple Flutter Text widgets
class ParsedText extends StatelessWidget {
  /// If non-null, the style to use for the global text.
  ///
  /// It takes a [TextStyle] object as it's property to style all the non links text objects.
  final TextStyle? style;

  /// Takes a list of [MatchText] object.
  ///
  /// This list is used to find patterns in the String and assign onTap [Function] when its
  /// tapped and also to provide custom styling to the linkify text
  final List<MatchText> parse;

  /// Text that is rendered
  ///
  /// Takes a [String]
  final String text;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [TextAlign] object and default value is [TextAlign.start]
  final TextAlign alignment;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [TextDirection] object and default value is [TextDirection.start]
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  ///If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.text.DefaultTextStyle.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// Make this text selectable.
  ///
  /// SelectableText does not support softwrap, overflow, textScaleFactor
  final bool selectable;

  /// onTap function for the whole widget
  final Function? onTap;

  /// Global regex options for the whole string,
  ///
  /// Note: Removed support for regexOptions for MatchText and now it uses global regex options.
  final RegexOptions regexOptions;

  /// Creates a parsedText widget
  ///
  /// [text] paramtere should not be null and is always required.
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ParsedText({
    Key? key,
    required this.text,
    this.parse = const <MatchText>[],
    this.style,
    this.alignment = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.maxLines,
    this.onTap,
    this.selectable = false,
    this.regexOptions = const RegexOptions(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Seperate each word and create a new Array
    String newString = text;

    Map<String, MatchText> _mapping = Map<String, MatchText>();

    parse.forEach((e) {
      if (e.type == ParsedType.EMAIL) {
        _mapping[emailPattern] = e;
      } else if (e.type == ParsedType.PHONE) {
        _mapping[phonePattern] = e;
      } else if (e.type == ParsedType.URL) {
        _mapping[urlPattern] = e;
      } else {
        _mapping[e.pattern!] = e;
      }
    });

    final pattern = '(${_mapping.keys.toList().join('|')})';

    List<InlineSpan> widgets = [];

    newString.splitMapJoin(
      RegExp(
        pattern,
        multiLine: regexOptions.multiLine,
        caseSensitive: regexOptions.caseSensitive,
        dotAll: regexOptions.dotAll,
        unicode: regexOptions.unicode,
      ),
      onMatch: (Match match) {
        final matchText = match[0];

        final mapping = _mapping[matchText!] ??
            _mapping[_mapping.keys.firstWhere((element) {
              final reg = RegExp(
                element,
                multiLine: regexOptions.multiLine,
                caseSensitive: regexOptions.caseSensitive,
                dotAll: regexOptions.dotAll,
                unicode: regexOptions.unicode,
              );
              return reg.hasMatch(matchText);
            }, orElse: () {
              return '';
            })];

        InlineSpan widget;

        if (mapping != null) {
          if (mapping.renderText != null) {
            Map<String, String> result =
                mapping.renderText!(str: matchText, pattern: pattern);

            widget = TextSpan(
              text: "${result['display']}",
              style: mapping.style != null ? mapping.style : style,
              recognizer: TapGestureRecognizer()
                ..onTap = () => mapping.onTap!(matchText),
            );
          } else if (mapping.renderWidget != null) {
            widget = WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => mapping.onTap!(matchText),
                child: mapping.renderWidget!(
                    text: matchText, pattern: mapping.pattern!),
              ),
            );
          } else {
            widget = TextSpan(
              text: "$matchText",
              style: mapping.style != null ? mapping.style : style,
              recognizer: TapGestureRecognizer()
                ..onTap = () => mapping.onTap!(matchText),
            );
          }
        } else {
          widget = TextSpan(
            text: "$matchText",
            style: this.style,
          );
        }

        widgets.add(widget);

        return '';
      },
      onNonMatch: (String text) {
        widgets.add(TextSpan(
          text: "$text",
          style: this.style,
        ));

        return '';
      },
    );

    if (selectable) {
      return SelectableText.rich(
        TextSpan(children: <InlineSpan>[...widgets], style: style),
        maxLines: maxLines,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textAlign: alignment,
        textDirection: textDirection,
        onTap: onTap as void Function()?,
      );
    }

    return RichText(
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textAlign: alignment,
      textDirection: textDirection,
      text: TextSpan(
        text: '',
        children: <InlineSpan>[...widgets],
        style: style,
      ),
    );
  }
}
