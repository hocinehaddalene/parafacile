import 'package:flutter/material.dart';
import 'package:flutter_file_view/flutter_file_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdfviewer extends StatefulWidget {
  pdfviewer({required this.url});
  String? url;

  @override
  State<pdfviewer> createState() => _pdfviewerState();
}

class _pdfviewerState extends State<pdfviewer> {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();


  void initState() {
    FlutterFileView.init();
    print("${widget.url!}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        body: 
    FileView(
      controller: FileViewController.network(widget.url!),
      )
      ),
    );
  }
}





  // SfPdfViewer.network(
  //      widget.url!,
  //       key: _pdfViewerKey,
  //   ) 