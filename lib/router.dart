import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snack_shop/snackshop_app_shell.dart';
import 'package:snack_shop/view/cart/cart_page.dart';
import 'package:snack_shop/view/cart/checkout_page.dart';
import 'package:snack_shop/view/home/home_page.dart';
import 'package:snack_shop/view/login/sign_in_page.dart';
import 'package:snack_shop/view/login/sign_up_page.dart';
import 'package:snack_shop/view/menu/menu_detail_page.dart';
import 'package:snack_shop/view/menu/menu_page.dart';
import 'package:snack_shop/view/settings/history_detail_page.dart';
import 'package:snack_shop/view/settings/history_list_page.dart';
import 'package:snack_shop/view/settings/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/sign-in",
  routes: [
    GoRoute(
      path: "/sign-in",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: "/sign-up",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignUpPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return SnackshopAppShell(
          currentIndex: switch (state.uri.path) {
            var p when p.startsWith("/menu") => 1,
            var p when p.startsWith("/cart") => 2,
            var p when p.startsWith("/settings") => 3,
            _ => 0,
          },
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: "/home",
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: "/menu",
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return const MenuPage();
          },
          routes: [
            GoRoute(
              path: '/menudetail/:index',
              builder: (context, state) {
                final index = int.parse(state.pathParameters['index']!);
                return MenuDetailPage(index: index);
              },
            )
          ],
        ),
        GoRoute(
          path: "/cart",
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return const CartPage();
          },
          routes: [
            GoRoute(
              path: '/checkout/:cost',
              builder: (context, state) {
                final cost = int.parse(state.pathParameters['cost']!);
                return CheckoutPage(cost: cost);
              },
            )
          ],
        ),
        GoRoute(
          path: "/settings",
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return const SettingsPage();
          },
          routes: [
            GoRoute(
              path: '/historylist',
              builder: (context, state) {
                return const HistoryListPage();
              },
              routes: [
                GoRoute(
                  path: '/historydetail/:ordertime',
                  builder: (context, state) {
                    final ordertime = state.pathParameters['ordertime']!;
                    return HistoryDetailPage(
                      orderTime: ordertime,
                    );
                  },
                )
              ],
            )
          ],
        ),
      ],
    ),
  ],
);
