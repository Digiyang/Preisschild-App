import 'package:flutter/widgets.dart';
import 'package:flutter_app/Bakerys/Weichardt/blocs/weichBloc.dart';

class WeichProvider extends InheritedWidget {
  final WeichBloc bloc;
  final Widget child;

  WeichProvider({
    @required this.bloc,
    @required this.child,
  }) : super(child: child);

  static WeichProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WeichProvider>();

  @override
  bool updateShouldNotify(InheritedWidget old) => true;
}
