import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile(
      {super.key,
      required this.leading,
      this.trailing,
      required this.title,
      this.subtitle,
      this.onTap,
      this.enabled = true});
  final Widget leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final Function()? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).listTileTheme.tileColor,
      ),
      child: ListTile(
        shape: const ContinuousRectangleBorder(),
        enableFeedback: true,
        onTap: onTap,
        title: title,
        subtitle: subtitle,
        enabled: enabled,
        leading: leading,
        trailing: trailing,
        style: ListTileStyle.list,
      ),
    );
  }
}
