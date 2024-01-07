part of 'view.dart';

class LText extends StatelessWidget {
  const LText(this.textKey, {Key? key}) : super(key: key);

  final String textKey;

  @override
  Widget build(BuildContext context) {
    return Text(textKey).tr();
  }
}
