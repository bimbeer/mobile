import 'package:bimbeer/features/navigation/view/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.dart';
import '../../pairs/view/profile_preview_page.dart';
import '../bloc/profile_bloc.dart';
import 'widgets/avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          const NavBar(),
          const Avatar(),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) {
              return previous.profile.username != current.profile.username ||
                  previous.profile.age != current.profile.age;
            },
            builder: (context, state) {
              String? name = state.profile.username;
              int? age = state.profile.age;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePreviewPage(
                              profile: state.profile,
                            )),
                  );
                },
                child: Text(
                  '$name, $age',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            crossAxisSpacing: 20,
            mainAxisSpacing: 30,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: const [
              ButtonTile(
                label: 'Profile',
                icon: Icons.edit,
                route: AppRoute.editProfile,
              ),
              ButtonTile(
                  label: 'Distance', icon: Icons.map, route: AppRoute.location),
              ButtonTile(
                label: 'Settings',
                icon: Icons.settings,
                route: AppRoute.settings,
              ),
              ButtonTile(
                  label: 'Beers',
                  icon: Icons.wine_bar,
                  route: AppRoute.pickBeer),
            ],
          ),
        ]),
      )),
    );
  }
}

class ButtonTile extends StatelessWidget {
  const ButtonTile({
    required this.label,
    required this.icon,
    required this.route,
    super.key,
  });

  final String label;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(route);
        },
        style: ElevatedButton.styleFrom(
          textStyle: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  label,
                ))),
            Expanded(
                flex: 1,
                child: Center(
                    child: Icon(
                  icon,
                  size: 30,
                ))),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}
