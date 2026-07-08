import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink/core/base/base_cubit.dart';
import 'package:xtridelink/core/base/base_state.dart';
import 'package:xtridelink/core/helpers/error_handler/error_handler_factory.dart';
import 'package:xtridelink/core/helpers/error_handler/error_listener_mixin.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:xtridelink/core/widgets/simple_loading_widget.dart';

abstract class BaseStatelessPage<B extends BaseCubit> extends StatelessWidget
    with ErrorListenerMixin {
  const BaseStatelessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<B, BaseState>(
          listenWhen: (previous, current) =>
              previous.exception != current.exception,
          listener: (context, state) {
            if (state.exception != null) {
              ErrorHandlerFactory.handleErrorByType(
                context,
                state.exception!,
                this,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<B, BaseState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Stack(
            children: [
              buildPage(context),
              if (state.isLoading) ...[
                const ModalBarrier(
                  dismissible: false,
                  color: Colors.black26,
                ),
                showLoading(),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget buildPage(BuildContext context);

  Widget showLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: SimpleLoadingWidget(),
      ),
    );
  }
}
