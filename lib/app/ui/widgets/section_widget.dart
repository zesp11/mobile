// A reusable section widget for displaying content with a title.
import 'package:flutter/widgets.dart';

class SectionWidget extends StatelessWidget {
  final Widget child;

  const SectionWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
        ],
      ),
    );
  }
}
