import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../providers/characters_provider.dart';

class DetailScreen extends StatelessWidget {
  final Character character;
  const DetailScreen({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharactersProvider>(context);
    final bool isFav = provider.isFavorite(character.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
            onPressed: () => provider.toggleFavorite(character),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: character.image, height: 350, fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: character.status.toLowerCase() == 'alive' ? Colors.green : Colors.red, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(character.status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(Icons.science, 'Especie', character.species),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.wc, 'Género', character.gender),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.place, 'Origen', character.origin.name),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on, 'Ubicación', character.location.name),
                  const SizedBox(height: 20),
                  const Text('Episodios:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('${character.episode.length} episodios', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[700], size: 24),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}