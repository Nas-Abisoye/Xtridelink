class IdVerificationParams {
  final String? idType;
  final String? idNumber;
  final List<String>? idDocuments;

  IdVerificationParams({
    this.idType,
    this.idNumber,
    this.idDocuments,
  });

  Map<String, dynamic> toMap() => {
        'id_type': idType,
        'id_number': idNumber,
        'id_documents': idDocuments == null
            ? []
            : List<dynamic>.from(idDocuments!.map((x) => x)),
      };
}
