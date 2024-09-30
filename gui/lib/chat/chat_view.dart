import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:campus_vote/core/api/client.dart';
import 'package:campus_vote/core/injection.dart';
import 'package:campus_vote/core/state/state_controller.dart';
import 'package:campus_vote/themes/theme_dark.dart';
import 'package:campus_vote/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_gen/gen_l10n/campus_vote_localizations.dart';

class ChatView extends StatefulWidget {
  final campusVoteState = serviceLocator<CampusVoteState>();

  ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late CampusVoteAPIClient client;

  Timer? updateTimer;
  List<types.Message> chatMessages = [];

  final types.User user1 = const types.User(id: 'Committee', firstName: 'Committee');
  final types.User user2 = const types.User(id: 'ID', firstName: 'ID');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locals = AppLocalizations.of(context);

    return Chat(
      messages: chatMessages,
      onSendPressed: (types.PartialText _) {},
      user: user1,
      showUserNames: true,
      theme: DefaultChatTheme(
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      emptyState: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          locals!.chatEmptyPlaceholder,
          textAlign: TextAlign.center,
        ),
      ),
      textMessageBuilder: (textMsg, {required messageWidth, required showName}) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            textMsg.text,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
      bubbleBuilder: (child, {required message, required nextMessageInGroup}) {
        return Column(
          children: [
            Text(message.author.id),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.canvasColor,
                ),
                gradient: LinearGradient(
                  colors: [
                    theme.canvasColor,
                    if (theme.primaryColor == darkTheme.primaryColor)
                      theme.colorScheme.secondary.withOpacity(0.25)
                    else
                      Theme.of(context).canvasColor,
                  ],
                ),
              ),
              child: child,
            ),
          ],
        );
      },
      customBottomWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(locals.chatSendAMessage),
          ),
          SizedBox(
            height: 150,
            child: ListView(
              children: [
                CVButton(labelText: locals.chatNeedMoreBallots, onPressed: () => sendChatMessage(locals.chatNeedMoreBallots)),
                CVButton(labelText: locals.chatHaveAProblem, onPressed: () => sendChatMessage(locals.chatHaveAProblem)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // For the testing purposes, you should probably use https://pub.dev/packages/uuid.
  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void sendChatMessage(String message) {
    if (serviceLocator.isRegistered<CampusVoteAPIClient>()) {
      client = serviceLocator<CampusVoteAPIClient>();
      client.sendChatMessage(message);
      updateMessages();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: Colors.red,
                ),
                SizedBox(width: 20),
                Text('Currently not connected with API. Cannot send messages.'),
              ],
            ),
          ),
        );
      }
    }
  }

  void startTimer() {
    updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      updateMessages();
    });
  }

  Future<void> updateMessages() async {
    if (serviceLocator.isRegistered<CampusVoteAPIClient>()) {
      client = serviceLocator<CampusVoteAPIClient>();
      final history = await client.getChatHistory();

      final currentChatHistory = <types.Message>[];
      for (final msg in history.chat) {
        currentChatHistory.add(
          types.TextMessage(
            author: types.User(id: msg.sender),
            id: '${msg.sendAt.toDateTime().millisecondsSinceEpoch}:${msg.sender}:${msg.message}',
            text: msg.message,
            createdAt: msg.sendAt.toDateTime().millisecondsSinceEpoch,
          ),
        );
      }

      currentChatHistory.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      if (chatMessages != currentChatHistory) {
        setState(() => chatMessages = currentChatHistory);
      }
    }
  }
}
