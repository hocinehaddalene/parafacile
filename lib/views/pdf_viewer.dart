import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfviewer extends StatefulWidget {
  pdfviewer({required this.url});
  String? url;

  @override
  State<pdfviewer> createState() => _pdfviewerState();
}

class _pdfviewerState extends State<pdfviewer> {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(
       widget.url!,
        key: _pdfViewerKey,
    ) 
    );
  }
}