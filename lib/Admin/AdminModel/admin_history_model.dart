class AdminHistoryOrderModel {
  final String invoice;
  final String idUser;
  final String orderAt;
  final String status;
  final List<AdminHistoryOrderDetailModel> detail;

  AdminHistoryOrderModel(
      {required this.invoice,
      required this.idUser,
      required this.orderAt,
      required this.status,
      required this.detail});

  factory AdminHistoryOrderModel.fromJson(Map<String, dynamic> dataOrder) {
    var list = dataOrder['det'] as List;
    List<AdminHistoryOrderDetailModel> dataListDetail =
        list.map((e) => AdminHistoryOrderDetailModel.fromJson(e)).toList();
    return AdminHistoryOrderModel(
      invoice: dataOrder['invoice'],
      idUser: dataOrder['id_user'],
      orderAt: dataOrder['order_at'],
      status: dataOrder['status'],
      detail: dataListDetail,
    );
  }
}

class AdminHistoryOrderDetailModel {
  final String idOrders;
  final String invoice;
  final String idProduct;
  final String nameProduct;
  final String quantity;
  final String price;

  AdminHistoryOrderDetailModel(
      {required this.idOrders,
      required this.invoice,
      required this.idProduct,
      required this.nameProduct,
      required this.quantity,
      required this.price});

  factory AdminHistoryOrderDetailModel.fromJson(Map<String, dynamic> data) {
    return AdminHistoryOrderDetailModel(
      idOrders: data['id_orders'],
      invoice: data['invoice'],
      idProduct: data['id_product'],
      nameProduct: data['nameProduct'],
      quantity: data['quantity'],
      price: data['price'],
    );
  }
}
