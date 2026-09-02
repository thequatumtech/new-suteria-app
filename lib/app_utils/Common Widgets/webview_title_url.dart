import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/api_set_up/api_call.dart';
import 'package:soperia_user/app_utils/api_set_up/api_urls.dart';
import 'package:soperia_user/app_utils/api_set_up/header_file.dart';
import 'package:soperia_user/app_utils/api_set_up/service_locator.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:soperia_user/language/language_constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final int? id;
  final String? url;
  final String title;

  const PrivacyPolicyScreen({
    super.key,
    this.id,
    this.url,
    required this.title,
  });

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  WebViewController? _webViewController;
  int _loadingProgress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  String _resolvedFileUrl = '';
  bool _isPdf = false;

  final ApiCall _apiCall = ApiCall(dioClient: getIt.get<ApiCall>().dioClient);

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      _loadingProgress = 0;
    });

    if (widget.id != null) {
      try {
        Map<String, String> header = await getHeader();
        Map<String, dynamic> response = await _apiCall.getRequest(
          context: context,
          endpoint: '$getTermsAndConditions${widget.id}',
          options: Options(headers: header),
        );

        if (response['success'] == true && response['data'] != null) {
          Map<String, dynamic> data = response['data'] is Map ? response['data'] : {};
          String file = data['file']?.toString() ?? '';
          String msg = data['message']?.toString() ?? '';

          _resolvedFileUrl = file;

          if (file.isNotEmpty) {
            String lower = file.toLowerCase();
            if (lower.endsWith('.pdf')) {
              setState(() {
                _isPdf = true;
                _isLoading = false;
              });
              return;
            } else if (lower.endsWith('.docx') || lower.endsWith('.doc')) {
              _isPdf = false;
              String docViewerUrl = 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(file)}';
              _initWebViewController(docViewerUrl);
              return;
            } else {
              _isPdf = false;
              _initWebViewController(file);
              return;
            }
          } else if (msg.isNotEmpty) {
            _isPdf = false;
            _initHtmlController(msg);
            return;
          }
        }

        // If API data empty, try fallback url if present
        if (widget.url != null && widget.url!.isNotEmpty) {
          _resolvedFileUrl = widget.url!;
          if (widget.url!.toLowerCase().endsWith('.pdf')) {
            setState(() {
              _isPdf = true;
              _isLoading = false;
            });
            return;
          }
          _isPdf = false;
          _initWebViewController(widget.url!);
          return;
        }

        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = response['message']?.toString() ?? 'No content found';
        });
      } catch (e) {
        if (widget.url != null && widget.url!.isNotEmpty) {
          _resolvedFileUrl = widget.url!;
          _isPdf = false;
          _initWebViewController(widget.url!);
        } else {
          setState(() {
            _hasError = true;
            _isLoading = false;
            _errorMessage = e.toString();
          });
        }
      }
    } else if (widget.url != null && widget.url!.isNotEmpty) {
      _resolvedFileUrl = widget.url!;
      if (widget.url!.toLowerCase().endsWith('.pdf')) {
        setState(() {
          _isPdf = true;
          _isLoading = false;
        });
        return;
      }
      _isPdf = false;
      _initWebViewController(widget.url!);
    } else {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = 'No URL or ID provided';
      });
    }
  }

  void _initWebViewController(String targetUrl) {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
                if (progress >= 70 && _isLoading) {
                  _isLoading = false;
                }
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _loadingProgress = 100;
              });
            }
            _webViewController?.runJavaScript('''
              (function() {
                var preloader = document.getElementById('preloader');
                if (preloader) preloader.style.display = 'none';
                var header = document.querySelector('header');
                if (header) header.style.display = 'none';
                var topBar = document.querySelector('.top-bar');
                if (topBar) topBar.style.display = 'none';
                var footer = document.querySelector('footer');
                if (footer) footer.style.display = 'none';
                var copyright = document.querySelector('.copyrights');
                if (copyright) copyright.style.display = 'none';
              })();
            ''').catchError((_) {});
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Web resource error: ${error.description} (${error.errorCode})");
            if (error.isForMainFrame == true && mounted) {
              setState(() {
                _hasError = true;
                _isLoading = false;
                _errorMessage = error.description;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));
    setState(() {});
  }

  void _initHtmlController(String htmlContent) {
    String formattedHtml = """
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            padding: 16px;
            color: #333333;
            line-height: 1.6;
            font-size: 15px;
          }
          img { max-width: 100%; height: auto; }
        </style>
      </head>
      <body>
        $htmlContent
      </body>
      </html>
    """;

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadHtmlString(formattedHtml);

    setState(() {
      _isLoading = false;
      _loadingProgress = 100;
    });
  }

  Future<void> _openExternal() async {
    if (_resolvedFileUrl.isNotEmpty) {
      Uri uri = Uri.parse(_resolvedFileUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: widget.title, size: 18, fontWeight: FontWeight.bold),
        actions: [
          if (_resolvedFileUrl.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_browser_rounded),
              tooltip: getTranslated(context, 'Open in browser'),
              onPressed: _openExternal,
            ),
        ],
        bottom: (_loadingProgress < 100 && !_hasError && _isLoading)
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(
                  value: _loadingProgress > 0 ? _loadingProgress / 100.0 : null,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(deepBluedark),
                  minHeight: 3.0,
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          if (!_hasError && !_isLoading)
            if (_isPdf && _resolvedFileUrl.isNotEmpty)
              SfPdfViewer.network(
                _resolvedFileUrl,
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                  if (mounted) {
                    setState(() {
                      _hasError = true;
                      _errorMessage = details.description;
                    });
                  }
                },
              )
            else if (_webViewController != null)
              RefreshIndicator(
                color: deepBluedark,
                onRefresh: () async {
                  await _webViewController?.reload();
                },
                child: WebViewWidget(controller: _webViewController!),
              ),
          if (_isLoading && !_hasError)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: deepBluedark),
                    const SizedBox(height: 16),
                    AppText(
                      text: 'Loading ${widget.title}...',
                      size: 14,
                      txtColor: primaryGrayShade,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          if (_hasError)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 54, color: primaryGrayShade),
                    const SizedBox(height: 14),
                    AppText(
                      text: 'Unable to load page',
                      size: 16,
                      fontWeight: FontWeight.bold,
                      txtColor: primaryBlack,
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      text: _errorMessage.isNotEmpty ? _errorMessage : 'Please check your internet connection and try again.',
                      size: 13,
                      txtColor: primaryGrayShade,
                      txtAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _loadContent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepBluedark,
                        foregroundColor: primaryWhite,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: AppText(text: 'Retry', size: 14, txtColor: primaryWhite, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}