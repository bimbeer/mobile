import 'package:bimbeer/app/bloc/app_bloc.dart';
import 'package:bimbeer/core/presentation/widgets/pop_page_button.dart';
import 'package:bimbeer/features/chat/bloc/chat_bloc.dart';
import 'package:bimbeer/features/chat/bloc/conversation_bloc.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:bimbeer/features/chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatState = context.watch<ConversationBloc>().state;

    if (chatState is ConversationLoaded) {
      return ConversationView(chatDetails: chatState.chatDetails);
    } else {
      return const ConversationLoadingView();
    }
  }
}

class ConversationLoadingView extends StatelessWidget {
  const ConversationLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: const SafeArea(
          child: Column(
        children: [
          PopPageButton(),
          Center(child: CircularProgressIndicator()),
        ],
      )),
    );
  }
}

class ConversationView extends StatelessWidget {
  const ConversationView({required this.chatDetails, super.key});

  final ChatDetails chatDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            child: ConversationHeader(
              avatarUrl: chatDetails.chatPreview.avatarUrl,
              username: chatDetails.chatPreview.name,
            ),
          ),
          Expanded(
            child: ConversationMessages(
              messages: chatDetails.messages,
            ),
          ),
          SizedBox(child: ConversationControls(chatDetails: chatDetails))
        ],
      )),
    );
  }
}

class ConversationHeader extends StatelessWidget {
  const ConversationHeader(
      {required this.avatarUrl, required this.username, super.key});

  final String avatarUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    Widget getAvatar() {
      if (avatarUrl != "") {
        return CircleAvatar(
          radius: 20,
          backgroundImage: Image.network(avatarUrl).image,
        );
      } else {
        return const CircleAvatar(
          radius: 20,
          child: Icon(Icons.person),
        );
      }
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<ConversationBloc>().add(const ConversationLeft());
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
              elevation: 0, backgroundColor: Colors.transparent),
          child: const Icon(
            Icons.arrow_back,
            size: 28,
            color: Colors.grey,
          ),
        ),
        getAvatar(),
        const SizedBox(
          width: 10,
        ),
        Text(
          username,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class ConversationMessages extends StatelessWidget {
  const ConversationMessages({required this.messages, super.key});

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return SingleChildScrollView(
          reverse: true,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                for (final message in messages)
                  ConversationMessage(message: message),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ConversationMessage extends StatelessWidget {
  const ConversationMessage({required this.message, super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AppBloc>().state.user.id;

    return Align(
      alignment:
          message.senderId == userId ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: message.senderId == userId
              ? Colors.yellow[400]
              : Colors.blue[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: message.senderId == userId
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary),
        ),
      ),
    );
  }
}

class ConversationControls extends StatefulWidget {
  const ConversationControls({required this.chatDetails, super.key});
  final ChatDetails chatDetails;

  @override
  State<ConversationControls> createState() => _ConversationControlsState();
}

class _ConversationControlsState extends State<ConversationControls> {
  final TextEditingController messageInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userId = context.read<AppBloc>().state.user.id;

    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageInputController,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<ConversationBloc>().add(
                    MessageSent(
                      message: Message(
                        recipientId: widget.chatDetails.chatPreview.pairId,
                        senderId: userId,
                        text: messageInputController.text,
                        status: 'sent',
                        timestamp: Timestamp.now(),
                      ),
                    ),
                  );
              messageInputController.clear();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
