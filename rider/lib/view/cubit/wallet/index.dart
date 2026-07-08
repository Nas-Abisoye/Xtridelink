import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/domain/model/api/rider_financial.dart';
import 'package:xtridelink_driver/domain/model/api/transactions.dart';
import 'package:xtridelink_driver/core/services/api/wallet/index.dart';
import '../../../core/services/navigation/index.dart';
import '../../../core/services/navigation/routes.dart';

class WalletState {
  bool isLoading;
  WalletTransactions? transactions;
  num? balance, offlineOutStanding;
  FinancialData? financialData;
  WalletState({
    required this.isLoading,
    required this.transactions,
    required this.balance,
    required this.financialData,
    required this.offlineOutStanding,
  });
}

class WalletCubit extends Cubit<WalletState> {
  WalletServiceImpl walletServiceImpl;
  NavigationServiceImpl navigationServiceImpl;

  WalletCubit(
      {required this.walletServiceImpl, required this.navigationServiceImpl})
      : super(WalletState(
            isLoading: false,
            transactions: null,
            offlineOutStanding: null,
            financialData: null,
            balance: null));

  void _emitState() {
    emit(WalletState(
        isLoading: state.isLoading,
        transactions: state.transactions,
        offlineOutStanding: state.offlineOutStanding,
        financialData: state.financialData,
        balance: state.balance));
  }

  void _setLoading(bool value) {
    state.isLoading = value;
    _emitState();
  }

  void loadWalletDetails() async {
    await getWalletBalance();
    await getTransactions();
    await getOutStandingBalance();
    await getPayoutPercentage();
  }

  Future<void> getWalletBalance() async {
    _setLoading(true);
    state.balance = await walletServiceImpl.getWalletBalance() ?? state.balance;
    _setLoading(false);
  }

  Future<void> getOutStandingBalance() async {
    _setLoading(true);
    state.offlineOutStanding =
        await walletServiceImpl.getOfflineOutstanding() ??
            state.offlineOutStanding;
    _setLoading(false);
  }

  Future<void> getPayoutPercentage() async {
    _setLoading(true);
    state.financialData =
        await walletServiceImpl.getFinancialData() ?? state.financialData;
    _setLoading(false);
  }

  void settleOutstandingBalance({required num amount}) async {
    HelperFunc.showLoader();
    bool success =
        await walletServiceImpl.setOfflineOutstanding(amount: amount);
    navigationServiceImpl.pop();
    if (success) {
      navigationServiceImpl.popUntil(Routes.base);
      navigationServiceImpl.navigateTo(Routes.settleOutstandingSuccess,
          arguments: amount);
      await getWalletBalance();
      getOutStandingBalance();
    }
  }

  Future<void> getTransactions() async {
    _setLoading(true);
    state.transactions =
        await walletServiceImpl.getTransactions() ?? state.transactions;
    _setLoading(false);
  }

  void withdraw(
      {required num amount,
      required String bankAccountId,
      required String password}) async {
    HelperFunc.showLoader();
    TransactionData? transactionData = await walletServiceImpl.withdraw(
        amount: amount, bankAccountId: bankAccountId, password: password);
    navigationServiceImpl.pop();
    if (transactionData != null) {
      navigationServiceImpl.popUntil(Routes.base);
      navigationServiceImpl.navigateTo(Routes.withdrawalSuccess,
          arguments: amount);
      state.transactions?.transactions.add(transactionData);
      _emitState();
      getWalletBalance();
    }
  }

  void clearData() {
    emit(WalletState(
        isLoading: false,
        transactions: null,
        offlineOutStanding: null,
        financialData: null,
        balance: null));
  }
}
