import 'package:bimbeer/core/presentation/widgets/pop_page_button.dart';
import 'package:flutter/material.dart';

class EditScreenTitle extends StatelessWidget {
  const EditScreenTitle({super.key, required this.pageTitle});

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Text(
                    pageTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: PopPageButton(),
                    ),
                  ),
                ),
              ],
            );
  }
}