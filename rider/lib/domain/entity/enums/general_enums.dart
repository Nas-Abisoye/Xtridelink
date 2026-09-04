enum DeviceType { Terminal, Mobile }

enum WithdrawalType { withdrawal, sendMoney }

enum LibCardType { savings, current, credit, defaults }

enum BankPerformanceType { transfer, withdrawal }

enum PhoneCubitStatus { idle, referralCodeValid, referralLoading }

enum CardTransactionHistoryStatus { idle, loading, loaded, error }

enum LogDisputeStatus { initial, loading, error, success }

enum SettingsStatus {
  initial,
  loading,
  error,
  success,
  otpRequested,
  toggleOtpRequested,
}

enum LibDeviceState {
  doneProcessing,
  error,
  printingDone,
  processing,
  successful,
  printingFailed,
  transCancelled,
  transFailed,
  transDone,
}

enum TransactionType { credit, debit, commission }

enum AjoCashoutType { ussd, card, external, onlending }

enum AjoUserWalletType { savings, spending, wallet }

enum SavingsPaymentIntervals { daily, weekly, monthly }

enum MerchantPinStatus {
  idle,
  otpRequested,
  otpSent,
  otpConfirmed,
  pinCreated,
  pinToggled,
  userUpdated,
}

enum RequestCardSettingsStatus {
  idle,
  loading,
  error,
  transactionLimitRetreived,
  transactionLimitUpdated;

  bool get isIdle => this == idle;
  bool get isLoading => this == loading;
  bool get isError => this == error;
  bool get isTransactionLimitRetreived => this == transactionLimitRetreived;
  bool get isTransactionLimitUpdated => this == transactionLimitUpdated;
}

enum RequestCardStatus {
  intial,
  idle,
  loading,
  error,
  addressesRetreived,
  cardActivated,
  addressAdded,
  addressDeleted,
  orderPlaced,
  transactionLimitModified,
  freezeCardStatusModified,
  cardListRetreived,
  cardRequestsRetrieved,
  cardRegistered,
  pricingRetreived;

  bool get isidle => this == idle;
  bool get isintial => this == intial;
  bool get iscardActivated => this == cardActivated;
  bool get isCardListRetreived => this == cardListRetreived;
  bool get isloading => this == loading;
  bool get iserror => this == error;
  bool get isaddressesRetreived => this == addressesRetreived;
  bool get isaddressAdded => this == addressAdded;
  bool get isaddressDeleted => this == addressDeleted;
  bool get isorderPlaced => this == orderPlaced;
  bool get isCardRequestsRetrieved => this == cardRequestsRetrieved;
  bool get isCardRegistered => this == cardRegistered;
  bool get ispricingRetreived => this == pricingRetreived;
  bool get istransactionLimitModified => this == transactionLimitModified;
}

enum SendLottoStatus {
  initial,
  success,
  banksLoading,
  accountNameLoading,
  banksSuccess,
  transferLoading,
  transferSuccess,
  accountNameSuccess,
  beneficiaryReceived,
  beneficiariesReceived,
  beneficiaryChanged,
  userDetailsRetreived,
  error;

  bool get isInitial => this == initial;

  bool get isUserDetailsRetreived => this == userDetailsRetreived;

  bool get isSuccess => this == success;

  bool get isBanksLoading => this == banksLoading;

  bool get isAccountNameLoading => this == accountNameLoading;

  bool get isBanksSuccess => this == banksSuccess;

  bool get isTransferLoading => this == transferLoading;

  bool get isTransferSuccess => this == transferSuccess;

  bool get isAccountNameSuccess => this == accountNameSuccess;

  bool get isBeneficiaryReceived => this == beneficiaryReceived;

  bool get isBeneficiariesReceived => this == beneficiariesReceived;

  bool get isBeneficiaryChanged => this == beneficiaryChanged;

  bool get isError => this == error;
}

enum BuildFlavor {
  dev,
  prod,
  playStore,
  main,
  stg;

  bool get isdev => this == dev;

  bool get isprod => this == prod;

  bool get isplayStore => this == playStore;

  bool get isStg => this == stg;

  bool get isMain => this == main;
}

enum DebitCardType {
  physical,
  virtual;

  static Map<DebitCardType, String> cardMap = {
    DebitCardType.physical: 'PHYSICAL',
    DebitCardType.virtual: 'VIRTUAL',
  };

  String get mapString => cardMap[this] ?? '';
}

enum OTPMediumType { SMS, VOICE, WHATSAPP, USSD }

enum AjoVerificationStage { ONBOARDING, CARD_ISSUING, LOAN_REQUEST }

enum AjoCardUsersFilter { card, pending, nocard }

enum AjoTransactionStatus { SUCCESS, FAILED, PENDING }

enum RecurrentSavingsStatus {
  NONE,
  ACTIVE,
  PAUSED;

  bool get isNone => this == NONE;

  bool get isActive => this == ACTIVE;

  bool get isPaused => this == PAUSED;
}

enum ChestlockSavingsType {
  RECURRENT,
  ONEOFF;

  bool get isRecurrent => this == RECURRENT;

  bool get isOneOff => this == ONEOFF;
}

enum AjoWalletType {
  AJO_AGENT,
  ROTATIONGROUP,
  PERSONAL_AJO;

  bool get isAjoAgent => this == AJO_AGENT;

  bool get isRotation => this == ROTATIONGROUP;

  bool get isPersonal => this == PERSONAL_AJO;
}

enum AjoPlanFrequency {
  DAILY,
  WEEKLY,
  MONTHLY;

  bool get isDaily => this == DAILY;

  bool get isWeekly => this == WEEKLY;

  bool get isMonthly => this == MONTHLY;
}

enum PersonalCashoutType { ajo, rotation }

enum AjoType { PERSONAL, AGENT }

enum AjoAgentRoscaCollectionType { ONE_OFF_DEDUCTION, RECURING_DEDUCTION }

enum AjoUserProfileEditRequestStatus { PROCESSING, SUCCESSFUL, FAILED, NONE }

enum AjoLoanUserDocumentationStatus {
  processed,
  processing,
  incomplete,
  failed,
  completed,
  pending
}
