String signupMutation = """
mutation signup(
  \$username: String!
  \$name: String
  \$emirateId: String
  \$address: String,
  \$mobile: String,
  \$medicalRecord: String,
  \$medicalLicense: String,
  \$hospital: String
) {
  signup(
    username: \$username,
    name: \$name,
    emirateId: \$emirateId,
    address: \$address,
    mobile: \$mobile,
    medicalRecord: \$medicalRecord,
    medicalLicense: \$medicalLicense,
    hospital: \$hospital
  ) {
    token
    user {
      id
      username
    }
	}
}
""";