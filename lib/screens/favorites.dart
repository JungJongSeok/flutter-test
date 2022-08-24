import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/feeds.dart';

class FavoritesPage extends StatelessWidget {
  static const routeName = '/favorites_page';

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<Feeds>(
        builder: (context, value, child) => value.items.isNotEmpty
            ? ListView.builder(
                itemCount: value.items.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) =>
                    FavoriteItemTile(value.items[index]),
              )
            : const Center(
                child: Text('No favorites added.'),
              ),
      ),
    );
  }
}

class FavoriteItemTile extends StatelessWidget {
  final FeedData feed;

  const FavoriteItemTile(this.feed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[feed.hashCode % Colors.primaries.length],
        ),
        title: Text(
          'Item $feed',
          key: Key('favorites_text_$feed'),
        ),
        trailing: IconButton(
          key: Key('remove_icon_$feed'),
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<Feeds>().remove(feed);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites.'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
