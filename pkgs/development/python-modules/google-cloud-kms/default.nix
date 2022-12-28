{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, grpc-google-iam-v1
, google-api-core
, libcst
, mock
, proto-plus
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "2.12.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ooWxYH4B8HY9ybWj0GQqUnfiFXzLCqyXGGZsocV9Od0=";
  };

  propagatedBuildInputs = [ grpc-google-iam-v1 google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  # Disable tests that need credentials
  disabledTests = [ "test_list_global_key_rings" ];

  pythonImportsCheck = [
    "google.cloud.kms"
    "google.cloud.kms_v1"
  ];

  meta = with lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = "https://github.com/googleapis/python-kms";
    changelog = "https://github.com/googleapis/python-kms/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
