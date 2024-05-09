import 'package:flutter/material.dart';
import 'package:test_7solution/model/fibonacci.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test 7solutions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Fibonacci> _fiboList = [];
  Fibonacci? _selectedFibo;
  final Map<int, GlobalKey> _mainKeys = {};
  final Map<int, GlobalKey> _bottomKeys = {};
  final List<Fibonacci> _selectedFiboCircleList = [];
  final List<Fibonacci> _selectedFiboSquareList = [];
  final List<Fibonacci> _selectedFiboCrossList = [];
  final ScrollController _mainScrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _mainKeys.clear();
    _bottomKeys.clear();
    _mainScrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fiboList = Fibonacci.getFibo(39);
  }

  Future _scrollToTarget(GlobalKey key) async {
    if (key.currentContext == null) {
      await _mainScrollController.position.ensureVisible(
        _mainKeys[_fiboList.length - 1]!.currentContext!.findRenderObject()!,
        duration: const Duration(seconds: 1),
      );
    } else {
      final context = key.currentContext!;
      await Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(seconds: 1),
      );
    }
  }

  void _checkSelectedFibo(
    Fibonacci selectedFibo,
    bool isAdd,
  ) {
    setState(
      () {
        _selectedFibo = selectedFibo;
        if (isAdd) {
          _fiboList = _fiboList
              .where((Fibonacci fibo) => fibo.index != selectedFibo.index)
              .toList();
          _sortingSelectedFiboType(selectedFibo);

          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              int indexOfBottomList = _getIndexOfFiboBottomList(selectedFibo);
              if (_bottomKeys[indexOfBottomList] == null ||
                  indexOfBottomList == -1) return;
              _scrollToTarget(_bottomKeys[indexOfBottomList]!);
            },
          );
        } else {
          _fiboList.add(selectedFibo);
          _fiboList.sort((a, b) => a.index.compareTo(b.index));
          _sortingRemoveFiboType(selectedFibo);

          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_mainKeys[selectedFibo.index] == null) return;
              _scrollToTarget(_mainKeys[selectedFibo.index]!);
            },
          );
        }
      },
    );
  }

  int _getIndexOfFiboBottomList(Fibonacci selectedFibo) {
    switch (selectedFibo.fiboType) {
      case FiboType.circle:
        return _selectedFiboCircleList.indexOf(selectedFibo);
      case FiboType.square:
        return _selectedFiboSquareList.indexOf(selectedFibo);
      case FiboType.cros:
        return _selectedFiboCrossList.indexOf(selectedFibo);
      default:
        return -1;
    }
  }

  void _sortingSelectedFiboType(Fibonacci selectedFibo) {
    switch (selectedFibo.fiboType) {
      case FiboType.circle:
        _selectedFiboCircleList.add(selectedFibo);
      case FiboType.square:
        _selectedFiboSquareList.add(selectedFibo);
      case FiboType.cros:
        _selectedFiboCrossList.add(selectedFibo);
      default:
    }
  }

  void _sortingRemoveFiboType(Fibonacci selectedFibo) {
    switch (selectedFibo.fiboType) {
      case FiboType.circle:
        _selectedFiboCircleList.remove(selectedFibo);
      case FiboType.square:
        _selectedFiboSquareList.remove(selectedFibo);
      case FiboType.cros:
        _selectedFiboCrossList.remove(selectedFibo);
      default:
    }
  }

  List<Fibonacci> _getSelectedFiboTypeList(Fibonacci selectedFibo) {
    switch (selectedFibo.fiboType) {
      case FiboType.circle:
        _selectedFiboCircleList.sort((a, b) => a.index.compareTo(b.index));
        return _selectedFiboCircleList;
      case FiboType.square:
        _selectedFiboSquareList.sort((a, b) => a.index.compareTo(b.index));
        return _selectedFiboSquareList;
      case FiboType.cros:
        _selectedFiboCrossList.sort((a, b) => a.index.compareTo(b.index));
        return _selectedFiboCrossList;
      default:
        return [];
    }
  }

  Widget _bottomSheetContent() {
    if (_selectedFibo == null) return const SizedBox.shrink();
    List<Fibonacci> fiboList = _getSelectedFiboTypeList(_selectedFibo!);
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          fiboList.length,
          (index) {
            Fibonacci fibo = fiboList[index];
            _bottomKeys[index] = GlobalKey();
            return SizedBox(
              height: 60,
              key: _bottomKeys[index],
              child: ListTile(
                tileColor:
                    fibo == _selectedFibo ? Colors.green : Colors.transparent,
                title: Text('Number: ${fibo.fiboValue}'),
                subtitle: Text('index: ${fibo.index}'),
                trailing: Fibonacci.getIcon(fibo.fiboType),
                onTap: () {
                  Navigator.pop(context);
                  _checkSelectedFibo(fibo, false);
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      controller: _mainScrollController,
      child: Column(
        children: List.generate(
          _fiboList.length,
          (index) {
            Fibonacci fibo = _fiboList[index];
            _mainKeys[index] = GlobalKey();
            return SizedBox(
              height: 60,
              child: ListTile(
                key: _mainKeys[index],
                tileColor:
                    fibo == _selectedFibo ? Colors.red : Colors.transparent,
                title: Text('index: ${fibo.index}, Number: ${fibo.fiboValue}'),
                trailing: Fibonacci.getIcon(fibo.fiboType),
                onTap: () {
                  _checkSelectedFibo(fibo, true);
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: _bottomSheetContent(),
                      );
                    },
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: _content(),
    );
  }
}
