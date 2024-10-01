import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/api/generated/vote.pb.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class VoterInfoPopUp extends StatelessWidget {
  final Voter voter;

  const VoterInfoPopUp({super.key, required this.voter});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      contentTextStyle: Theme.of(context).textTheme.headlineSmall,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      buttonPadding: const EdgeInsets.only(left: 50, right: 50),
      title: Row(
        children: [
          Text(AppLocalizations.of(context)!.voterInfoVoterTitle),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getStatusColor(voter.status), // Change this to your desired color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('${AppLocalizations.of(context)!.voterInfoStudentId}:      '),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text(voter.studentId.num.toString())],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('${AppLocalizations.of(context)!.voterInfoFirstname}:      '),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text(voter.firstname)],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('${AppLocalizations.of(context)!.voterInfoLastname}:     '),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text(voter.lastname)],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('${AppLocalizations.of(context)!.voterInfoVoterStatus}:      '),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(getStatusName(voter.status, context)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        if (voter.status == 0)
          TextButton(
            onPressed: () async {
              final client = serviceLocator<CampusVoteAPIClient>();
              await client.votingStep(voter.studentId.num.toString()).then((msg) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              });
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.btnTxtGiveBallot),
          ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.btnTxtClose),
        ),
      ],
    );
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.amber;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusName(int status, BuildContext ctx) {
    switch (status) {
      case 0:
        return AppLocalizations.of(ctx)!.voterStatusGreen;
      case 1:
        return AppLocalizations.of(ctx)!.voterStatusAmber;
      case 2:
        return AppLocalizations.of(ctx)!.voterStatusRed;
      default:
        return AppLocalizations.of(ctx)!.voterStatusGrey;
    }
  }
}
