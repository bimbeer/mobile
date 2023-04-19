import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/bloc/app_bloc.dart';

class PairsPage extends StatelessWidget {
  const PairsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Center(child: Text('Pairs page - user: ${user.email ?? ''}'));
  }
}
