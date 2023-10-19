import 'package:bimbeer/features/navigation/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/color_schemes.g.dart';
import '../../../core/router/app_router.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavBarView();
  }
}

class NavBarView extends StatelessWidget {
  const NavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    Color getActiveIconColor() {
      return darkColorScheme.primary;
    }

    Color getInactiveIconColor() {
      return Theme.of(context).iconTheme.color!;
    }

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(AppRoute.chatList);
                    context.read<NavigationCubit>().navigateToChat();
                  },
                  icon: Icon(
                    Icons.chat_bubble,
                    color: state is NavigationChat
                        ? getActiveIconColor()
                        : getInactiveIconColor(),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(AppRoute.pairs);
                    context.read<NavigationCubit>().navigateToPairs();
                  },
                  icon: Icon(
                    Icons.handshake,
                    color: state is NavigationPairs
                        ? getActiveIconColor()
                        : getInactiveIconColor(),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(AppRoute.profile);
                    context.read<NavigationCubit>().navigateToProfile();
                  },
                  icon: Icon(
                    Icons.account_box,
                    color: state is NavigationProfile
                        ? getActiveIconColor()
                        : getInactiveIconColor(),
                  )),
            ],
          ),
        );
      },
    );
  }
}
