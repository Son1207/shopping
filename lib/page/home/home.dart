import 'package:badges/badges.dart';
import 'package:badges/src/badge.dart' as badge;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/const.dart';
import 'package:shopping/page/auth/auth_page.dart';
import 'package:shopping/page/cart/cart.dart';
import 'package:shopping/page/home/widget/home_category.dart';
import 'package:shopping/page/home/widget/home_slider.dart';
import 'package:shopping/page/home/widget/list_product_special.dart';
import 'package:shopping/page/order/list_order.dart';
import 'package:shopping/providers/auth_provider.dart';
import 'package:shopping/providers/cart_provider.dart';

class HomePage extends StatelessWidget {
  static const routerName = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return auth.isAuth
            ? const Home()
            : FutureBuilder(
          future: auth.autoLogin(),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data ? const Home() : AuthPage();
          },
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<AuthProvider>(context).checkTimeExpires();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                child: Image(image: AssetImage('assets/images/logo1.png'),height: 100,),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('Trang ch???'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.library_books),
                        title: const Text('Danh s??ch ????n h??ng'),
                        onTap: () {
                          Navigator.popAndPushNamed(
                              context, ListOrder.routerName);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('????ng xu???t'),
                        onTap: () {
                          auth.logout();
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Consumer<CartProvider>(
              builder: (context, value, child) {
                return badge.Badge(
                  badgeContent: Text('${value.items.length}'),
                  position: BadgePosition.topEnd(top: 0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, CartPage.routerName);
                      },
                      child: const Icon(Icons.shopping_cart)),
                );
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const HomeSlider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Danh m???c s???n ph???m',
                  style: fdCategory,
                ),
                Text('T???t c??? (4)'),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const HomeCategory(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'S???n ph???m ?????c bi???t',
                  style: fdCategory,
                ),
                Text('T???t c??? (4)'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const ListProductSpecial(),
        ],
      ),
    );
  }
}
