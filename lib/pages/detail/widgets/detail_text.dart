import 'package:flutter/material.dart';

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
          firstChild: Text(
            widget.text,
            style: theme.textTheme.caption,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          secondChild: Text(
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
              showMore ? "收起" : '查看更多',
              style: theme.textTheme.caption.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
