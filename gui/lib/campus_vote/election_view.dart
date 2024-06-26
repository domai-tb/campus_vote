import 'package:campus_vote/campus_vote/widgets/dashboard_widget.dart';
import 'package:campus_vote/campus_vote/widgets/setup_widget.dart';
import 'package:campus_vote/campus_vote/widgets/voter_registry_widget.dart';
import 'package:campus_vote/settings/settings_controller.dart';
import 'package:campus_vote/settings/settings_view.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class ElectionView extends StatefulWidget {
  static const routeName = '/election';

  final SettingsController controller;

  const ElectionView({super.key, required this.controller});

  @override
  State<ElectionView> createState() => _ElectionViewState();
}

class _ElectionViewState extends State<ElectionView> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SideMenu(
              controller: sideMenu,
              style: SideMenuStyle(
                openSideMenuWidth: 200,
                hoverColor:
                    Theme.of(context).colorScheme.onSurface.withAlpha(50),
                selectedColor: Theme.of(context).colorScheme.primary,
                selectedIconColor: Theme.of(context).colorScheme.onPrimary,
                unselectedIconColor: Theme.of(context).colorScheme.onSurface,
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedTitleTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                unselectedTitleTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              items: [
                SideMenuItem(
                  title: AppLocalizations.of(context)!.dashboardTitle,
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.home_outlined),
                ),
                SideMenuItem(
                  title: AppLocalizations.of(context)!.setupTitle,
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
                SideMenuItem(
                  title: AppLocalizations.of(context)!.votersTitle,
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.group_outlined),
                ),
                SideMenuItem(
                  title: AppLocalizations.of(context)!.settingsTitle,
                  icon: const Icon(Icons.settings_outlined),
                  onTap: (_, __) =>
                      Navigator.pushNamed(context, SettingsView.routeName),
                ),
              ],
              footer: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Campus Vote v${widget.controller.packageInfo.version}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: const [
                  Dashboard(),
                  ElectionSetup(),
                  VoterRegistry(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }
}
