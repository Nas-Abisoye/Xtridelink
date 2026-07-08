class AddressVerificationParams {
  final String? documentType;
  final List<String>? addressDocuments;

  AddressVerificationParams({
    this.documentType,
    this.addressDocuments,
  });

  Map<String, dynamic> toMap() => {
        'document_type': documentType,
        'address_documents': addressDocuments == null
            ? []
            : List<dynamic>.from(addressDocuments!.map((x) => x)),
      };
}
