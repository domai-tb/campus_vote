import 'package:campus_vote/themes/theme_dark.dart';
import 'package:flutter/material.dart';

class CVButton extends StatelessWidget {
  final String labelText;
  final void Function() onPressed;
  final Icon? icon;

  const CVButton({
    super.key,
    required this.labelText,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).canvasColor,
          ),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).canvasColor,
              if (Theme.of(context).primaryColor == darkTheme.primaryColor)
                Theme.of(context).colorScheme.secondary.withOpacity(0.25)
              else
                Theme.of(context).canvasColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: MaterialButton(
            onPressed: onPressed,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (icon != null) icon!,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Text(
                    labelText,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
