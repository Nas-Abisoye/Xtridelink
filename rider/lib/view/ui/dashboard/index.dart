import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/core/services/location/index.dart';
import 'package:xtridelink_driver/domain/model/api/new_order_bid_request.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/components/form_field.dart'
    show AppFormField;
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/history/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/home/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/order/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/profile/index.dart';
import 'package:xtridelink_driver/view/ui/dashboard/wallet/index.dart';
import '../../../core/services/updates/index.dart';
import '../../../di/get_it.dart';
import '../../cubit/settings/index.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  late ValueNotifier<int> tabIdx;

  @override
  void initState() {
    context.read<SettingsCubit>().loadSettings();
    tabIdx = ValueNotifier(0);
    WidgetsBinding.instance.addObserver(this);
    _checkForUpdate();
    super.initState();
  }

  @override
  void dispose() {
    tabIdx.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      return;
    }

    if (state == AppLifecycleState.detached) {
      getItInst<LocationMapService>().cancelLocationStream();
      return;
    }

    super.didChangeAppLifecycleState(state);
  }

  void _checkForUpdate() async {
    await getItInst<UpdateServiceImpl>().updateIfAny();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              ValueListenableBuilder(
                  valueListenable: tabIdx,
                  builder: (context, value, _) {
                    return IndexedStack(index: value, children: const [
                      HomePage(),
                      HistoryPage(),
                      WalletPage(),
                      ProfilePage()
                    ]);
                  }),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: SafeArea(
                              top: false,
                              child: SizedBox(
                                  width: double.infinity, height: 45.h))))),
              Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: 5.h,
                  child: BottomNavigationBar(tabIdx: tabIdx)),
            ],
          ),
        ));
  }
}

/// Bottom navigation widget
class BottomNavigationBar extends StatelessWidget {
  final ValueNotifier<int> tabIdx;
  const BottomNavigationBar({super.key, required this.tabIdx});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        decoration: BoxDecoration(
            color: Colors.white,
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
            borderRadius: BorderRadius.circular(100.r)),
        child: ValueListenableBuilder(
            valueListenable: tabIdx,
            builder: (context, int value, _) {
              return Row(
                children: [
                  BottomNavItem(
                      svg: Assets.home,
                      txt: 'Home',
                      color: value == 0
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 0),
                  BottomNavItem(
                      svg: Assets.history,
                      txt: 'History',
                      color: value == 1
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 1),
                  const OrderDispatch(),
                  BottomNavItem(
                      svg: Assets.wallet,
                      txt: 'Wallet',
                      color: value == 2
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 2),
                  BottomNavItem(
                      svg: Assets.profile,
                      txt: 'Profile',
                      color: value == 3
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 3),
                ],
              );
            }),
      ),
    );
  }
}

/// Single bottom navigation item widget
class BottomNavItem extends StatelessWidget {
  final String svg, txt;
  final Color color;
  final void Function() onTap;
  const BottomNavItem(
      {super.key,
      required this.svg,
      required this.txt,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svg, color: color),
            HelperFunc.sb(3.h),
            Text(txt,
                style: AppTextStyles.mediumText(color: color, fontSize: 10))
          ],
        ),
      ),
    ).EXPANDED;
  }
}

class BidRequestView extends StatefulWidget {
  final NewOrderBidRequest bidRequest;
  final Function(double bidAmount) onSubmit;
  final VoidCallback onClose;

  const BidRequestView({
    super.key,
    required this.bidRequest,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<BidRequestView> createState() => _BidRequestViewState();
}

class _BidRequestViewState extends State<BidRequestView> {
  final TextEditingController _bidController = TextEditingController();
  String? _errorText;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _bidController.text = widget.bidRequest.basePrice ?? '';
    _audioPlayer.play(AssetSource(Assets.audio));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _bidController.text.replaceAll(',', '');
    final amount = double.tryParse(text);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorText = 'Enter a valid bid amount';
      });
    } else {
      widget.onSubmit(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.bidRequest;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Delivery Request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.materialColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Bid Info
          _buildBidInfo(req),

          const SizedBox(height: 12),

          /// Bid Input

          AppFormField(
              hintText: 'Amount',
              labelText: 'Enter your bid (₦)',
              controller: _bidController,
              keyBoardType: TextInputType.number,
              isPassword: false,
              validator: (v) => null),

          const SizedBox(height: 12),

          /// Submit Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onTap: _handleSubmit,
              btnText: 'Submit Bid',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidInfo(NewOrderBidRequest req) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTile(Icons.receipt_long, "Order ID", req.orderId!.toOrderIdTag()),
        _infoTile(Icons.location_on, "Pickup Address", req.pickupAddress),
        _infoTile(Icons.flag, "Delivery Address", req.deliveryAddress),
        // _infoTile(Icons.inventory_2, "Package Type", req.packageType),
        // _infoTile(Icons.local_shipping, "Vehicle Type", req.vehicleType),
        _infoTile(Icons.map, "Distance",
            "${req.distance?.toStringAsFixed(2) ?? '-'} km"),
        _infoTile(Icons.attach_money, "Base Price", "₦${req.basePrice ?? '-'}"),
        // _infoTile(
        //     Icons.timer, "Bid Timeout", "${req.bidTimeoutSeconds ?? 0} sec"),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey, size: 15),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? "-",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
