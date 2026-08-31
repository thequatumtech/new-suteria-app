import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soperia_user/Screens/Profile/My%20Policies/get_policy_details_model.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/app_utils/common_date_formate.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:soperia_user/app_utils/app_button.dart';
import 'package:soperia_user/app_utils/app_string.dart';
import 'package:soperia_user/app_utils/policy_renewal_helper.dart';

class PolicyDetailsScreen extends StatefulWidget {
  final PolicyData policyData;

  const PolicyDetailsScreen({super.key, required this.policyData});

  @override
  State<PolicyDetailsScreen> createState() => _PolicyDetailsScreenState();
}

class _PolicyDetailsScreenState extends State<PolicyDetailsScreen> {
  Key pdfKey = UniqueKey();
  bool useWebView = false;
  WebViewController? webViewController;
  bool isSharing = false;

  @override
  void initState() {
    super.initState();
    String pdfUrl = widget.policyData.pdfUrl ?? '';
    if (pdfUrl.isNotEmpty) {
      _initWebViewController(pdfUrl);
    }
  }

  void _initWebViewController(String pdfUrl) {
    String googleDocsUrl = "https://docs.google.com/gview?embedded=true&url=$pdfUrl";
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(googleDocsUrl));
  }

  void _reloadPdf() {
    setState(() {
      pdfKey = UniqueKey();
      if (useWebView && webViewController != null) {
        String pdfUrl = widget.policyData.pdfUrl ?? '';
        _initWebViewController(pdfUrl);
      }
    });
  }

  Future<void> _sharePdf(String pdfUrl) async {
    if (isSharing) return;
    setState(() {
      isSharing = true;
    });

    try {
      if (pdfUrl.isEmpty) return;
      final tempDir = await getTemporaryDirectory();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFilePath = '${tempDir.path}/policy_${widget.policyData.policyNo ?? timestamp}.pdf';

      final dio = Dio();
      await dio.download(
        pdfUrl,
        tempFilePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final file = File(tempFilePath);
      if (await file.exists() && await file.length() > 0) {
        await Share.shareXFiles(
          [XFile(tempFilePath, mimeType: 'application/pdf')],
          text: widget.policyData.policyType ?? getTranslated(context, 'Policy Document'),
        );
      } else {
        await Share.share(pdfUrl, subject: widget.policyData.policyType ?? getTranslated(context, 'Policy Document'));
      }
    } catch (e) {
      debugPrint('Error downloading PDF for sharing: $e');
      await Share.share(pdfUrl, subject: widget.policyData.policyType ?? getTranslated(context, 'Policy Document'));
    } finally {
      if (mounted) {
        setState(() {
          isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String pdfUrl = widget.policyData.pdfUrl ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.keyboard_backspace_outlined),
        ),
        title: AppText(
          text: widget.policyData.policyType ?? 'Policy Details',
          size: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Details Card
                Container(
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGray.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: deepBluedark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            AppText(
                              text: '${getTranslated(context, 'Policy No:')} ${widget.policyData.policyNo ?? ''}',
                              txtColor: primaryWhite,
                              size: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (widget.policyData.paymentStatus == 1) ? Colors.green : Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AppText(
                                text: (widget.policyData.paymentStatus == 1) ? 'Paid' : 'Pending',
                                txtColor: primaryWhite,
                                size: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Detail items
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildDetailRow('Policy Type', widget.policyData.policyType ?? '-'),
                            const SizedBox(height: 10),
                            _buildDetailRow('Plan Name', widget.policyData.planName ?? '-'),
                            const SizedBox(height: 10),
                            _buildDetailRow('Company', widget.policyData.companyName ?? '-'),
                            const SizedBox(height: 10),
                            _buildDetailRow('Plan Limit', widget.policyData.policyPlanLimit != null ? '${widget.policyData.policyPlanLimit} ${getTranslated(context, 'JOD')}' : '-'),
                            const SizedBox(height: 10),
                            _buildDetailRow('Gross Premium', widget.policyData.grossPremium != null ? '${widget.policyData.grossPremium} ${getTranslated(context, 'JOD')}' : '-'),
                            const SizedBox(height: 10),
                            _buildDetailRow('Inception Date', widget.policyData.inceptionDate != null ? commonDateFormat(widget.policyData.inceptionDate!) : '-'),
                            const SizedBox(height: 10),
                            _buildDetailRow('Expiry Date', widget.policyData.expiryDate != null ? commonDateFormat(widget.policyData.expiryDate!) : '-'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // PDF Header with Reload & Share buttons
                Row(
                  children: [
                    AppText(
                      text: 'Policy Document',
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),
                    if (pdfUrl.isNotEmpty) ...[
                      IconButton(
                        icon: const Icon(Icons.refresh, color: primaryBlack),
                        tooltip: 'Reload',
                        onPressed: _reloadPdf,
                      ),
                      isSharing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.share_outlined, color: primaryBlack),
                              tooltip: 'Share',
                              onPressed: () {
                                _sharePdf(pdfUrl);
                              },
                            ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                // PDF Viewer / WebView Box
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: skyBlueShade2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: pdfUrl.isEmpty
                        ? Center(
                            child: AppText(
                              text: 'PDF document not available',
                              size: 14,
                              txtColor: primaryGrayShade,
                            ),
                          )
                        : useWebView
                            ? (webViewController != null
                                ? WebViewWidget(controller: webViewController!)
                                : const Center(child: CircularProgressIndicator()))
                            : SfPdfViewer.network(
                                pdfUrl,
                                key: pdfKey,
                                canShowScrollHead: true,
                                canShowScrollStatus: true,
                                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                                  setState(() {
                                    useWebView = true;
                                  });
                                },
                              ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppBtnWithColorShades(
                    textSize: 14,
                    paddingSize: 12,
                    onTap: () {
                      renewPolicy(context, widget.policyData);
                    },
                    btnTxt: renew,
                    color1: darkBlue2,
                    color2: darkBlue1,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: AppText(
            text: label,
            size: 14,
            fontWeight: FontWeight.w500,
            txtColor: primaryGrayShade,
          ),
        ),
        Expanded(
          flex: 6,
          child: AppText(
            text: value,
            size: 14,
            fontWeight: FontWeight.w600,
            txtAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
