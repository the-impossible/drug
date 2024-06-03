String baseUrl = "http://classmonitoring.pythonanywhere.com/api";

Uri registerUri = Uri.parse("$baseUrl/auth/register/");
Uri loginUri = Uri.parse("$baseUrl/auth/login/");
Uri userUri = Uri.parse("$baseUrl/auth/user/");
Uri patientUri = Uri.parse("$baseUrl/auth/patient/");
Uri userUpdateUri = Uri.parse("$baseUrl/auth/user/update/");
Uri drugsUri = Uri.parse("$baseUrl/core/drugs/");
Uri prescribeUri = Uri.parse("$baseUrl/core/prescribe/");
Uri patientPrescriptionsUri = Uri.parse("$baseUrl/core/prescriptions/");
