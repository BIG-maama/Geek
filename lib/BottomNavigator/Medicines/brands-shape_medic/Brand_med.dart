import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pro/widget/Global.dart';

class BrandsPage extends StatefulWidget {
  @override
  _BrandsPageState createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Map<int, Offset> _slideOffsets = {};
  List<dynamic> _brands = [];
  bool _isLoading = false;
  List<dynamic> _trash = [];
  bool _showTrash = false;

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> deleteBrandPermanently(int id) async {
    try {
      final response = await Dio().delete("$baseUrl/api/brands/$id");

      if (response.statusCode == 200 && response.data['status'] == true) {
        Fluttertoast.showToast(
          msg: "تم الحذف نهائيًا بنجاح",
          backgroundColor: CupertinoColors.systemRed,
        );
      } else {
        Fluttertoast.showToast(
          msg: "فشل الحذف النهائي",
          backgroundColor: CupertinoColors.destructiveRed,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "خطأ أثناء الحذف",
        backgroundColor: CupertinoColors.destructiveRed,
      );
    }
  }

  Future<void> fetchBrands() async {
    setState(() => _isLoading = true);
    try {
      final response = await Dio().get("$baseUrl/api/brands");

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == true && responseData['data'] != null) {
          setState(() {
            _brands = responseData['data'];
          });
        } else {
          showError('الاستجابة غير متوقعة من الخادم');
        }
        print("failed 1 ");
      } else {
        print("failde 2");
        showError('فشل تحميل البيانات - كود: ${response.statusCode}');
      }
    } catch (e) {
      showError('خطأ في الاتصال بالخادم: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> addBrand() async {
    final name = _nameController.text;
    final companyName = _companyNameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty || companyName.isEmpty || description.isEmpty) {
      showError('الاسم واسم الشركة و الوصف مطلوب');
      return;
    }

    try {
      final response = await Dio().post(
        "$baseUrl/api/brands",
        data: {
          "name": name,
          "company_name": companyName,
          "description": description,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        _nameController.clear();
        _companyNameController.clear();
        _descriptionController.clear();
        await fetchBrands();
        showSuccess('تمت إضافة الماركة بنجاح');
      } else {
        showError('فشل في الإضافة');
      }
    } catch (e) {
      showError('خطأ في الإرسال');
    }
  }

  void showError(String msg) {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text('خطأ'),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                child: Text('حسنًا'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void showSuccess(String msg) {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text('تم'),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('إدارة الماركات')),
      child: SafeArea(
        child:
            _isLoading
                ? Center(child: CupertinoActivityIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoTextField(
                        controller: _nameController,
                        placeholder: 'اسم الماركة',
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 10),
                      CupertinoTextField(
                        controller: _companyNameController,
                        placeholder: 'اسم الشركة',
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 10),
                      CupertinoTextField(
                        controller: _descriptionController,
                        placeholder: 'الوصف',
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 16),
                      IOSButtons.loadingButton(
                        isLoading: _isLoading,
                        onPressed: () async {
                          await addBrand();
                        },
                        text: 'ارسال',
                        color: CupertinoColors.darkBackgroundGray,
                      ),
                      SizedBox(height: 24),

                      // حذف Divider واستبداله بمسافة بسيطة
                      SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _showTrash
                                ? '🗑 سلة المحذوفات'
                                : '📋 قائمة الماركات',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              _showTrash ? 'رجوع' : 'عرض السلة',
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _showTrash = !_showTrash;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ...(_showTrash ? _trash : _brands).map((brand) {
                        final offset =
                            _slideOffsets[brand["id"]] ?? Offset(0, 0);

                        return AnimatedSlide(
                          key: ValueKey(brand["id"]),
                          offset: offset,
                          duration: Duration(milliseconds: 300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: CupertinoColors.systemGrey
                                        .withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.tag,
                                          size: 20,
                                          color: CupertinoColors.systemBlue,
                                        ),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            brand["name"] ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: CupertinoColors.black,
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(
                                            _showTrash
                                                ? CupertinoIcons.refresh_circled
                                                : CupertinoIcons.delete_simple,
                                            color:
                                                _showTrash
                                                    ? CupertinoColors
                                                        .activeGreen
                                                    : CupertinoColors
                                                        .destructiveRed,
                                          ),
                                          onPressed: () async {
                                            _slideOffsets[brand["id"]] = Offset(
                                              _showTrash ? -1 : 1,
                                              0,
                                            );
                                            setState(() {});
                                            await Future.delayed(
                                              Duration(milliseconds: 300),
                                            );
                                            setState(() {
                                              if (_showTrash) {
                                                _brands.add(brand);
                                                _trash.remove(brand);
                                              } else {
                                                _trash.add(brand);
                                                _brands.remove(brand);
                                              }
                                              _slideOffsets.remove(brand["id"]);
                                            });
                                          },
                                        ),
                                        if (_showTrash)
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: Icon(
                                              CupertinoIcons.delete,
                                              color:
                                                  CupertinoColors
                                                      .destructiveRed,
                                            ),
                                            onPressed: () async {
                                              _slideOffsets[brand["id"]] =
                                                  Offset(1, 0);
                                              setState(() {});
                                              await Future.delayed(
                                                Duration(milliseconds: 100),
                                              );

                                              await deleteBrandPermanently(
                                                brand["id"],
                                              );
                                              setState(() {
                                                _trash.remove(brand);
                                                _slideOffsets.remove(
                                                  brand["id"],
                                                );
                                              });
                                            },
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.building_2_fill,
                                          size: 18,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            brand["company_name"] ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color:
                                                  CupertinoColors.systemGrey2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((brand["description"] ?? '')
                                        .toString()
                                        .isNotEmpty) ...[
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.info,
                                            size: 18,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                          SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              brand["description"] ?? '',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    CupertinoColors.systemGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
      ),
    );
  }
}
