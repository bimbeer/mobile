import 'package:bimbeer/core/presentation/widgets/pop_page_button.dart';
import 'package:bimbeer/features/chat/bloc/chat_bloc.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.watch<ChatBloc>();
    final chatState = chatBloc.state;

    if (chatState is ChatRoomLoaded) {
      return ChatView(chatDetails: chatState.chatDetails);
    } else {
      return const ChatRoomLoadingView();
    }
  }
}

class ChatRoomLoadingView extends StatelessWidget {
  const ChatRoomLoadingView({super.key});

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

class ChatView extends StatelessWidget {
  const ChatView({required this.chatDetails, super.key});

  final ChatDetails chatDetails;

  @override
  Widget build(BuildContext context) {
    Widget getAvatar() {
      if (chatDetails.chatPreview.avatarUrl != "") {
        return Image.network(chatDetails.chatPreview.avatarUrl);
      } else {
        return const Icon(Icons.person);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: Column(
        children: [
          ChatHeader(
            avatar: getAvatar(),
            username: chatDetails.chatPreview.name,
          ),
        ],
      )),
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({required this.avatar, required this.username, super.key});

  final Widget avatar;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PopPageButton(),
        CircleAvatar(
          radius: 30,
          child: avatar,
        ),
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

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ChatControls extends StatelessWidget {
  const ChatControls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
