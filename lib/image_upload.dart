// To link with Google Drive API
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

class DriveUtilities {
  Future<void> uploadImage(String imagePath, List<String> tags) async {
    try {
      final googleSignIn =
          signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.DriveScope]);
      final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
      print("User account $account");

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);
      drive.File driveFile = drive.File();
      driveFile.name = imagePath;
      File file = File(imagePath);
      final result = await driveApi.files.create(
        driveFile,
        uploadMedia: drive.Media(
          file.openRead(),
          file.lengthSync(),
        ),
      );
      print(result.size);
    } catch (err) {
      print("Error :::");
      print(err);
    }
    // Google Drive API Uploading
  }

  Future<List<String>> listGoogleDriveFiles() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [
      drive.DriveApi.DriveScope,
    ]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    print("User account $account");
    List<String> fileList = [];

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);
    final files = await driveApi.files.list();
    files.files.forEach((element) {
      fileList.add(element.name);
    });

    return fileList;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
