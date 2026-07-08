import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/domain/model/api/notifications.dart';
import 'package:xtridelink/view/ui/dashboard/notifications/cubit/notifications_cubit.dart';
import '../../../../core/constants/helpers.dart';
import '../../../components/back_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    context.read<NotificationsCubit>().loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ashBg,
      body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              Row(children: [
                HelperFunc.sb(20.w),
                Text('Notification',
                        style: AppTextStyles.mediumText(fontSize: 22))
                    .EXPANDED,
                // TextButton(
                //   onPressed: () {},
                //   child: Text('Clear all',
                //       style: AppTextStyles.mediumText(
                //           fontSize: 12, color: AppColors.materialColor)),
                // ),
                HelperFunc.sb(20.w)
              ]),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                return state.notifications.isLoading &&
                        (state.notifications.data ?? []).isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : (state.notifications.data ?? []).isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sms_failed_outlined,
                                  size: 100.h,
                                  color: AppColors.grey.withOpacity(.5)),
                              const Text('No notifications found'),
                              HelperFunc.sb(100.h)
                            ],
                          ))
                        : RefreshIndicator(
                            onRefresh: () async => context
                                .read<NotificationsCubit>()
                                .loadNotifications(),
                            child: ListView.builder(
                                itemCount: state.notifications.data!.length,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    NotificationCard(
                                        notification:
                                            state.notifications.data![index],
                                        isActive: false)),
                          );
              }).EXPANDED,
            ],
          )),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final bool isActive;
  const NotificationCard(
      {super.key, required this.isActive, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(notification.title,
                          style: AppTextStyles.mediumText(fontSize: 15))
                      .EXPANDED,
                  HelperFunc.sb(10.w),
                  Text(
                      notification.createdAt
                          .add(const Duration(hours: 1))
                          .timeAgo,
                      style: AppTextStyles.regularText(
                          fontSize: 10.5, color: AppColors.grey)),
                ],
              ),
              HelperFunc.sb(5.h),
              Text(notification.message,
                  style: AppTextStyles.regularText(
                      fontSize: 10.5, color: AppColors.grey)),
            ],
          ).EXPANDED,
          if (isActive) HelperFunc.sb(20.w),
          if (isActive)
            CircleAvatar(radius: 4.r, backgroundColor: AppColors.red)
        ]),
        Divider(height: 40.h),
      ],
    );
  }
}
