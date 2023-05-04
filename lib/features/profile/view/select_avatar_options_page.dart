import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/avatar_bloc.dart';

class SelectAvatarOptionsPage extends StatelessWidget {
  const SelectAvatarOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectAvatarOptionsView();
  }
}

class SelectAvatarOptionsView extends StatelessWidget {
  const SelectAvatarOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            _SelectPhoto(
              onTap: () {
                context.read<AvatarBloc>().add(const AvatarChangeRequested(ImageSource.gallery));
              },
              icon: Icons.image,
              textLabel: 'Browse Gallery',
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'OR',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _SelectPhoto(
              onTap: () {
                context.read<AvatarBloc>().add(const AvatarChangeRequested(ImageSource.camera));
              },
              icon: Icons.camera_alt_outlined,
              textLabel: 'Use a Camera',
            ),
          ])
        ],
      ),
    );
  }
}

class _SelectPhoto extends StatelessWidget {
  final String textLabel;
  final IconData icon;

  final void Function()? onTap;

  const _SelectPhoto({
    Key? key,
    required this.textLabel,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              textLabel,
            )
          ],
        ),
      ),
    );
  }
}
