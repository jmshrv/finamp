import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({
    Key? key,
    required this.iconData,
    required this.textSpan,
  }) : super(key: key);

  final IconData iconData;
  final TextSpan textSpan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            // Inactive icons have an opacity of 50% with dark theme and 38%
            // with bright theme
            // https://material.io/design/iconography/system-icons.html#color
            color: Theme.of(context).iconTheme.color?.withOpacity(
                Theme.of(context).brightness == Brightness.light ? 0.38 : 0.5),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
          Expanded(
            child: RichText(
              text: textSpan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
