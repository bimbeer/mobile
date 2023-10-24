import 'package:bimbeer/core/router/app_router.dart';
import 'package:bimbeer/features/chat/bloc/chat_bloc.dart';
import 'package:bimbeer/features/chat/bloc/conversation_bloc.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:bimbeer/features/navigation/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatListView();
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatState = context.watch<ChatBloc>().state;

    Widget getChildView() {
      if (chatState is ChatListLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (chatState is ChatListLoaded) {
        return ChatList(chatDetailsList: chatState.chatDetails);
      } else {
        return const Center(child: Text('Error'));
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const NavBar(),
            Expanded(
              child: SizedBox(
                // Limit the height of the inner ListView if needed
                height: 400,
                child: getChildView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({required this.chatDetailsList, super.key});

  final List<ChatDetails> chatDetailsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: chatDetailsList.length,
        itemBuilder: (context, index) => ChatPreviewTile(
              chatDetails: chatDetailsList[index],
            ));
  }
}

class ChatPreviewTile extends StatelessWidget {
  const ChatPreviewTile({required this.chatDetails, super.key});

  final ChatDetails chatDetails;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: chatDetails.chatPreview.avatarUrl == ""
          ? const CircleAvatar(
              child: Icon(
                Icons.person,
              ),
            )
          : CircleAvatar(
              backgroundImage: NetworkImage(chatDetails.chatPreview.avatarUrl),
            ),
      title: Text(chatDetails.chatPreview.name),
      subtitle: Text(
          chatDetails.messages.isEmpty ? "" : chatDetails.messages.last.text),
      onTap: () {
        context
            .read<ConversationBloc>()
            .add(ConversationEntered(chatDetails: chatDetails));
        Navigator.of(context).pushNamed(AppRoute.chatPage);
      },
    );
  }
}
