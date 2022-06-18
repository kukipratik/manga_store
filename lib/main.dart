import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manga_store/Provider/auth.dart';
import 'package:manga_store/Provider/cart.dart';
import 'package:manga_store/Provider/order.dart';
import 'package:manga_store/Provider/products.dart';
import 'package:manga_store/Screens/auth_screen.dart';
import 'package:manga_store/Screens/cart_screen.dart';
import 'package:manga_store/Screens/edit_product_screen.dart';
import 'package:manga_store/Screens/order_screen.dart';
import 'package:manga_store/Screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import 'Screens/home.dart';
import 'Screens/product_detail.dart';
import 'utils/colors.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products([], '', ''),
            update: (context, auth, previousProducts) => Products(
                previousProducts == null ? [] : previousProducts.items,
                auth.token,
                auth.userID),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', '', []),
            update: (context, auth, previousOrders) => Orders(
              auth.token,
              auth.userID,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: bgColor,
                textTheme: ThemeData.light().textTheme.copyWith(
                      titleLarge: GoogleFonts.domine(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      )),
                      titleMedium: GoogleFonts.domine(
                          textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                    )),
            // initialRoute: authScreen,
            home: auth.isAuth ? const HomeScreen() : const AuthScreen(),
            routes: {
              homeScreen: (context) => const HomeScreen(),
              productDetail: (context) => const ProductDetail(),
              cartScreen: (context) => const CartScreen(),
              orderScreen: (context) => const OrderScreen(),
              userProductScreen: (context) => const UserProductsScreen(),
              editProductScreen: (context) => const EditProductScreen(),
              // authScreen: (context) => const AuthScreen(),
            },
          ),
        ));
  }
}
