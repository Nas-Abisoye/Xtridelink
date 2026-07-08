import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/core/constants/helpers.dart';
import '../../../../domain/model/local/bank.dart';
import '../request_helper.dart';

abstract class BankService {
  Future<List<BankModel>?> getBankList();
  Future<String?> verifyAccount({required accountNumber, required bankCode});
  Future<List<UserBankAccount>?> getUserBankAccounts();
  Future<bool> deleteAccount({required String id});
  Future<UserBankAccount?> addAccount(
      {required String accountName,
      required String accountNumber,
      required String bankName,
      required String bankCode});
}

class BankServiceImpl extends BankService {
  final http.Client httpClient;
  final RequestHelpersImpl requestHelpers;

  BankServiceImpl({required this.httpClient, required this.requestHelpers});

  @override
  Future<List<BankModel>?> getBankList() async {
    String url = '/v1/transactions/profile/bank-account/list-banks';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        BankResModel bankResModel = BankResModel.fromJson(body);
        return bankResModel.data;
      } else {
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to get banks');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get banks');
    }
    return null;
  }

  @override
  Future<String?> verifyAccount(
      {required accountNumber, required bankCode}) async {
    String url = '/v1/transactions/profile/bank-account/resolve';
    try {
      http.Response? res = await requestHelpers.get(url: url, queryParameters: {
        'accountNumber': accountNumber,
        'bankCode': bankCode
      });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return body['data']?['account_name'] ?? '';
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to fetch bank details');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to fetch bank details');
    }
    return null;
  }

  @override
  Future<UserBankAccount?> addAccount(
      {required String accountName,
      required String accountNumber,
      required String bankName,
      required String bankCode}) async {
    String url = '/v1/rider/profile/bank-account/add';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: {
        'accountName': accountName,
        'accountNumber': accountNumber,
        'bankName': bankName,
        'bankCode': bankCode
      });
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Account added successfully.');
        return UserBankAccount.fromJson(body['data'] ?? {});
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to add account.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to add account.');
    }
    return null;
  }

  @override
  Future<bool> deleteAccount({required String id}) async {
    String url = '/v1/rider/profile/bank-account/$id';
    try {
      http.Response? res = await requestHelpers.delete(url: url);
      if (res == null) return false;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        HelperFunc.toast('Account deleted successfully.');
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to delete account.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to delete account.');
    }
    return false;
  }

  @override
  Future<List<UserBankAccount>?> getUserBankAccounts() async {
    String url = '/v1/rider/profile/bank-account/all';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        UserBankAccountsRes userBankAccountsRes =
            UserBankAccountsRes.fromJson(body);
        return userBankAccountsRes.data;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to get accounts.');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to get accounts.');
    }
    return null;
  }
}
