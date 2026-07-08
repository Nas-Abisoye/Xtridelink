class VehicleVerificationParams {
  final String? vehicleType;
  final String? vehicleName;
  final String? registrationNumber;
  final List<String>? vehicleDocuments;

  VehicleVerificationParams({
    this.vehicleType,
    this.vehicleName,
    this.registrationNumber,
    this.vehicleDocuments,
  });

  Map<String, dynamic> toMap() => {
        'vehicle_type': vehicleType,
        'vehicle_name': vehicleName,
        'registration_number': registrationNumber,
        'vehicle_documents': vehicleDocuments == null
            ? []
            : List<dynamic>.from(vehicleDocuments!.map((x) => x)),
      };
}
