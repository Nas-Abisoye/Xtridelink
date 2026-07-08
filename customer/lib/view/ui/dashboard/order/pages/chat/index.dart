import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/order_det.dart';
import 'package:xtridelink/view/components/form_field.dart';
import 'package:xtridelink/view/cubit/chat/index.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../../../core/constants/old_assets.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../domain/model/local/chat.dart';
import '../../../../../components/profile_avatar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TimelineChatSheet extends StatefulWidget {
  final OrderDetails order;
  const TimelineChatSheet({super.key, required this.order});

  @override
  State<TimelineChatSheet> createState() => _TimelineChatSheetState();
}

class _TimelineChatSheetState extends State<TimelineChatSheet> {
  late ScrollController scrollController;
  late TextEditingController chatController;
  late IO.Socket socket;

  void _sentMessage(String v) {
    if (v.isEmpty) return;
    var data = ChatTextModel(
            time: DateTime.now(),
            message: chatController.text,
            senderId: widget.order.customerDetails!.id!,
            roomId: widget.order.id!,
            receiverId: widget.order.riderDetails!.id!)
        .toMap;
    socket.emit('sendMessage', data);
    // context.read<ChatCubit>().sinkChatText(data);
    HelperFunc.logger('sendMessage: $data');
    chatController.clear();
  }

  void _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!scrollController.hasClients) {
        if (mounted) {
          scrollController.attach(Scrollable.of(context).position);
        }
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    context
        .read<ChatCubit>()
        .loadPreviousConversations(roomId: widget.order.id!)
        .then((value) {
      _scrollToBottom();
      initSocketService();
      initChatEvents();
    });
    scrollController = ScrollController();
    chatController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    chatController.dispose();
    socket.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    context.read<ChatCubit>().viewChat(widget.order.id!);
    super.deactivate();
  }

  void initSocketService() {
    socket = IO.io('${GlobalStrings.socketUrl}/chat', <String, dynamic>{
      'transports': ['websocket']
    });
    socket.connect();
    socket.onConnect(
        (_) => HelperFunc.logger('Connected to the /chat namespace'));
    socket.onDisconnect(
        (e) => HelperFunc.logger('Disconnected from the /chat namespace: $e'));
    socket.onConnectError(
        (e) => HelperFunc.logger('Error connecting to /chat namespace: $e'));
  }

  void initChatEvents() {
    socket.emit('joinRoom', widget.order.id);
    HelperFunc.logger('joinRoom: ${widget.order.id}');
    socket.on('newMessage', (data) {
      HelperFunc.logger('newMessage: ${jsonEncode(data)}');
      context.read<ChatCubit>().sinkChatText(data);
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: false,
            child: Column(children: [
              SizedBox(height: 10.h),
              Row(children: [
                // ProfileAvatar(
                //     radius: 24, avatar: widget.order.rider?.user.profileImg),
                HelperFunc.sb(8.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('${widget.order.riderDetails?.name ?? ''} ',
                          style: AppTextStyles.mediumText(fontSize: 14)),
                      HelperFunc.sb(2.h),
                      // Text(widget.order.rider?.vehicleName ?? 'N/A',
                      //     style: AppTextStyles.mediumText(
                      //         color: AppColors.grey.withOpacity(.5),
                      //         fontSize: 10)),
                      // HelperFunc.sb(2.h),
                      // Text(
                      //     'Vehicle ID: ${widget.order.rider?.vehiclePlateNo ?? 'N/A'}',
                      //     style: AppTextStyles.mediumText(
                      //         color: AppColors.grey.withOpacity(.5),
                      //         fontSize: 9))
                    ])),
                if ((widget.order.riderDetails?.phoneNumber ?? '').isNotEmpty)
                  GestureDetector(
                    onTap: () => HelperFunc.makePhoneCall(
                        widget.order.riderDetails?.phoneNumber ?? ''),
                    child: CircleAvatar(
                        radius: 17.r,
                        backgroundColor: AppColors.grey.withOpacity(.25),
                        child: SvgPicture.asset(Assets.phone)),
                  )
              ]),
              Expanded(child:
                  BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.chats.isEmpty) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.error_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text('No chat yet', style: AppTextStyles.mediumText())
                  ]).align(Alignment.center);
                }
                return Column(children: [
                  Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.only(top: 20.h, bottom: 100.h),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return MessageCard(
                                receiverImg: '',
                                format: HelperFunc.timeFormat,
                                isSender: widget.order.customerDetails!.id ==
                                    state.chats[i].senderId,
                                chatTextModel: state.chats[i]);
                          },
                          itemCount: state.chats.length)),
                ]);
              })),
              AppFormField(
                  hintText: 'Type your message',
                  controller: chatController,
                  validator: (v) => null,
                  fillColor: Colors.transparent,
                  borderColor: AppColors.grey.withOpacity(.15),
                  onFieldSubmitted: _sentMessage,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
                  radius: 50.r,
                  textInputAction: TextInputAction.send,
                  suffixWidget: GestureDetector(
                    onTap: () => _sentMessage(chatController.text),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 4.h, 7.w, 4.h),
                        child: CircleAvatar(
                            radius: 17.r,
                            backgroundColor: AppColors.grey.withOpacity(.9),
                            child: Icon(Icons.send,
                                color: AppColors.ashBg, size: 20.h))),
                  )),
              HelperFunc.sb(10.h)
            ])));
  }
}

class MessageCard extends StatelessWidget {
  final ChatTextModel chatTextModel;
  final bool isSender;
  final DateFormat format;
  final String? receiverImg;
  const MessageCard(
      {Key? key,
      required this.chatTextModel,
      required this.isSender,
      this.receiverImg,
      required this.format})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ProfileAvatar(radius: 17.r, avatar: receiverImg),
          if (!isSender) HelperFunc.sb(7.w),
          Expanded(
            child: Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 20.w),
                      margin: EdgeInsets.only(
                          left: isSender ? 70.w : 0,
                          right: isSender ? 0 : 70.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: isSender
                              ? AppColors.lightPri
                              : AppColors.lightSec),
                      child: Text(chatTextModel.message,
                          style: AppTextStyles.regularText())),
                  HelperFunc.sb(5.h),
                  Text('  ${format.format(chatTextModel.time).toLowerCase()}',
                      style: AppTextStyles.mediumText(fontSize: 11)),
                  HelperFunc.sb(12.h)
                ]),
          ),
          if (isSender) HelperFunc.sb(7.w),
          if (isSender)
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
              return ProfileAvatar(radius: 17.r, avatar: '');
            })
        ]);
  }
}
