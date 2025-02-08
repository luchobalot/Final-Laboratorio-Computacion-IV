import 'package:flutter/material.dart';
import 'package:final_api_laboratorio/services/balot_api_services.dart';
import 'package:final_api_laboratorio/helpers/preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_api_laboratorio/models/movie.dart';

class BalotListScreen extends StatefulWidget {
  const BalotListScreen({super.key});

  @override
  State<BalotListScreen> createState() => _BalotListScreenState();
}

class _BalotListScreenState extends State<BalotListScreen> {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  String _searchQuery = '';
  bool _isGridView = false;
  bool _isLoading = false;
  bool _hasMoreMovies = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchMovies();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMoreMovies) {
        _loadMoreMovies();
      }
    }
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final movies = await BalotApiService.instance.getMovies(page: _currentPage);
      setState(() {
        _movies = movies;
        _filteredMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar las películas: $e")),
      );
    }
  }

  Future<void> _loadMoreMovies() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _currentPage++;
    });

    try {
      final newMovies = await BalotApiService.instance.getMovies(page: _currentPage);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMoreMovies = false;
        } else {
          _movies.addAll(newMovies);
          _updateSearch(_searchQuery);
        }
      });
    } catch (e) {
      setState(() {
        _currentPage--; // Revertir el incremento de página si hay error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar más películas: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSearch(String? query) {
    setState(() {
      _searchQuery = query ?? '';
      if (_searchQuery.isEmpty) {
        _filteredMovies = _movies;
      } else {
        _filteredMovies = _movies.where((movie) {
          return movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _refreshMovies() async {
    _currentPage = 1;
    _hasMoreMovies = true;
    await _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Preferences.darkmode;
    final Color backgroundColor = isDarkMode ? const Color.fromARGB(255, 35, 35, 35) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color cardColor = isDarkMode ? const Color.fromARGB(255, 52, 58, 64) : Colors.grey[200]!;
    final Color starColor = isDarkMode ? const Color.fromARGB(255, 255, 217, 0) : const Color.fromARGB(255, 255, 204, 0);

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            _buildHeader(textColor),
            _buildViewToggle(textColor),
            Expanded(
              child: _hasError 
                ? _buildErrorWidget()
                : RefreshIndicator(
                    onRefresh: _refreshMovies,
                    child: _isGridView 
                      ? _buildGridView(starColor, cardColor)
                      : _buildListView(starColor, cardColor),
                  ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mejores Películas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: textColor,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(Color starColor, Color cardColor) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredMovies.length,
      itemBuilder: (context, index) {
        final movie = _filteredMovies[index];
        return _buildMovieCard(movie, starColor, cardColor);
      },
    );
  }

  Widget _buildListView(Color starColor, Color cardColor) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: _filteredMovies.length,
      itemBuilder: (context, index) {
        final movie = _filteredMovies[index];
        return _buildMovieCard(movie, starColor, cardColor);
      },
    );
  }

  Widget _buildMovieCard(Movie movie, Color starColor, Color cardColor) {
    return GestureDetector(
      onTap: () => _navigateToDetails(movie),
      child: Card(
        color: cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: movie.posterPath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: starColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error al cargar las películas',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshMovies,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(Movie movie) {
    Navigator.pushNamed(
      context,
      'movie_details',
      arguments: movie,
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }
}