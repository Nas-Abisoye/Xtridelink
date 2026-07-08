import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/domain/model/api/transactions.dart';
import '../../../constants/helpers.dart';
import '../../../../domain/model/api/rider_financial.dart';
import '../request_helper.dart';

sealed class WalletService {
  Future<TransactionData?> withdraw(
      {required num amount,
      required String bankAccountId,
      required String password});
  Future<WalletTransactions?> getTransactions();
  Future<num?> getWalletBalance();
  Future<num?> getOfflineOutstanding();
  Future<FinancialData?> getFinancialData();
  Future<bool> setOfflineOutstanding({required num amount});
}

class WalletServiceImpl extends WalletService {
  RequestHelpersImpl requestHelpers;
  WalletServiceImpl({required this.requestHelpers});

  @override
  Future<TransactionData?> withdraw(
      {required num amount,
      required String bankAccountId,
      required String password}) async {
    String url = '/v1/transactions/rider/transfer/withdraw';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: {
        'amount': amount,
        'bankAccountId': bankAccountId,
        'password': password
      });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return TransactionData.fromJson(body['data'] ?? {});
      } else {
        HelperFunc.toast(body['message']?.toString() ??
            'Failed to withdraw ${amount.formatCurrency} from wallet.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast(
          'Failed to withdraw ${amount.formatCurrency} from wallet.');
    }
    return null;
  }

  @override
  Future<WalletTransactions?> getTransactions() async {
    String url = '/wallets/transactions/';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        WalletTransactionsRes walletTransactionsRes =
            WalletTransactionsRes.fromJson(body);
        return walletTransactionsRes.data;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to get transactions.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get transactions.');
    }
    return null;
  }

  @override
  Future<num?> getWalletBalance() async {
    String url = '/wallets/';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return body['data']['available_balance'] ?? 0;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to get wallet balance.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get wallet balance.');
    }
    return null;
  }

  @override
  Future<FinancialData?> getFinancialData() async {
    String url = '/v1/transactions/financial';
    try {
      // http.Response? res = await requestHelpers.get(url: url);
      // if (res == null) return null;
      // var body = jsonDecode(res.body);
      // if (res.statusCode == 200 || res.statusCode == 201) {
      //   return RiderFinancialModel.fromJson(body).data;
      // } else {
      //   HelperFunc.toast(
      //       body['message']?.toString() ?? 'Failed to get payout percentage.');
      // }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get payout percentage.');
    }
    return null;
  }

  @override
  Future<num?> getOfflineOutstanding() async {
    // String url = '/v1/rider/payout/outstanding';
    // try {
    //   http.Response? res = await requestHelpers.get(url: url);
    //   if (res == null) return null;
    //   var body = jsonDecode(res.body);
    //   if (res.statusCode == 200 || res.statusCode == 201) {
    //     return body['data']?['offlineOutstanding'] ?? 0;
    //   } else {
    //     HelperFunc.toast(body['message']?.toString() ??
    //         'Failed to get outstanding balance.');
    //   }
    // } catch (e) {
    //   log(e.toString());
    //   HelperFunc.toast('Failed to get outstanding balance.');
    // }
    return null;
  }

  @override
  Future<bool> setOfflineOutstanding({required num amount}) async {
    String url = '/v1/transactions/rider/transfer/settle-outstanding';
    try {
      http.Response? res =
          await requestHelpers.post(url: url, body: {'amount': amount});
      if (res == null) return false;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ??
            'Failed to settle outstanding balance.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to settle outstanding balance.');
    }
    return false;
  }
}
