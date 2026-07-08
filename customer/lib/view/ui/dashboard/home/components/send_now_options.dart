import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/order_details.dart';

import '../../../../../core/constants/helpers.dart';
import '../../order/order_dispatch.dart';

class HomeSendNowOptions extends StatelessWidget {
  const HomeSendNowOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Send Now', style: AppTextStyles.semiBold(fontSize: 15))
          .pd(EdgeInsets.only(left: 20.w)),
      SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: PackageType.values
                  .map((e) => OrderOptionsCard(
                          onTap: () => e == PackageType.general
                              ? HelperFunc.showCustomBottomSheet(
                                  context: context,
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: ListView(
                                      shrinkWrap: true,
                                      children: GeneralPackageTypes.values
                                          .map((e) => TextButton(
                                                onPressed: () {
                                                  globalPop();
                                                  globalNavigateTo(
                                                      route: Routes
                                                          .provideOrderDet,
                                                      arguments:
                                                          PackageOrderParam(
                                                              packageType:
                                                                  PackageType
                                                                      .general,
                                                              orderType:
                                                                  OrderType
                                                                      .send,
                                                              generalPackageType:
                                                                  e,
                                                              orderDet: null));
                                                },
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    e.txt,
                                                    style: AppTextStyles
                                                        .mediumText(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                              ))
                                          .toList()))
                              : globalNavigateTo(
                                  route: Routes.provideOrderDet,
                                  arguments: PackageOrderParam(
                                      packageType: e,
                                      orderType: OrderType.send,
                                      generalPackageType: null,
                                      orderDet: null)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.01),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 0)),
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 0))
                          ],
                          avatarColor: e.color,
                          avatarRadius: 21,
                          txtFont: 12,
                          fillColor: Colors.white,
                          avatarSvg: e.asset,
                          headerTxt: '${e.name.capitalizeFirstLetter}  ')
                      .pd(EdgeInsets.only(right: 10.w)))
                  .toList()))
    ]);
  }
}
