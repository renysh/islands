import 'package:flutter/material.dart';
import 'dart:math';

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
                  : GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisCount: columns,
                      children: generateMatrixData(rows, columns),
                    ),
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

  List<Widget> generateMatrixData(int rows, int columns) {
    List<Widget> ret = [];
    List<List<int>> m = [];

    List<int> f = [];
    for (int i = 1; i <= rows * columns; i++) {
      var n = Random().nextInt(2);
      f.add(n);
      if (i % columns == 0) {
        m.add(f);
        f = [];
      }
      Widget w = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: n == 1 ? Colors.greenAccent : Colors.white,
        ),
        child: Center(child: Text('$n')),
      );
      ret.add(w);
    }

    List<List<Block>> matrixVerify = [];

    for (int i = 0; i < m.length; i++) {
      List<Block> rb = [];
      List<int> row = m[i];
      for (int j = 0; j < row.length; j++) {
        int currentNumber = m[i][j];
        Block block = Block();
        block.label = currentNumber.toString();
        //evaluar los 1->tierra
        if (currentNumber == 1) {
          if (i == 0) {
            //primera fila
            if (j == 0) {
              //primera columna
              block.reinit();
              //obtener el de la derecha
              int r = m[i][j + 1];
              if (r == 1) {
                block.right = true;
              }
              //obtener el de abajo
              int b = m[i + 1][j];
              if (b == 1) {
                block.bottom = true;
              }
            } else if (j == row.length - 1) {
              //ultima columna
              block.reinit();
              //obtener el de la izquierda
              int l = m[i][j - 1];
              if (l == 1) {
                block.left = true;
              }
              //obtener el de abajo
              int b = m[i + 1][j];
              if (b == 1) {
                block.bottom = true;
              }
            } else {
              //otras columnas
              block.reinit();
              //obtener el de la izquierda
              int l = m[i][j - 1];
              int r = m[i][j + 1];
              int b = m[i + 1][j];

              if (l == 1) {
                block.left = true;
              }
              if (b == 1) {
                block.bottom = true;
              }
              if (r == 1) {
                block.right = true;
              }
            }
          } else if (i == m.length - 1) {
            //ultima fila
            if (j == 0) {
              //primera columna
              block.reinit();
              //obtener el de la derecha
              int r = m[i][j + 1];
              if (r == 1) {
                block.right = true;
              }
              //obtener el de arriba
              int t = m[i - 1][j];
              if (t == 1) {
                block.top = true;
              }
            } else if (j == row.length - 1) {
              //ultima columna
              block.reinit();
              //obtener el de la izquierda
              int l = m[i][j - 1];
              if (l == 1) {
                block.left = true;
              }
              //obtener el de arriba
              int t = m[i - 1][j];
              if (t == 1) {
                block.top = true;
              }
            } else {
              //otras columnas
              block.reinit();
              //obtener el de la izquierda
              int l = m[i][j - 1];
              int r = m[i][j + 1];
              int t = m[i - 1][j];

              if (l == 1) {
                block.left = true;
              }
              if (t == 1) {
                block.top = true;
              }
              if (r == 1) {
                block.right = true;
              }
            }
          } else {
            //otras filas
            if (j == 0) {
              //primera columna
              block.reinit();
              //obtener el de la arriba
              int t = m[i - 1][j];
              //derecha
              int r = m[i][j + 1];
              //abajo
              int b = m[i + 1][j];

              if (t == 1) {
                block.top = true;
              }

              if (r == 1) {
                block.right = true;
              }

              if (b == 1) {
                block.bottom = true;
              }
            } else if (j == row.length - 1) {
              //ultima columna
              block.reinit();
              //obtener el de la arriba
              int t = m[i - 1][j];
              //izquierda
              int l = m[i][j - 1];
              //abajo
              int b = m[i + 1][j];

              if (t == 1) {
                block.top = true;
              }

              if (l == 1) {
                block.left = true;
              }

              if (b == 1) {
                block.bottom = true;
              }
            } else {
              //otras columnas
              block.reinit();
              //obtener el de la arriba
              int t = m[i - 1][j];
              //izquierda
              int l = m[i][j - 1];
              //derecha
              int r = m[i][j + 1];
              //abajo
              int b = m[i + 1][j];

              if (t == 1) {
                block.top = true;
              }

              if (l == 1) {
                block.left = true;
              }

              if (b == 1) {
                block.bottom = true;
              }

              if (r == 1) {
                block.right = true;
              }
            }
          }
        }
        rb.add(block);
      }
      matrixVerify.add(rb);
    }

    print(matrixVerify);

    int counter = 1;

    for (int i = 0; i < matrixVerify.length; i++) {
      List<Block> row = matrixVerify[i];
      for (int j = 0; j < row.length; j++) {
        Block blk = row[j];
        if (blk.left as bool ||
            blk.right as bool ||
            blk.top as bool ||
            blk.bottom as bool) {
          print('[$i,$j] => true');

          matrixVerify[i][j].islandNumber = counter;

          if (blk.left as bool) {
            matrixVerify[i][j - 1].islandNumber = counter;
          }
          if (blk.right as bool) {
            matrixVerify[i][j + 1].islandNumber = counter;
          }
          if (blk.top as bool) {
            matrixVerify[i - 1][j].islandNumber = counter;
          }
          if (blk.bottom as bool) {
            matrixVerify[i + 1][j].islandNumber = counter;
          }
        }
      }
    }

    print(matrixVerify);

    //TODO incrementar el contador y luego sumar los que tengan mas de 1 bloque y sacar el numero de islas

    return ret;
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

class Block {
  late String? label;
  late bool? top;
  late bool? bottom;
  late bool? left;
  late bool? right;
  late int? islandNumber;

  Block() {
    label = null;
    top = false;
    bottom = false;
    left = false;
    right = false;
    islandNumber = null;
  }

  reinit() {
    top = false;
    bottom = false;
    left = false;
    right = false;
  }

  @override
  String toString() {
    return '{label:$label, t:$top, b:$bottom, l:$left, r:$right, n:$islandNumber}';
  }
}
