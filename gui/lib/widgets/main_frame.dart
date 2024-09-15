import 'package:campus_vote/chat/chat_view.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/dashboard/dashboard_view.dart';
import 'package:campus_vote/dashboard/widgets/voter_form.dart';
import 'package:campus_vote/header/header_view.dart';
import 'package:campus_vote/settings/settings_view.dart';
import 'package:campus_vote/setup/setup_view.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MainFrame extends StatefulWidget {
  final SidebarXController controller;
  final campusVoteState = serviceLocator<CampusVoteState>();

  MainFrame({
    super.key,
    required this.controller,
  });

  @override
  State<MainFrame> createState() => MainFrameState();
}

class MainFrameState extends State<MainFrame> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.campusVoteState,
      builder: (BuildContext context, Widget? child) {
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Center(child: HeaderView()),
                  ),
                  Expanded(
                    flex: 6,
                    child: AnimatedBuilder(
                      animation: widget.controller,
                      builder: (context, child) {
                        switch (widget.controller.selectedIndex) {
                          case 0:
                            return DashboardView();
                          // case 1:
                          //   return ChatView();
                          case 1:
                            return SetupView();
                          case 2:
                            return SettingsView();
                          default:
                            return Container(
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Not found',
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: VoterForm(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: ChatView(),
              ),
            ),
          ],
        );
      },
    );
  }
}
