import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:isolate';
import 'package:share_plus/share_plus.dart';

class PolicyPdf extends StatefulWidget {
  String screenTitle = '';
  String pdfUrl = '';

  PolicyPdf({super.key, required this.screenTitle, required this.pdfUrl});

  @override
  State<PolicyPdf> createState() => _PolicyPdfState();
}

class _PolicyPdfState extends State<PolicyPdf> {
  bool check = false;
  ReceivePort _port = ReceivePort();
  String fileName = '';
  bool isLoadingPrint = false;
  bool isLoadingSave = false;

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      print(data);
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  /// Save Pdf
  Future<void> getPdf(String url) async {
    setState(() {
      isLoadingSave = true;
    });
    await requestNotificationPermissions();
    await downloadPdf(url);
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
  }

  Future<Directory> getStorageDirectory() async {
    if (Platform.isAndroid) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return externalDir;
      }
    }
    return await getApplicationDocumentsDirectory();
  }

  downloadPdf(String path) async {
    if (Platform.isAndroid) {
      int sdkInt = 0;
      try {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        sdkInt = deviceInfo.version.sdkInt;
      } catch (e) {
        debugPrint('Error getting androidInfo: $e');
      }

      if (sdkInt > 32) {
        await Permission.photos.request();
      } else {
        await Permission.storage.request();
      }
    }
    await download(path, "InsuranceFile");
  }

  Future download(String url, String filename) async {
    try {
      Random random = Random();
      int randomNumber = random.nextInt(100);
      final baseStorage = await getStorageDirectory();
      fileName = '$filename$randomNumber.${url.split(".").last}';
      setState(() {});
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        savedDir: baseStorage.path,
        fileName: fileName,
        saveInPublicStorage: Platform.isAndroid,
        showNotification: true,
        openFileFromNotification: true,
        requiresStorageNotLow: true,
      );
      print('task id $taskId');
      setState(() {
        isLoadingSave = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: AppText(text: fileDownloading, txtColor: primaryWhite, size: 12)));
    } on Exception catch (e) {
      setState(() {
        isLoadingSave = false;
      });
      print(e);
    }
  }

  /// Print PDF
  getPdfFile(String pdfPath) async {
    setState(() {
      isLoadingPrint = true;
    });
    await requestNotificationPermissions();

    if (Platform.isAndroid) {
      int sdkInt = 0;
      try {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        sdkInt = deviceInfo.version.sdkInt;
      } catch (e) {
        debugPrint('Error getting androidInfo: $e');
      }

      if (sdkInt > 32) {
        await Permission.photos.request();
      } else {
        await Permission.storage.request();
      }
    }

    try {
      Random random = Random();
      int randomNumber = random.nextInt(100);
      final baseStorage = await getStorageDirectory();
      fileName = 'InsuranceFile$randomNumber.${pdfPath.split(".").last}';
      setState(() {});
      final taskId = await FlutterDownloader.enqueue(
        url: pdfPath,
        headers: {},
        savedDir: baseStorage.path,
        fileName: fileName,
        saveInPublicStorage: Platform.isAndroid,
        showNotification: true,
        openFileFromNotification: true,
        requiresStorageNotLow: true,
      );
      print('task id $taskId');
    } on Exception catch (e) {
      setState(() {
        isLoadingPrint = false;
      });
      print(e);
    }

    await Future.delayed(const Duration(seconds: 2));
    sharePdf();
  }

  sharePdf() async {
    try {
      final dir = await getStorageDirectory();
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        Share.shareXFiles([XFile(file.path)]);
      } else {
        debugPrint('File does not exist at ${file.path}');
      }
      print('OOOOOOOOOOOOOOOOOOOOOOO');
      setState(() {
        isLoadingPrint = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPrint = false;
      });
      print(e);
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePageBottomNav(),
                  ),
                  (route) => false);
            },
            child: const Icon(Icons.keyboard_backspace_outlined)),
        title: AppText(text: widget.screenTitle, size: 20, fontWeight: FontWeight.bold),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: buttonColorApp,
                      ),
                      child: InkWell(
                        onTap: () {
                          getPdf(widget.pdfUrl);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoadingSave ? const CircularProgressIndicator(color: primaryWhite) : const Icon(Icons.save_alt_outlined, size: 50, color: primaryWhite),
                            AppText(text: downloadTxt, size: 16, txtAlign: TextAlign.center, txtColor: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: buttonColorApp,
                      ),
                      child: InkWell(
                        onTap: () {
                          getPdfFile(widget.pdfUrl);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoadingPrint ? const CircularProgressIndicator(color: primaryWhite) : const Icon(Icons.share_outlined, size: 50, color: primaryWhite),
                            AppText(text: share, size: 16, txtAlign: TextAlign.center, txtColor: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: buttonColorApp,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.mail_lock_outlined, size: 50, color: primaryWhite),
                          AppText(text: "Share Via Email", size: 16, txtAlign: TextAlign.center, txtColor: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: buttonColorApp,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.share, size: 50, color: primaryWhite),
                          AppText(text: "Share Via Whatsapp", size: 16, txtAlign: TextAlign.center, txtColor: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
            const Spacer(),
            InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePageBottomNav()), (route) => false),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: buttonColorApp,
                  ),
                  child: Center(child: AppText(text: backToHome, fontWeight: FontWeight.bold, txtAlign: TextAlign.center, txtColor: primaryWhite, size: 16)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
