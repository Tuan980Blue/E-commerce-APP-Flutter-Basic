import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/model/productmodel.dart';
import '../../data/model/categorymodel.dart';
import '../../data/provider/productprovider.dart';
import '../../data/provider/categoryprovider.dart';

class ProductForm extends StatefulWidget {
  final ProductModel? product; // null = thêm mới, có giá trị = chỉnh sửa
  
  const ProductForm({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imgController = TextEditingController();
  final _descController = TextEditingController();
  final _soldCountController = TextEditingController();
  
  CategoryModel? _selectedCategory;
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    // Nếu là chỉnh sửa, điền dữ liệu vào form
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _imgController.text = widget.product!.img ?? '';
      _descController.text = widget.product!.desc ?? '';
      _soldCountController.text = widget.product!.soldCount.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imgController.dispose();
    _descController.dispose();
    _soldCountController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final categoryProvider = context.read<CategoryProvider>();
    await categoryProvider.loadCategories();
    setState(() {
      _categories = categoryProvider.categories;
      // Nếu là chỉnh sửa, tìm category hiện tại
      if (widget.product != null && widget.product!.catId != null) {
        try {
          _selectedCategory = _categories.firstWhere(
            (cat) => cat.id == widget.product!.catId,
          );
        } catch (e) {
          // Nếu không tìm thấy category, chọn category đầu tiên nếu có
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories.first;
          }
        }
      }
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn danh mục'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final productProvider = context.read<ProductProvider>();
      final product = ProductModel(
        id: widget.product?.id,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.replaceAll(',', '')),
        img: _imgController.text.trim().isEmpty ? null : _imgController.text.trim(),
        desc: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        catId: _selectedCategory!.id,
        soldCount: int.tryParse(_soldCountController.text.trim()) ?? 0,
      );

      bool success;
      if (widget.product == null) {
        // Thêm mới
        success = await productProvider.addProduct(product);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thêm sản phẩm thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      } else {
        // Chỉnh sửa
        success = await productProvider.updateProduct(product);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật sản phẩm thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        }
      }

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatPrice(String value) {
    if (value.isEmpty) return '';
    
    // Loại bỏ tất cả ký tự không phải số
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (value.isEmpty) return '';
    
    // Chuyển thành số và format
    final number = int.parse(value);
    return number.toString().replaceAllMapped(
      RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
      (Match m) => "${m[1]},"
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'),
        backgroundColor: const Color(0xFF764ba2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF764ba2), Color(0xFF667eea)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isEditing ? Icons.edit : Icons.add_shopping_cart,
                          size: 64,
                          color: const Color(0xFF764ba2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEditing 
                              ? 'Cập nhật thông tin sản phẩm'
                              : 'Nhập thông tin sản phẩm mới',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Tên sản phẩm
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Tên sản phẩm *',
                            hintText: 'Nhập tên sản phẩm',
                            prefixIcon: const Icon(Icons.shopping_bag_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF764ba2),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên sản phẩm';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Giá sản phẩm
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              final text = _formatPrice(newValue.text);
                              return TextEditingValue(
                                text: text,
                                selection: TextSelection.collapsed(offset: text.length),
                              );
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Giá sản phẩm *',
                            hintText: 'Nhập giá (VD: 1,000,000)',
                            prefixIcon: const Icon(Icons.attach_money),
                            suffixText: 'VNĐ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF764ba2),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập giá sản phẩm';
                            }
                            final price = double.tryParse(value.replaceAll(',', ''));
                            if (price == null || price <= 0) {
                              return 'Giá sản phẩm phải lớn hơn 0';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Danh mục
                        DropdownButtonFormField<CategoryModel>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Danh mục *',
                            prefixIcon: const Icon(Icons.category_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF764ba2),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          hint: const Text('Chọn danh mục'),
                          items: _categories.map((category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (CategoryModel? value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Vui lòng chọn danh mục';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Hình ảnh URL
                        TextFormField(
                          controller: _imgController,
                          decoration: InputDecoration(
                            labelText: 'URL hình ảnh',
                            hintText: 'Nhập URL hình ảnh (không bắt buộc)',
                            prefixIcon: const Icon(Icons.image_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF764ba2),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Mô tả
                        TextFormField(
                          controller: _descController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Mô tả',
                            hintText: 'Nhập mô tả sản phẩm (không bắt buộc)',
                            prefixIcon: const Icon(Icons.description_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF764ba2),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Số lượng đã bán
                        TextFormField(
                          controller: _soldCountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Số lượng đã bán',
                            hintText: 'Nhập số lượng đã bán (mặc định: 0)',
                            prefixIcon: const Icon(Icons.shopping_cart_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF764ba2),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final soldCount = int.tryParse(value);
                              if (soldCount == null || soldCount < 0) {
                                return 'Số lượng đã bán phải là số nguyên không âm';
                              }
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _isLoading ? null : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: Color(0xFF764ba2)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Hủy',
                                  style: TextStyle(
                                    color: Color(0xFF764ba2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _saveProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF764ba2),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        isEditing ? 'Cập nhật' : 'Thêm mới',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
