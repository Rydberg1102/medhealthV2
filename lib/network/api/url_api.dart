class BASEURL {
  static String ipAddress = "172.20.10.3";
  static String apiRegister = "http://$ipAddress/medhealth_db/register_api.php";
  static String apiLogin = "http://$ipAddress/medhealth_db/login_api.php";
  static String categoryWithProduct =
      "http://$ipAddress/medhealth_db/get_product_with_category.php";
  static String getProduct = "http://$ipAddress/medhealth_db/get_product.php";
  static String addToCart = "http://$ipAddress/medhealth_db/add_to_cart.php";
  static String getProductCart =
      "http://$ipAddress/medhealth_db/get_cart.php?userID=";
  static String updateQuantityProductCart =
      "http://$ipAddress/medhealth_db/update_quantity.php";
  static String totalPriceCart =
      "http://$ipAddress/medhealth_db/get_total_price.php?userID=";
  static String getTotalCart =
      "http://$ipAddress/medhealth_db/total_cart.php?userID=";
  static String checkout = "http://$ipAddress/medhealth_db/check_out.php";
  static String apiHistory =
      "http://$ipAddress/medhealth_db/get_history.php?id_user=";
}
