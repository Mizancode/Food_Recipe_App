import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class WebDetail extends StatefulWidget{
  final RecipeUrl;
  WebDetail(this.RecipeUrl);

  @override
  State<WebDetail> createState() => _WebDetailState();
}
class _WebDetailState extends State<WebDetail> {
  late String Url;
  @override
  void initState() {
    if(widget.RecipeUrl.toString().contains('http://')){
      Url=widget.RecipeUrl.toString().replaceAll('http://', 'https://');
    }else{
      Url=widget.RecipeUrl;
    }
    super.initState();
  }
  double _progress=0;
  late InAppWebViewController inAppWebViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        var isLastPage=await inAppWebViewController.canGoBack();
        if(isLastPage){
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('WebView Detail Page'),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(Url),
                  ),
                  onWebViewCreated: (InAppWebViewController controller){
                    inAppWebViewController=controller;
                  },
                  onProgressChanged: (InAppWebViewController controller,int progress){
                    setState(() {
                      _progress=progress/100;
                    });
                  },
                ),
                _progress<1? Container(
                  child: LinearProgressIndicator(
                    value: _progress,
                  ),
                ):SizedBox()
              ],
            )
        ),
      ),
    );
  }
}