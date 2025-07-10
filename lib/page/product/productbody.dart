import 'package:app_auth/page/product/productwidget.dart';
import 'package:app_auth/page/product/product_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../confg/const.dart';
import '../../data/model/productmodel.dart';
import '../../data/provider/categoryprovider.dart';
import '../../data/provider/productprovider.dart';

class ProductBody extends StatefulWidget {
  final int? categoryId;
  
  const ProductBody({
    Key? key,
    this.categoryId,
  }) : super(key: key);

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'price', or 'soldCount'
  bool _sortAscending = true;
  RangeValues _priceRange = const RangeValues(0, 50000000);
  ViewMode _viewMode = ViewMode.grid; // Default view mode

  @override
  void initState() {
    super.initState();
    // Load products when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
    });
  }

  void _onPriceRangeChanged(RangeValues range) {
    setState(() {
      _priceRange = range;
    });
  }

  void _onViewModeChanged(ViewMode viewMode) {
    setState(() {
      _viewMode = viewMode;
    });
  }

  void _showAddProductForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductForm(),
      ),
    );
  }

  void _showEditProductForm(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductForm(product: product),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(ProductModel product) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Xác nhận xóa'),
            ],
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa sản phẩm "${product.name}"?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(ProductModel product) async {
    final productProvider = context.read<ProductProvider>();
    final success = await productProvider.deleteProduct(product.id!);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa sản phẩm "${product.name}"'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi xóa sản phẩm'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ProductModel> _getFilteredAndSortedProducts(ProductProvider productProvider) {
    List<ProductModel> products;
    
    if (widget.categoryId != null) {
      products = productProvider.getProductsByCategory(widget.categoryId!);
    } else {
      products = productProvider.products;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      products = products.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Apply price filter
    products = products.where((product) =>
        product.price >= _priceRange.start && product.price <= _priceRange.end).toList();

    // Apply sorting
    if (_sortBy == 'price') {
      products = productProvider.sortProductsByPrice(products, ascending: _sortAscending);
    } else if (_sortBy == 'soldCount') {
      products = productProvider.sortProductsBySoldCount(products, ascending: _sortAscending);
    } else {
      products = productProvider.sortProductsByName(products, ascending: _sortAscending);
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, CategoryProvider>(
      builder: (context, productProvider, categoryProvider, child) {
        if (productProvider.loading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang tải sản phẩm...'),
              ],
            ),
          );
        }

        if (productProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lỗi tải sản phẩm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  productProvider.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => productProvider.loadProducts(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        final products = _getFilteredAndSortedProducts(productProvider);
        final selectedCategory = widget.categoryId != null 
            ? categoryProvider.getCategoryById(widget.categoryId!)
            : null;

        return Column(
          children: [
            // Header với Search và Add Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filter và Sort Options
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sắp xếp và lọc',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Sort by options
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _sortBy,
                                decoration: InputDecoration(
                                  labelText: 'Sắp xếp theo',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'name', child: Text('Tên sản phẩm')),
                                  DropdownMenuItem(value: 'price', child: Text('Giá')),
                                  DropdownMenuItem(value: 'soldCount', child: Text('Số lượng bán')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    _onSortChanged(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Sort direction
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _sortAscending = !_sortAscending;
                                  });
                                },
                                icon: Icon(
                                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: const Color(0xFF764ba2),
                                ),
                                tooltip: _sortAscending ? 'Tăng dần' : 'Giảm dần',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Stats và Add Button
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF764ba2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${products.length} sản phẩm',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF764ba2),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _showAddProductForm,
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm mới'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF764ba2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Products List
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isEmpty ? Icons.inventory_2_outlined : Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty 
                                ? 'Chưa có sản phẩm nào'
                                : 'Không tìm thấy sản phẩm cho "$_searchQuery"',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _clearSearch,
                              child: const Text('Xóa tìm kiếm'),
                            ),
                          ],
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _showAddProductForm,
                              icon: const Icon(Icons.add),
                              label: const Text('Thêm sản phẩm đầu tiên'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF764ba2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ProductWidget(
                      products: products,
                      viewMode: _viewMode,
                      onEditProduct: _showEditProductForm,
                      onDeleteProduct: _showDeleteConfirmation,
                    ),
            ),
          ],
        );
      },
    );
  }
}
