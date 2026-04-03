import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider, ReadContext;

class Scopd<O extends Widget, V extends Object, C extends Widget>
    extends StatelessWidget {
  const Scopd(this.value, {required this.child, this.owner, super.key});

  final V value;
  final O? owner;
  final C child;

  @override
  Widget build(BuildContext context) {
    return switch (owner) {
      final O owner => Provider.value(
        value: (owner: owner, value: value),
        child: child,
      ),
      _ => Provider.value(value: (owner: child, value: value), child: child),
    };
  }
}

extension ScopdWidgetX<T extends Widget> on T {
  Widget scopd<O extends Widget, V extends Object>(V value, {O? owner}) {
    return switch (owner) {
      final O owner => Provider.value(
        value: (owner: owner, value: value),
        child: this,
      ),
      _ => Provider.value(value: (owner: this, value: value), child: this),
    };
  }
}

extension ScopdBuildContextX on BuildContext {
  V read<O extends Widget, V extends Object>() {
    try {
      final value = ReadContext(this).read<({O owner, V value})>().value;
      return value;
    } catch (e) {
      throw Exception('''
Failed to read <$O, $V>. Did you forget to scope it?

Example usage:

MyWidget(foo: bar).scopd((foo: 1, bar: true))

MyWidget(foo: bar).scopd(MyValue(), owner: owner)
        ''');
    }
  }
}
