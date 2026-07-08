import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/model/local/chat.dart';
import '../../../core/services/api/order/index.dart';

class ChatState {
  bool isLoading;
  List<ChatTextModel> chats;
  List<String> newChat;
  ChatState(
      {required this.isLoading, required this.newChat, required this.chats});
}

class ChatCubit extends Cubit<ChatState> {
  final OrderApiServiceImpl orderServiceImpl;
  ChatCubit({required this.orderServiceImpl})
      : super(ChatState(isLoading: false, chats: [], newChat: []));

  void _emitState() {
    emit(ChatState(
        isLoading: state.isLoading,
        newChat: state.newChat,
        chats: state.chats));
  }

  void _setLoading(bool v) {
    state.isLoading = v;
    _emitState();
  }

  void sinkChatText(dynamic data) {
    if (data['senderId'] == state.chats.lastOrNull?.senderId &&
        data['message'] == state.chats.lastOrNull?.message &&
        data['receiverId'] == state.chats.lastOrNull?.receiverId) return;
    emit(ChatState(
        isLoading: state.isLoading,
        newChat: state.newChat,
        chats: [...state.chats, ChatTextModel.fromMap(data)]));
  }

  Future<void> loadPreviousConversations({required String roomId}) async {
    viewChat(roomId);
    _setLoading(true);
    List<ChatTextModel> chats = await orderServiceImpl.getChats(roomId: roomId);
    state.chats = chats;
    _setLoading(false);
  }

  void viewChat(String id) {
    state.chats = [];
    state.newChat.remove(id);
    _emitState();
  }

  void addChatNotification(String id){
    if(state.newChat.contains(id)) return;
    state.newChat.add(id);
    _emitState();
  }
}
