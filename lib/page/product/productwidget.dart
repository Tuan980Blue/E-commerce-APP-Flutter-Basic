import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../confg/const.dart';
import '../../data/model/productmodel.dart';
import '../../data/provider/cartprovider.dart';
import '../../data/provider/productprovider.dart';

class ProductWidget extends StatelessWidget {
  final List<ProductModel> products;
  final ViewMode viewMode;
  final Function(ProductModel)? onEditProduct;
  final Function(ProductModel)? onDeleteProduct;

  const ProductWidget({
    Key? key,
    required this.products,
    required this.viewMode,
    this.onEditProduct,
    this.onDeleteProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewMode) {
      case ViewMode.list:
        return _buildListView(context);
      case ViewMode.grid:
        return _buildGridView(context);
      case ViewMode.table:
        return _buildTableView(context);
    }
  }

  // List View - Hiển thị dạng danh sách dọc
  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              // Main content
              InkWell(
                onTap: () => _showProductDetails(context, product),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: product.img != null && product.img!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/${product.img!}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 32,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF2D3748),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Price
                            Text(
                              product.formattedPrice,
                              style: const TextStyle(
                                color: Color(0xFF764ba2),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            
                            const SizedBox(height: 4),
                            
                            // Sold Count
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Đã bán: ${product.soldCount}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            
                            if (product.desc != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                product.desc!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Arrow indicator
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action buttons
              Container(
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    // Add to cart button
                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final isInCart = cartProvider.isProductInCart(product.id!);
                          return InkWell(
                            onTap: () => _addToCart(context, product),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                                    size: 20,
                                    color: isInCart ? Colors.green : Color(0xFF764ba2),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    isInCart ? 'Đã thêm' : 'Thêm vào giỏ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isInCart ? Colors.green : Color(0xFF764ba2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Buy now button
                    Expanded(
                      child: InkWell(
                        onTap: () => _buyNow(context, product),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.green.shade600],
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_checkout,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Mua ngay',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Grid View - Hiển thị dạng lưới
  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Main content
              Expanded(
                child: InkWell(
                  onTap: () => _showProductDetails(context, product),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: product.img != null && product.img!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/${product.img!}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey[400],
                                        size: 40,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Product Name
                        Flexible(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF2D3748),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: 6),
                        
                        // Price
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            color: Color(0xFF764ba2),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Sold Count
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product.soldCount}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        if (product.desc != null) ...[
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              product.desc!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              
              // Action buttons
              Container(
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    // Add to cart button
                    Expanded(
                      child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final isInCart = cartProvider.isProductInCart(product.id!);
                          return InkWell(
                            onTap: () => _addToCart(context, product),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                                    size: 20,
                                    color: isInCart ? Colors.green : Color(0xFF764ba2),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    isInCart ? 'Đã thêm' : 'Thêm vào giỏ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isInCart ? Colors.green : Color(0xFF764ba2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Buy now button
                    Expanded(
                      child: InkWell(
                        onTap: () => _buyNow(context, product),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green, Colors.green.shade600],
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_checkout,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Mua ngay',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Table View - Hiển thị dạng bảng
  Widget _buildTableView(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Hình ảnh')),
          DataColumn(label: Text('Tên sản phẩm')),
          DataColumn(label: Text('Giá')),
          DataColumn(label: Text('Đã bán')),
          DataColumn(label: Text('Mô tả')),
          DataColumn(label: Text('Thao tác')),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: product.img != null && product.img!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/${product.img!}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 24,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                ),
              ),
              DataCell(Text(product.name)),
              DataCell(Text(product.formattedPrice)),
              DataCell(Text('${product.soldCount}')),
              DataCell(Text(product.desc ?? '')),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF764ba2)),
                      onPressed: () => onEditProduct?.call(product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDeleteProduct?.call(product),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showProductDetails(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(product.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.img != null && product.img!.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/${product.img!}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 64,
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Giá: ${product.formattedPrice}'),
              const SizedBox(height: 8),
              Text('Đã bán: ${product.soldCount}'),
              if (product.desc != null) ...[
                const SizedBox(height: 8),
                Text('Mô tả: ${product.desc}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final isInCart = cartProvider.isProductInCart(product.id!);
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addToCart(context, product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.green : Color(0xFF764ba2),
                  ),
                  child: Text(isInCart ? 'Đã thêm vào giỏ' : 'Thêm vào giỏ'),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _buyNow(context, product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mua ngay'),
            ),
          ],
        );
      },
    );
  }

  // Thêm vào giỏ hàng
  void _addToCart(BuildContext context, ProductModel product) async {
    final cartProvider = context.read<CartProvider>();
    final success = await cartProvider.addToCart(product);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm "${product.name}" vào giỏ hàng'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Xem giỏ hàng',
            textColor: Colors.white,
            onPressed: () {
              // TODO: Navigate to cart page
            },
          ),
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi thêm vào giỏ hàng'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Mua ngay
  void _buyNow(BuildContext context, ProductModel product) async {
    final cartProvider = context.read<CartProvider>();
    final productProvider = context.read<ProductProvider>();
    
    // Hiển thị dialog xác nhận mua hàng
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.shopping_cart_checkout, color: Colors.green),
              SizedBox(width: 8),
              Text('Xác nhận mua hàng'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sản phẩm: ${product.name}'),
              const SizedBox(height: 8),
              Text('Giá: ${product.formattedPrice}'),
              const SizedBox(height: 16),
              const Text('Bạn có chắc chắn muốn mua sản phẩm này?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mua ngay'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Cập nhật số lượng đã bán
      await productProvider.incrementSoldCount(product.id!);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã mua thành công "${product.name}"!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
