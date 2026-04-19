import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/surah_picker.dart';
import '../widgets/surah_view.dart';
import '../widgets/recording_widget.dart'; // Import RecordingWidget
import '../services/preference_service.dart';
import '../services/quran_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PreferenceService _preferenceService = PreferenceService();
  
  // Page Controller for Surahs
  late PageController _pageController;

  bool _isLoading = true;
  int _currentSurahNumber = 1;
  String _currentSurahName = "Al-Fatiha";
  
  // Stream controller to broadcast analysis results to SurahView
  final StreamController<Map<String, dynamic>> _analysisController = StreamController<Map<String, dynamic>>.broadcast();

  @override
  void initState() {
    super.initState();
    // Initialize with a dummy initial page, will be updated in _loadState
    _pageController = PageController(initialPage: 0);
    _loadState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _analysisController.close();
    super.dispose();
  }

  Future<void> _loadState() async {
    final lastSurah = await _preferenceService.getLastSurah();
    if (mounted) {
      final surahNum = lastSurah['number'];
      setState(() {
        _currentSurahNumber = surahNum;
        _currentSurahName = lastSurah['name'];
        _isLoading = false;
      });
      
      // Update PageController to start at the correct Surah
      // Provide a slight delay to ensure the PageView is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(surahNum - 1);
        }
      });
    }
  }

  void _onSurahSelected(int number, String name, int verses) {
    setState(() {
      _currentSurahNumber = number;
      _currentSurahName = name;
    });
    _preferenceService.saveLastSurah(number, name, verses);
    
    // Jump PageView to the selected Surah
    if (_pageController.hasClients) {
      _pageController.jumpToPage(number - 1);
    }
  }

  void _onSurahSwipeChanged(int index) {
    // Index is 0-based, Surah Number is 1-based
    final newSurahNum = index + 1;
    if (newSurahNum == _currentSurahNumber) return;

    if (newSurahNum <= QuranService.surahNames.length) {
      final name = QuranService.surahNames[newSurahNum - 1];
      
      final verseCount = QuranService.surahVerseCounts[newSurahNum - 1];

      setState(() {
        _currentSurahNumber = newSurahNum;
        _currentSurahName = name;
      });
      
      _preferenceService.saveLastSurah(newSurahNum, name, verseCount);
    }
  }
  
  void _navigateToNextSurah() {
    if (_currentSurahNumber < 114 && _pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showSurahPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SurahPicker(
        selectedSurahNumber: _currentSurahNumber,
        onSurahSelected: _onSurahSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Custom Top Bar with Drawer Icon and Surah Card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, size: 36, color: Colors.black87),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showSurahPicker,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFDF5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    QuranService.surahNames[_currentSurahNumber - 1],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Page 1  •  Surah $_currentSurahNumber",
                                    style: GoogleFonts.outfit(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                // Main Reading View (PageView)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    reverse: true, // Enable RTL navigation (Swipe Right -> Next Surah)
                    itemCount: 114,
                    onPageChanged: _onSurahSwipeChanged,
                    itemBuilder: (context, index) {
                      final surahNum = index + 1;
                      
                      String surahName = "";
                      int totalVerses = 0;
                      
                      if (index < QuranService.surahNames.length) {
                         surahName = QuranService.surahNames[index];
                      }
                      if (index < QuranService.surahVerseCounts.length) {
                         totalVerses = QuranService.surahVerseCounts[index];
                      }

                      return SurahView(
                        surahNumber: surahNum,
                        surahName: surahName,
                        totalVerses: totalVerses,
                        onSurahCompleted: _navigateToNextSurah,
                        analysisStream: _analysisController.stream, // Pass the stream
                      );
                    },
                  ),
                ),
                
                // Hoisted Recording Widget
                Container(
                  padding: const EdgeInsets.only(bottom: 20, left: 24),
                  alignment: Alignment.centerLeft,
                  child: RecordingWidget(
                    surahNumber: _currentSurahNumber,
                    onAnalysisComplete: (data) => _analysisController.add(data),
                    onRecordingStopped: () {
                       // Broadcast a stop event so SurahView can save?
                       // Or we just rely on SurahView to save when IT thinks it should?
                       // Currently SurahView saves in `_handleRecordingStopped` which was called by RecordingWidget.
                       // We can send a special event:
                       _analysisController.add({'status': 'stopped'});
                    },
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
