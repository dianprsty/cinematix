import 'package:cinematix/presentation/extensions/build_context_extension.dart';
import 'package:cinematix/presentation/pages/movie_page/movie_page.dart';
import 'package:cinematix/presentation/pages/profile_page/profile_page.dart';
import 'package:cinematix/presentation/pages/ticket_page/ticket_page.dart';
import 'package:cinematix/presentation/providers/router/router_provider.dart';
import 'package:cinematix/presentation/providers/user_data/user_data_provider.dart';
import 'package:cinematix/presentation/widgets/bottom_nav_bar.dart';
import 'package:cinematix/presentation/widgets/bottom_nav_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  PageController pageController = PageController();
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen(userDataProvider, (previous, next) {
      if (previous != null && next is AsyncData && next.value == null) {
        ref.read(routerProvider).goNamed('login');
      } else if (next is AsyncError) {
        context.showSnackBar(next.error.toString());
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                selectedPage = value;
              });
            },
            children: const [
              Center(child: MoviePage()),
              Center(child: TicketPage()),
              Center(child: ProfilePage()),
            ],
          ),
          BottomNavBar(
            items: [
              BottomNavBarItem(
                index: 0,
                isSelected: selectedPage == 0,
                title: 'Home',
                image: 'assets/images/movie.png',
                selectedImage: 'assets/images/movie-selected.png',
              ),
              BottomNavBarItem(
                index: 1,
                isSelected: selectedPage == 1,
                title: 'Ticket',
                image: 'assets/images/ticket.png',
                selectedImage: 'assets/images/ticket-selected.png',
              ),
              BottomNavBarItem(
                index: 2,
                isSelected: selectedPage == 2,
                title: 'Profile',
                image: 'assets/images/profile.png',
                selectedImage: 'assets/images/profile-selected.png',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedPage = index;
              });
              pageController.animateToPage(
                selectedPage,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
            selectedIndex: 0,
          ),
        ],
      ),
    );
  }
}
