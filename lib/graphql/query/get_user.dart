String getUserQuery = """
  query user(
    \$id: ID!
  ) {
    user(id: \$id) {
      id
      username
      name,
      emirateId,
      address,
      mobile,
      medicalRecord,
      medicalLicense,
      hospital,
    }
  }
""";
