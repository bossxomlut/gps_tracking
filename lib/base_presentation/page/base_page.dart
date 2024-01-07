import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  Widget buildBody(BuildContext context);
}

abstract class SingleProviderBasePage<C extends Cubit> extends BasePage {
  const SingleProviderBasePage(this.cubit, {super.key});

  final C cubit;

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
