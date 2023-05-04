import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/avatar_bloc.dart';
import '../select_avatar_options_page.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const AvatarView();
  }
}

class AvatarView extends StatelessWidget {
  const AvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AvatarBloc, AvatarState>(
      listener: (context, state) {
        if (state.status == AvatarStatus.updated) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Image updated succesfully')));
        } else if (state.status == AvatarStatus.updateFailed) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? '')));
        }
      },
      child: GestureDetector(
        onTap: () {
          _showSelectPhotoOptions(context);
        },
        child: BlocBuilder<AvatarBloc, AvatarState>(
          builder: (context, state) {
            if (state.avatar != null) {
              return CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(state.avatar!),
              );
            } else {
              return const CircleAvatar(
                radius: 80,
                child: Icon(
                  Icons.person,
                  size: 80,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> _showSelectPhotoOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (_, scrollController) {
            return BlocProvider.value(
              value: BlocProvider.of<AvatarBloc>(context),
              child: SingleChildScrollView(
                controller: scrollController,
                child: const SelectAvatarOptionsPage(),
              ),
            );
          }),
    );
  }
}
