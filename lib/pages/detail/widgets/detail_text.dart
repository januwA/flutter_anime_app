import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailText extends StatefulWidget {
  final String text;

  const DetailText(this.text, {Key key}) : super(key: key);

  @override
  _DetailTextState createState() => _DetailTextState();
}

class _DetailTextState extends State<DetailText> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        AnimatedCrossFade(
          duration: kTabScrollDuration,
          firstChild: SelectableText(
            widget.text,
            style: theme.textTheme.caption,
            maxLines: 2,
          ),
          secondChild: SelectableText(
            widget.text,
            style: theme.textTheme.caption,
          ),
          crossFadeState:
              showMore ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
        InkWell(
          onTap: () {
            setState(() {
              showMore = !showMore;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              showMore
                  ? AppLocalizations.of(context).less
                  : AppLocalizations.of(context).more,
              style: theme.textTheme.caption,
            ),
          ),
        ),
      ],
    );
  }
}
