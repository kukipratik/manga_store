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
          ChangeNotifierProvider(
            create: (context) => Products(),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (context) => Orders(),
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
            initialRoute: authScreen,
            routes: {
              homeScreen: (context) => const HomeScreen(),
              productDetail: (context) => const ProductDetail(),
              cartScreen: (context) => const CartScreen(),
              orderScreen: (context) => const OrderScreen(),
              userProductScreen: (context) => const UserProductsScreen(),
              editProductScreen: (context) => const EditProductScreen(),
              authScreen: (context) => const AuthScreen(),
            },
          ),
        ));
  }
}
