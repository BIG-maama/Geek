import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';

class CustomIOSDropdown extends StatefulWidget {
  final List<Supplier> suppliers;
  final Function(int) onSelected;
  final Supplier? selectedSupplier;

  const CustomIOSDropdown({
    Key? key,
    required this.suppliers,
    required this.onSelected,
    this.selectedSupplier,
  }) : super(key: key);

  @override
  _CustomIOSDropdownState createState() => _CustomIOSDropdownState();
}

class _CustomIOSDropdownState extends State<CustomIOSDropdown>
    with SingleTickerProviderStateMixin {
  late Supplier selectedValue;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    selectedValue =
        widget.selectedSupplier ??
        (widget.suppliers.isNotEmpty
            ? widget.suppliers[0]
            : Supplier(
              id: 0,
              companyName: 'لا يوجد مورد',
              contactPersonName: '',
              phone: '',
              email: '',
              isActive: 0,
              unpaidPurchases: 0,
              // address: '',
              // payment_method: '',
              // credit_limit: 0,
              // date: '',
              // status: false,
            ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelected(selectedValue.id);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showPicker() {
    _animationController.forward(from: 0);

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              height: 260,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'اختر من القائمة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      backgroundColor: Colors.transparent,
                      itemExtent: 40,
                      scrollController: FixedExtentScrollController(
                        initialItem: widget.suppliers.indexOf(selectedValue),
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedValue = widget.suppliers[index];
                        });
                      },
                      children:
                          widget.suppliers
                              .map(
                                (option) => Center(
                                  child: Text(
                                    option.companyName,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  CupertinoButton(
                    child: const Text(
                      "تم",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // تأكد أولاً من تعيين القيمة بشكل صحيح
                      setState(() {
                        // هذا التحديث يضمن أن قيمة العرض تتغير قبل الإغلاق
                        selectedValue = selectedValue;
                      });

                      // أرسل القيمة للخارج
                      widget.onSelected(selectedValue.id);

                      // أغلق النافذة
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedSupplier != null &&
        widget.selectedSupplier!.id != selectedValue.id) {
      selectedValue = widget.selectedSupplier!;
    }
    return GestureDetector(
      onTap: _showPicker,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CupertinoColors.systemGrey4, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue.companyName,
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.black,
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}
