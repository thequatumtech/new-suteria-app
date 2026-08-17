import 'package:flutter/material.dart';
import 'package:soperia_user/app_utils/app_text.dart';
import 'package:soperia_user/app_utils/color_constrint.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String url;
  final String title;

  const PrivacyPolicyScreen({super.key, required this.url, required this.title});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController controller;
  int _loadingProgress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _isLoading = true;
    _hasError = false;
    _loadingProgress = 0;

    controller = WebViewController()
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
            // Remove website preloader, header, and footer to optimize WebView performance and appearance
            controller.runJavaScript('''
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
            // Only trigger error screen for main frame failure, not minor asset warnings
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
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: widget.title, size: 18, fontWeight: FontWeight.bold),
        bottom: _loadingProgress < 100 && !_hasError
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(
                  value: _loadingProgress / 100.0,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(deepBluedark),
                  minHeight: 3.0,
                ),
              )
            : null,
      ),
      body: Stack(
        children: [
          if (!_hasError)
            RefreshIndicator(
              color: deepBluedark,
              onRefresh: () async {
                await controller.reload();
              },
              child: WebViewWidget(controller: controller),
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
                      text: 'Please check your internet connection and try again.',
                      size: 13,
                      txtColor: primaryGrayShade,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                          _loadingProgress = 0;
                        });
                        controller.loadRequest(Uri.parse(widget.url));
                      },
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