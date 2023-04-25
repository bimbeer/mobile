import 'package:bimbeer/core/presentation/asset_path.dart';
import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/avatar_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../services/image_service.dart';
import '../select_avatar_options_page.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvatarBloc(
          storageRepository: context.read<StorageRepository>(),
          authenticaionRepository: context.read<AuthenticaionRepository>(),
          profileBloc: context.read<ProfileBloc>()),
      child: const AvatarView(),
    );
  }
}

class AvatarView extends StatelessWidget {
  const AvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AvatarBloc, AvatarState>(
      listener: (context, state) {
        if (state is AvatarUpdated) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Image updated succesfully')));
        } else if (state is AvatarUpdateFailed) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text(state.message)));
        }
      },
      child: BlocProvider.value(
        value: BlocProvider.of<AvatarBloc>(context),
        child: GestureDetector(
          onTap: () {
            _showSelectPhotoOptions(context);
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return FutureBuilder<bool>(
                future: validateImage(state.profile.avatar ?? ''),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(state.profile.avatar!),
                    );
                  } else {
                    return const CircleAvatar(
                      radius: 80,
                      child:
                          Icon(Icons.person, size: 80,),
                    );
                  }
                },
              );
            },
          ),
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
