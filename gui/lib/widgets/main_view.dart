import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/themes/theme_dark.dart';
import 'package:campus_vote/widgets/main_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';
import 'package:sidebarx/sidebarx.dart';

class MainView extends StatelessWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();

  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final sideBarController = SidebarXController(
      selectedIndex: campusVoteState.awaitingSetup() ? 1 : 0,
      extended: true,
    );

    return Scaffold(
      body: Row(
        children: [
          SidebarX(
            controller: sideBarController,
            showToggleButton: false,
            theme: SidebarXTheme(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              itemTextPadding: const EdgeInsets.only(left: 30),
              selectedItemTextPadding: const EdgeInsets.only(left: 30),
              itemDecoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              selectedItemDecoration: BoxDecoration(
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
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            extendedTheme: SidebarXTheme(
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              margin: const EdgeInsets.only(right: 10),
            ),
            headerBuilder: (context, extended) {
              return SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    (Theme.of(context).primaryColor == darkTheme.primaryColor)
                        ? 'assets/images/stupa_logo_light.png'
                        : 'assets/images/stupa_logo_dark.png',
                  ),
                ),
              );
            },
            items: [
              SidebarXItem(
                icon: Icons.home_outlined,
                label: AppLocalizations.of(context)!.dashboardTitle,
              ),
              SidebarXItem(
                icon: Icons.create_outlined,
                label: AppLocalizations.of(context)!.setupTitle,
              ),
            ],
            footerItems: [
              SidebarXItem(
                icon: Icons.settings_outlined,
                label: AppLocalizations.of(context)!.settingsTitle,
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: MainFrame(controller: sideBarController),
            ),
          ),
        ],
      ),
    );
  }
}
