import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soperia_user/Screens/HomeScreen/home_screen_bottom.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_keys.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

class PolicyPdf extends StatefulWidget {
  String screenTitle = '';
  String pdfUrl = '';
  dynamic purchasePolicyId;

  PolicyPdf({super.key, required this.screenTitle, required this.pdfUrl, this.purchasePolicyId});

  @override
  State<PolicyPdf> createState() => _PolicyPdfState();
}

class _PolicyPdfState extends State<PolicyPdf> {
  final ReceivePort _port = ReceivePort();
  String fileName = '';
  bool isLoadingPrint = false;
  bool isLoadingSave = false;
  String generatedPdfUrl = '';
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      debugPrint('Downloader port data: $data');
      if (mounted) {
        setState(() {});
      }
    });
    try {
      FlutterDownloader.registerCallback(downloadCallback);
    } catch (e) {
      debugPrint('Error registering FlutterDownloader callback: $e');
    }
  }

  /// Get Final Signed PDF URL
  Future<String> fetchFinalPdfUrl(String fallbackUrl) async {
    if (generatedPdfUrl.isNotEmpty) {
      return generatedPdfUrl;
    }
    if (widget.purchasePolicyId != null && widget.purchasePolicyId != 0) {
      try {
        final repo = getIt.get<ApiCall>();
        Map<String, dynamic> body = {
          'purchase_policy_id': widget.purchasePolicyId,
        };
        Map<String, String> header = await getHeader();
        Map<String, dynamic> response = await ApiCall(dioClient: repo.dioClient).postRequestFormData(
          context: context,
          endpoint: generateFinalPdf,
          body: body,
          options: Options(headers: header),
        );

        if (response['status'] == true || response[statusCode] == 200 || response[statusCode] == 201) {
          final dataObj = response['data'];
          if (dataObj is Map && dataObj['pdf_url'] != null && dataObj['pdf_url'].toString().isNotEmpty) {
            generatedPdfUrl = dataObj['pdf_url'].toString();
            return generatedPdfUrl;
          } else if (response['pdf_url'] != null && response['pdf_url'].toString().isNotEmpty) {
            generatedPdfUrl = response['pdf_url'].toString();
            return generatedPdfUrl;
          }
        } else {
          String errMsg = response[messageKey]?.toString() ?? response['message']?.toString() ?? '';
          if (errMsg.isNotEmpty && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: AppText(text: errMsg, txtColor: primaryWhite, size: 12)),
            );
          }
        }
      } catch (e) {
        debugPrint('Error generating final policy pdf: $e');
      }
    }
    return fallbackUrl;
  }

  Future<void> requestPermissions() async {
    try {
      await Permission.notification.request();
      if (Platform.isAndroid) {
        int sdkInt = 0;
        try {
          final deviceInfo = await DeviceInfoPlugin().androidInfo;
          sdkInt = deviceInfo.version.sdkInt;
        } catch (e) {
          debugPrint('Error getting androidInfo: $e');
        }

        if (sdkInt <= 32) {
          await Permission.storage.request();
        } else {
          await Permission.photos.request();
        }
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }

  Future<String> getDownloadDirectoryPath() async {
    if (Platform.isAndroid) {
      try {
        final publicDownloadDir = Directory('/storage/emulated/0/Download');
        if (await publicDownloadDir.exists()) {
          return publicDownloadDir.path;
        }
      } catch (e) {
        debugPrint('Public download dir not directly accessible: $e');
      }

      final extDir = await getExternalStorageDirectory();
      if (extDir != null) {
        return extDir.path;
      }
    }

    final docDir = await getApplicationDocumentsDirectory();
    return docDir.path;
  }

  /// Save / Download Pdf
  Future<void> getPdf(String url) async {
    if (isLoadingSave) return;
    setState(() {
      isLoadingSave = true;
    });

    try {
      final targetUrl = await fetchFinalPdfUrl(url);
      if (targetUrl.isEmpty) {
        if (mounted) {
          setState(() {
            isLoadingSave = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AppText(text: pdfUrlNotFound, txtColor: primaryWhite, size: 12)),
          );
        }
        return;
      }

      await requestPermissions();

      final baseDirPath = await getDownloadDirectoryPath();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      fileName = 'InsurancePolicy_$timestamp.pdf';
      final saveFilePath = '$baseDirPath/$fileName';

      debugPrint('Downloading PDF to $saveFilePath from $targetUrl');

      final dio = Dio();
      await dio.download(
        targetUrl,
        saveFilePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final file = File(saveFilePath);
      if (await file.exists() && await file.length() > 0) {
        debugPrint('File successfully saved: $saveFilePath (${await file.length()} bytes)');
        if (mounted) {
          setState(() {
            isLoadingSave = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                text: '${getTranslated(context, pdfDownloadedSuccessfully)}: $fileName',
                txtColor: primaryWhite,
                size: 12,
              ),
              action: SnackBarAction(
                label: getTranslated(context, share),
                textColor: Colors.amberAccent,
                onPressed: () {
                  Share.shareXFiles([XFile(saveFilePath, mimeType: 'application/pdf', name: fileName)], text: getTranslated(context, widget.screenTitle));
                },
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        throw Exception('Downloaded file is empty or missing');
      }
    } catch (e) {
      debugPrint('Error downloading PDF: $e');
      if (mounted) {
        setState(() {
          isLoadingSave = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AppText(text: downloadFailedPleaseTryAgain, txtColor: primaryWhite, size: 12)),
        );
      }
    }
  }

  /// Share PDF directly
  Future<void> getPdfFile(String pdfPath) async {
    if (isLoadingPrint) return;
    setState(() {
      isLoadingPrint = true;
    });

    try {
      final targetUrl = await fetchFinalPdfUrl(pdfPath);
      if (targetUrl.isEmpty) {
        if (mounted) {
          setState(() {
            isLoadingPrint = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AppText(text: pdfUrlNotFound, txtColor: primaryWhite, size: 12)),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      fileName = 'InsurancePolicy_$timestamp.pdf';
      final tempFilePath = '${tempDir.path}/$fileName';

      debugPrint('Downloading PDF for share to $tempFilePath from $targetUrl');

      final dio = Dio();
      await dio.download(
        targetUrl,
        tempFilePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final file = File(tempFilePath);
      if (await file.exists() && await file.length() > 0) {
        debugPrint('File ready for sharing: $tempFilePath (${await file.length()} bytes)');
        Rect? shareOrigin;
        try {
          final box = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
          if (box != null && box.hasSize) {
            shareOrigin = box.localToGlobal(Offset.zero) & box.size;
          }
        } catch (e) {
          debugPrint('Error calculating share origin: $e');
        }

        await Share.shareXFiles(
          [XFile(tempFilePath, mimeType: 'application/pdf', name: fileName)],
          text: widget.screenTitle.isNotEmpty ? getTranslated(context, widget.screenTitle) : getTranslated(context, policyDocument),
          sharePositionOrigin: shareOrigin,
        );
      } else {
        throw Exception('File was not downloaded properly for sharing');
      }
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: AppText(text: failedToSharePdfPleaseTryAgain, txtColor: primaryWhite, size: 12)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingPrint = false;
        });
      }
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _port.close();
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
                      key: _shareButtonKey,
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
