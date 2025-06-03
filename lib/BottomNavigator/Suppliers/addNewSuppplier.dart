import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pro/BottomNavigator/Suppliers/Suppliers.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';
import 'package:pro/widget/Global.dart';
import 'package:pro/widget/custom_text.dart';

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({Key? key}) : super(key: key);

  @override
  State<AddSupplierPage> createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> EnterNewSupplier() async {
    try {
      final response = await Dio().post(
        "$baseUrl/api/suppliers",
        data: {
          "company_name": companyNameController.text,
          "contact_person_name": contactPersonController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "address": addressController.text,
        },
      );

      final supplier = SupplierProfile.fromJson(response.data['supplier']);
      // print("Supplier object: ${supplier.toString()}");
      final box = Hive.box<SupplierProfile>('suppliers');
      // print("Will store to Hive: ${supplier.toString()}");
      await box.add(supplier);
      //print("Stored successfully! Hive box length: ${box.length}");

      FancySnackbar.show(
        context,
        "success",
        backgroundColor: const Color.fromARGB(255, 5, 15, 5),
        textColor: Colors.white,
      );
      Navigator.pop(context, supplier);
    } catch (e) {
      AnimatedSnackBar.material(
        'failed operation!',
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 1),
      ).show(context);
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("إضافة مورد")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: "اسم الشركة",
                controller: companyNameController,
                placeholder: "ادخل اسم الشركة",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "اسم الشخص المسؤول",
                controller: contactPersonController,
                placeholder: "ادخل اسم الشخص المسؤول",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "رقم الهاتف",
                controller: phoneController,
                placeholder: "9621234567",
                keyboardType: TextInputType.phone,
                prefixText: "+",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "البريد الإلكتروني",
                controller: emailController,
                placeholder: "example@email.com",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "العنوان",
                controller: addressController,
                placeholder: "ادخل العنوان",
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: EnterNewSupplier,
                icon: const Icon(Icons.save),
                label: const Text("حفظ المورد"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
