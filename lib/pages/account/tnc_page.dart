import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../a_widgets/text_widget.dart';

class TnCpage extends StatelessWidget {
  const TnCpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextW('')),
      body: SfPdfViewer.asset("assets/docs/au_about.pdf"),
    );
  }
}
