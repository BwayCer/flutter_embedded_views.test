import 'dart:js_interop';
import 'dart:js_interop_unsafe' as js_interop_unsafe;
import 'dart:ui' show FlutterView;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

void main() {
  runWidget(
    MultiViewApp(
      viewBuilder: (BuildContext context) {
        final int viewId = View.of(context).viewId;

        String greeting = 'Hello from Flutter!';
        if (viewId != 0) {
          final initialData = ui_web.views.getInitialData(viewId) as JSObject;
          if (initialData.has('greeting')) {
            greeting = initialData.getProperty('greeting'.toJS);
          }
        }

        return MainApp(viewId, greeting);
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp(this.viewId, this.greeting, {super.key});

  final int viewId;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: viewId % 2 == 0 ? Colors.blue[50] : Colors.green[50],
        body: Center(
          child: Text(
            '$greeting (viewId=$viewId)',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

/// from: https://docs.flutter.dev/platform-integration/web/embedding-flutter-web#embedded-mode
///
/// Calls [viewBuilder] for every view added to the app to obtain the widget to
/// render into that view. The current view can be looked up with [View.of].
class MultiViewApp extends StatefulWidget {
  const MultiViewApp({super.key, required this.viewBuilder});

  final WidgetBuilder viewBuilder;

  @override
  State<MultiViewApp> createState() => _MultiViewAppState();
}

class _MultiViewAppState extends State<MultiViewApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void didUpdateWidget(MultiViewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Need to re-evaluate the viewBuilder callback for all views.
    _views.clear();
    _updateViews();
  }

  @override
  void didChangeMetrics() {
    _updateViews();
  }

  Map<Object, Widget> _views = <Object, Widget>{};

  void _updateViews() {
    final Map<Object, Widget> newViews = <Object, Widget>{};
    for (final FlutterView view
        in WidgetsBinding.instance.platformDispatcher.views) {
      final Widget viewWidget = _views[view.viewId] ?? _createViewWidget(view);
      newViews[view.viewId] = viewWidget;
    }
    setState(() {
      _views = newViews;
    });
  }

  Widget _createViewWidget(FlutterView view) {
    return View(view: view, child: Builder(builder: widget.viewBuilder));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}
