import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/widget/Global.dart';
import 'package:path/path.dart';

class AddMedicineModern extends StatefulWidget {
  const AddMedicineModern({super.key});

  @override
  State<AddMedicineModern> createState() => _AddMedicineModernState();
}

class _AddMedicineModernState extends State<AddMedicineModern> {
  final medicineName = TextEditingController();
  final arabicName = TextEditingController();
  final barcode = TextEditingController();
  final type = TextEditingController();
  final categoryId = TextEditingController();
  final quantity = TextEditingController();
  final alertQuantity = TextEditingController();
  final peoplePrice = TextEditingController();
  final supplierPrice = TextEditingController();
  final taxRate = TextEditingController();
  final medicineform = TextEditingController();

  List<File> selectedFiles = [];
  bool isLoading = false;
  List<dynamic> medicineForms = [];
  List<dynamic> medicineBrands = [];
  List<dynamic> medicinecategory = [];
  Map<String, dynamic>? selectedBrand;
  Map<String, dynamic>? selectedCategory;
  Map<String, dynamic>? selectedForm;
  Future<void> category() async {
    try {
      final response = await Dio().get('$baseUrl/api/medicines/categories');
      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          medicinecategory = responseData['data'];
          selectedCategory =
              medicinecategory.isNotEmpty ? medicinecategory.first : null;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchBrandBrand() async {
    try {
      final response = await Dio().get("$baseUrl/api/brands");

      if (response.statusCode == 200) {
        final responsedata = response.data;
        setState(() {
          medicineBrands = responsedata['data'];
          selectedBrand =
              medicineBrands.isNotEmpty
                  ? medicineBrands.first
                  : null; // اختيار أول عنصر كبداية
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchMedicineForms() async {
    try {
      final response = await Dio().get("$baseUrl/api/medicine-forms");
      if (response.statusCode == 200) {
        setState(() {
          medicineForms = response.data['data'];
        });
      }
    } catch (e) {
      print("فشل في جلب الأشكال الدوائية: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMedicineForms();
    fetchBrandBrand();
    category();
  }

  Future<String?> generateCode() async {
    setState(() => isLoading = true);
    try {
      final response = await Dio().get("$baseUrl/api/generaite-barcode");
      if (response.statusCode == 200 || response.data['status'] == true) {
        final code =
            response.data['bar_code'].toString(); // تأكد من أنها String
        return code;
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
    return null;
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  Future<void> sendMedicine(BuildContext context) async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry("medicine_name", medicineName.text),
      MapEntry("arabic_name", arabicName.text),
      MapEntry("bar_code", barcode.text),
      MapEntry("type", type.text),
      MapEntry("category_id", selectedCategory?['id'].toString() ?? ''),
      MapEntry("quantity", quantity.text),
      MapEntry("alert_quantity", alertQuantity.text),
      MapEntry("people_price", peoplePrice.text),
      MapEntry("supplier_price", supplierPrice.text),
      MapEntry("tax_rate", taxRate.text),
      MapEntry("expiry_date", medicineform.text),
      MapEntry("medicine_form_id", selectedForm?['id'].toString() ?? ''),
      MapEntry("brand_id", selectedBrand?['id'].toString() ?? ''),
    ]);

    for (File file in selectedFiles) {
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: basename(file.path),
      );
      formData.files.add(MapEntry("attachments[]", multipartFile));
    }

    try {
      final response = await Dio().post(
        "$baseUrl/api/medicines",
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final medic = MedicInfo.fromJson(response.data);
        final box = Hive.box<MedicInfo>('medics');
        await box.add(medic);
        print(response.data);
        BotToast.showText(text: response.data['message']);
        Navigator.pop(context);
      }
    } catch (e) {
      FancySnackbar.show(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("إضافة دواء", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00B4DB), Colors.black54],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _glassCard(
                title: "معلومات الدواء",
                children: [
                  _buildField(
                    medicineName,
                    "اسم الدواء (بالإنجليزية)",
                    TextInputType.text,
                  ),
                  _buildField(arabicName, "الاسم بالعربية", TextInputType.text),
                  IOSBarcodeField.fieldWithGenerateButton(
                    controller: barcode,
                    onGenerate: () async {
                      final code = await generateCode();
                      if (code != null) {
                        barcode.text = code;
                      }
                    },
                  ),
                  _buildTypeDropdown(type),
                  _buildCategoryDropdown(),
                ],
              ),
              const SizedBox(height: 20),
              _glassCard(
                title: "الكمية والأسعار",
                children: [
                  _buildField(quantity, "الكمية", TextInputType.number),
                  _buildField(
                    alertQuantity,
                    "كمية التنبيه",
                    TextInputType.number,
                  ),
                  _buildField(peoplePrice, "سعر البيع", TextInputType.number),
                  _buildField(
                    supplierPrice,
                    "سعر المورد",
                    TextInputType.number,
                  ),
                  _buildField(taxRate, "نسبة الضريبة", TextInputType.number),
                ],
              ),

              const SizedBox(height: 20),
              _glassCard(
                title: "Brand and Shape",
                children: [
                  Text(
                    "اختر  البراند",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedBrand,
                    isExpanded: true,
                    dropdownColor: Colors.black87,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items:
                        medicineBrands
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (form) => DropdownMenuItem(
                                value: form,
                                child: Text(
                                  form['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBrand = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "اختر الشكل الدوائي",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedForm,
                    isExpanded: true,
                    dropdownColor: Colors.black87,
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items:
                        medicineForms
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (form) => DropdownMenuItem(
                                value: form,
                                child: Text(
                                  form['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedForm = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _glassCard(
                title: "المرفقات",
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await pickFiles();
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text("اختر ملفات"),
                  ),
                  const SizedBox(height: 10),
                  if (selectedFiles.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          selectedFiles.map((file) {
                            final isImage =
                                file.path.endsWith(".jpg") ||
                                file.path.endsWith(".png");
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white38),
                              ),
                              child:
                                  isImage
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : const Center(
                                        child: Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                            );
                          }).toList(),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await sendMedicine(context);
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "إرسال الدواء",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _glassCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Color.fromARGB(213, 255, 255, 255),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white30),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(TextEditingController typeController) {
    final List<String> types = ['unit', 'package'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: typeController.text.isNotEmpty ? typeController.text : null,
        isExpanded: true, // 💡 توسع القائمة على كامل العرض
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.black87,
        iconEnabledColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          hintText: 'اختر النوع',
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            types.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
        onChanged: (value) {
          if (value != null) {
            typeController.text = value;
          }
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<Map<String, dynamic>>(
        value: selectedCategory,
        isExpanded: true,
        dropdownColor: Colors.black87,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          hintText: 'اختر الفئة',
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            medicinecategory
                .map<DropdownMenuItem<Map<String, dynamic>>>(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(
                      category['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });
        },
      ),
    );
  }
}
