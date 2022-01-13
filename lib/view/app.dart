import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int rows = 0;
  int columns = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de Islas'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            HeaderControls(
              onPress: (pair) {
                setState(() {
                  rows = pair.rows;
                  columns = pair.columns;
                });
              },
            ),
            Expanded(
              child: rows == 0 || columns == 0
                  ? const SizedBox.shrink()
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: 10,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text('$index'),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15)),
                        );
                      }),
            ),
            const SizedBox(
              height: 50,
              child: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderControls extends StatefulWidget {
  final Function(PairData) onPress;
  const HeaderControls({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  State<HeaderControls> createState() => _HeaderControlsState();
}

class _HeaderControlsState extends State<HeaderControls> {
  late TextEditingController _rowsController;
  late TextEditingController _columnsController;

  @override
  void initState() {
    super.initState();
    _rowsController = TextEditingController();
    _columnsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      height: 100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _rowsController,
                    decoration: const InputDecoration(
                      label: Text('Filas'),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _columnsController,
                    decoration: const InputDecoration(
                      label: Text('Columnas'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onPress(
                  PairData(
                    rows: int.parse(_rowsController.text),
                    columns: int.parse(_columnsController.text),
                  ),
                );
              },
              child: const Text('Generar'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _rowsController.dispose();
    _columnsController.dispose();
    super.dispose();
  }
}

class PairData {
  final int rows;
  final int columns;

  PairData({required this.rows, required this.columns});

  @override
  String toString() {
    return '[Rows:$rows, Columns:$columns]';
  }
}
