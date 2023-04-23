import 'package:bimbeer/features/navigation/view/navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          NavBar(),
          CircleAvatar(
            radius: 80,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Name, 30',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 40,
          ),
          GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 120),
            crossAxisSpacing: 20,
            mainAxisSpacing: 30,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              ButtonTile(label: 'Profile', icon: Icons.edit, route: AppRoute.editProfile,), 
              ButtonTile(label: 'Distance', icon: Icons.map, route: AppRoute.editProfile), 
              ButtonTile(label: 'Settings', icon: Icons.settings,route: AppRoute.editProfile,), 
              ButtonTile(label: 'Beers', icon: Icons.wine_bar, route: AppRoute.editProfile), 
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
          )),
    );
  }
}
