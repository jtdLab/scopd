# scopd

Typed, owner-aware scoping for Flutter widgets.

## Problem

Lookups that only use the value's type break down when you need more than one value of that type in the tree: nested scopes usually *shadow* the outer one, so you cannot read both. **scopd** fixes that by scoping with an **owner** type `O` together with the value type `V`, so you can resolve the same `V` in different places without the inner scope hiding the outer.

Wrap widgets with `Scopd` or the `.scopd()` extension, then read values from `BuildContext` with `context.read<O, V>()`.

## Usage

**Extension** — child widget is the implicit owner when `owner` is omitted:

```dart
MyWidget(foo: bar).scopd((foo: 1, bar: true));

final controller = TextEditingController();
MyWidget(foo: bar).scopd(
  (controller: controller, foo: false, bar: 'bar'),
  owner: owner,
);
```

**`Scopd` widget** — same layout, useful when the scope wraps a subtree without chaining on the child:

```dart
Scopd(
  (foo: 1, bar: true),
  child: MyWidget(foo: bar),
);

Scopd(
  (controller: controller, foo: false, bar: 'bar'),
  owner: owner,
  child: MyWidget(foo: bar),
);
```

**Reading** — use the same owner type `O` and value type `V` you scoped with (here `MyWidget` and the record):

```dart
typedef OwnerWidgetParams = ({TextEditingController controller, bool foo, String bar});

Widget build(BuildContext context) {
  final data = context.read<MyWidget, ({int foo, bool bar})>();
}

Widget build(BuildContext context) {
  final data = context.read<OwnerWidget, OwnerWidgetParams>();
}
```
