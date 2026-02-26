import 'package:flutter/material.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const InAppWebViewPage({super.key, required this.url, required this.title});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = WebViewController();
    super.initState();
    Future.microtask(() async {
      final controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(AppColors.backgroundColor24)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (url) => setState(() => _isLoading = true),
                onPageFinished: (url) => setState(() => _isLoading = false),
                onNavigationRequest: (request) => NavigationDecision.navigate,
              ),
            )
            ..loadRequest(Uri.parse(widget.url));

      setState(() => _controller = controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor24,
      appBar: CustomAppBar(title: widget.title, enableBack: true),
      body: Stack(
        children: [
          if (_controller == null)
            const Center(child: CircularProgressIndicator())
          else
            WebViewWidget(controller: _controller!),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
