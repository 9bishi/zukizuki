import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../widgets/custom_banner.dart';
import '../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadHotVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '搜索视频...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _isSearching = false);
                            context.read<VideoProvider>().resetSearch();
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          context.read<VideoProvider>().searchVideos(value);
                        }
                      },
                    )
                  : const Text('视频'),
              actions: [
                if (!_isSearching)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() => _isSearching = true);
                    },
                  ),
              ],
              floating: true,
              snap: true,
            ),
          ];
        },
        body: Consumer<VideoProvider>(
          builder: (context, videoProvider, child) {
            if (videoProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                if (videoProvider.searchQuery.isEmpty) {
                  await videoProvider.loadHotVideos();
                } else {
                  await videoProvider.searchVideos(videoProvider.searchQuery);
                }
              },
              child: CustomScrollView(
                slivers: [
                  if (!_isSearching && videoProvider.searchQuery.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CustomBanner(),
                      ),
                    ),
                  if (videoProvider.videos.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text('暂无视频'),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 0.8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final video = videoProvider.videos[index];
                            return VideoCard(video: video);
                          },
                          childCount: videoProvider.videos.length,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}