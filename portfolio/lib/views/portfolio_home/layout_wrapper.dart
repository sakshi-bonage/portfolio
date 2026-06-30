import 'package:flutter/material.dart';
import '../../widgets/responsivelayout.dart';
import 'screen_variants/mobile_viewport.dart';
import 'screen_variants/web_viewport.dart';


class LayoutWrapper extends StatelessWidget {
  const LayoutWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: MobileViewport(),
      desktop: WebViewport(),
    );
  }
}