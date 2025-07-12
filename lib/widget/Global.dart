import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> viewUserDetails = [];
List<Map<String, dynamic>> createUser = [];
List<Map<String, dynamic>> showAllUsers = [];
List<Map<String, dynamic>> globalRoles = [];
const String baseUrl = "http://192.168.1.11:8000";

class AlertHelper {
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String cancelText = "cancel",
    String confirmText = "delete",
    Color confirmColor = Colors.red,
  }) {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(message),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(cancelText),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog first
                  onConfirm(); // Then execute callback
                },
                child: Text(confirmText, style: TextStyle(color: confirmColor)),
              ),
            ],
          ),
    );
  }
}

class CustomNavigator {
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget page, {
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => page,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page, {
    TO? result,
  }) {
    return Navigator.of(
      context,
    ).pushReplacement(CupertinoPageRoute(builder: (_) => page), result: result);
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    Widget page, {
    RoutePredicate? predicate,
  }) {
    return Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }
}

class AnimatedCupertinoLoader extends StatelessWidget {
  final String message;
  const AnimatedCupertinoLoader({this.message = "الرجاء الانتظار..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoActivityIndicator(radius: 16),
          SizedBox(height: 12),
          Text(message, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class iOSRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const iOSRefreshWrapper({required this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: onRefresh),
        SliverToBoxAdapter(child: child),
      ],
    );
  }
}

class CupertinoSettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const CupertinoSettingsGroup({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      header: title != null ? Text(title!) : null,
      children: children,
    );
  }
}

class CupertinoInfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const CupertinoInfoBanner({
    required this.message,
    this.icon = CupertinoIcons.info,
    this.color = CupertinoColors.activeBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(color: color))),
        ],
      ),
    );
  }
}

class CustomCupertinoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CustomCupertinoCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color:
            isDark
                ? CupertinoColors.systemGrey.withOpacity(0.2)
                : CupertinoColors.systemGrey6.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class IOSButtons {
  // زر ممتلئ بلون أزرق
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      color: CupertinoColors.activeBlue,
      child: Text(text),
      onPressed: onPressed,
    );
  }

  // زر ممتلئ بلون رمادي
  static Widget filledGray({
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = const Color(0xFFB0B0B0), // لون رمادي افتراضي
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // زر شفاف
  static Widget flatButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(child: Text(text), onPressed: onPressed);
  }

  // زر مع أيقونة + نص
  static Widget iconButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    Color color = CupertinoColors.systemGrey,
    Color textColor = CupertinoColors.white,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: textColor)),
        ],
      ),
      onPressed: onPressed,
    );
  }

  // زر بحواف دائرية بشكل كامل
  static Widget roundedButton({
    required String text,
    required VoidCallback onPressed,
    Color color = CupertinoColors.activeGreen,
  }) {
    return CupertinoButton(
      borderRadius: BorderRadius.circular(30),
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(text),
      onPressed: onPressed,
    );
  }

  // زر مع Loader أثناء التحميل
  static Widget loadingButton({
    required bool isLoading,
    required String text,
    required VoidCallback onPressed,
    Color color = CupertinoColors.activeBlue,
  }) {
    return CupertinoButton(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const CupertinoActivityIndicator()
              : Text(
                text,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                ),
              ),
    );
  }

  // زر iOS مع تحميل أو تعطيل
  static Widget loadingOrDisabledButton({
    required bool isLoading,
    required bool isEnabled,
    required String text,
    required VoidCallback onPressed,
    Color activeColor = CupertinoColors.activeBlue,
    Color disabledColor = CupertinoColors.inactiveGray,
  }) {
    final color = isEnabled ? activeColor : disabledColor;

    return CupertinoButton(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      onPressed: (!isEnabled || isLoading) ? null : onPressed,
      child:
          isLoading
              ? const CupertinoActivityIndicator()
              : Text(
                text,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                ),
              ),
    );
  }
}

class IOSBarcodeField {
  static Widget fieldWithGenerateButton({
    required TextEditingController controller,
    required VoidCallback? onGenerate,
    bool loading = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: controller,
            placeholder: "الباركود",
            keyboardType: TextInputType.number,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CupertinoColors.systemGrey4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.circular(10),
          onPressed: loading ? null : onGenerate,
          child:
              loading
                  ? const CupertinoActivityIndicator()
                  : const Icon(CupertinoIcons.barcode_viewfinder),
        ),
      ],
    );
  }
}

class AnimatedPopupMenu extends StatefulWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const AnimatedPopupMenu({Key? key, this.onDelete, this.onEdit})
    : super(key: key);

  @override
  _AnimatedPopupMenuState createState() => _AnimatedPopupMenuState();
}

class _AnimatedPopupMenuState extends State<AnimatedPopupMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
    } else {
      _controller.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder:
          (context) => Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent, //
              onTap: _toggleMenu, //
              child: Stack(
                children: [
                  CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: const Offset(-100, 30),
                    child: Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildItem("✏️ اضافة بديل", widget.onEdit),
                              _buildItem("🗑️ حذف", widget.onDelete),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildItem(String title, VoidCallback? callback) {
    return InkWell(
      onTap: () {
        callback?.call();
        _toggleMenu();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(title),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: const Icon(Icons.more_vert),
      ),
    );
  }
}

class CupertinoExpansionTileAnimated extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final List<Widget> children;

  const CupertinoExpansionTileAnimated({
    super.key,
    required this.leading,
    required this.title,
    required this.children,
  });

  @override
  State<CupertinoExpansionTileAnimated> createState() =>
      _CupertinoExpansionTileAnimatedState();
}

class _CupertinoExpansionTileAnimatedState
    extends State<CupertinoExpansionTileAnimated> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                widget.leading,
                const SizedBox(width: 12),
                Expanded(child: widget.title),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    CupertinoIcons.chevron_down,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children:
                widget.children
                    .map(
                      (child) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: child,
                      ),
                    )
                    .toList(),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
