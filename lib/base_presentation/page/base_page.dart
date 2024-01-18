import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BuildBasePage {
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  Widget buildBody(BuildContext context);

  Widget? buildFloatingActionButton(BuildContext context) => null;
}

abstract class BasePage extends StatelessWidget implements BuildBasePage {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context);

  @override
  Widget? buildFloatingActionButton(BuildContext context) => null;
}

abstract class BasePageState<T extends StatefulWidget> extends State<T> implements BuildBasePage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context);

  @override
  Widget? buildFloatingActionButton(BuildContext context) => null;
}

abstract class SingleProviderBasePage<C extends Cubit> extends BasePage {
  const SingleProviderBasePage(this.cubit, {super.key});

  final C cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(create: (_) => cubit, child: super.build(context));
  }
}

abstract class SingleProviderBasePageState<T extends StatefulWidget, C extends Cubit> extends BasePageState<T> {
  final C cubit;

  SingleProviderBasePageState({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(create: (_) => cubit, child: super.build(context));
  }
}

abstract class MultiProviderBasePage extends BasePage {
  const MultiProviderBasePage({super.key});

  Widget buildMultiBlocProvider({Widget child});

  @override
  Widget build(BuildContext context) {
    return buildMultiBlocProvider(
      child: super.build(context),
    );
  }
}
