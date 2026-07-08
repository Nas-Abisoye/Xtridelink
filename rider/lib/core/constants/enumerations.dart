// ignore_for_file: constant_identifier_names

enum PackageType { parcel, groceries, general }

enum OrderState { pending, onTransit, delivered, cancelled }

enum VehicleType { bicycle, motorcycle, car, truck, van }

enum IdType { passport, drivers_license }

enum AddressVerifyType { utility_bill, bank_statement, lease_agreement }

enum HistoryType { delivered, cancelled }

enum VerifyType { signup, resetPwd }

enum XtridelinkDocsType { legal, terms, privacy }

enum DriverType { standalone, merchant }

enum DriverOrderStage {
  justAccepted,
  onMyWay,
  packagePicked,
  inTransit,
  arrived
}

enum RiderOrderStage {
  packagePicking,
  packagePickedup,
  packageOnTransit,
  packageDelivered
}

enum RiderOrderTab { pending, ongoing }
