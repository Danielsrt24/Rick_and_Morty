import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/characters_provider.dart';
import 'catalog_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final User user;
  const WelcomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharactersProvider>(context, listen: false)
          .setCurrentUser(widget.user.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Cocolito y Cepillín',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/cocolito.jpg',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: 38),
            
            _buildButton('Ver catálogo', Icons.list, const CatalogScreen()),
            const SizedBox(height: 12),
            _buildButton('Ver favoritos', Icons.favorite, const FavoritesScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, Widget screen) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 17)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA8D8EA),
          foregroundColor: const Color(0xFF1F4E5F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}