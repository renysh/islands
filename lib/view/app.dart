import 'package:flutter/material.dart';
import 'dart:math';

// Unos juntos es isla
// solo un unico 1 no es isla

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int rows = 0;
  int columns = 0;
  int numberIslands = 0;
  List<int> matrixValues = [];
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
              onPress: (pair) async {
                if (pair.valid) {
                  setState(() {
                    rows = pair.rows;
                    columns = pair.columns;
                  });
                  await generateRandoms(rows * columns);
                  generateMatrixData(rows, columns);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Datos ingresados no validos!'),
                      duration: const Duration(milliseconds: 1500),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 15,
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: rows == 0 || columns == 0
                  ? const SizedBox.shrink()
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                      ),
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      itemCount: columns * rows,
                      /*itemBuilder: (BuildContext context, int index) {
                        return ret[index];
                      },*/
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: matrixValues[index] == 1
                                  ? Colors.greenAccent
                                  : Colors.white,
                            ),
                            child:
                                Center(child: Text('${matrixValues[index]}')),
                          ),
                          onTap: () {
                            setState(() {
                              if (matrixValues[index] == 0) {
                                matrixValues[index] = 1;
                              } else {
                                matrixValues[index] = 0;
                              }
                              generateMatrixData(rows, columns);
                            });
                          },
                        );
                      }

                      //children: generateMatrixData(rows, columns),
                      ),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'ISLAS: ${numberIslands.toString()}',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  generateRandoms(int numberElements) async {
    List<int> values = [];
    for (int i = 1; i <= numberElements; i++) {
      var n = Random().nextInt(2);
      values.add(n);
    }
    setState(() {
      matrixValues = values;
    });
  }

  generateMatrixData(int rows, int columns) {
    List<List<int>> m = [];

    /*List<int> aux = [
      0,
      0,
      1,
      0,
      1,
      1,
      1,
      1,
      0,
      1,
      0,
      0,
      1,
      1,
      1,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      0,
      0
    ];*/

    List<int> f = [];
    /*for (var i = 1; i <= aux.length; i++) {
      //print(aux[i]);
      f.add(aux[i - 1]);
      if (i % columns == 0) {
        m.add(f);
        f = [];
      }
      Widget w = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: aux[i - 1] == 1 ? Colors.greenAccent : Colors.white,
        ),
        child: Center(child: Text('${aux[i - 1]}')),
      );
      ret.add(w);
    }*/

    //print(m);

    for (int i = 1; i <= matrixValues.length; i++) {
      f.add(matrixValues[i - 1]);
      if (i % columns == 0) {
        m.add(f);
        f = [];
      }
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

    // print(matrixVerify);

    int counter = 1;
    // de izquierda a derecha
    for (int i = 0; i < matrixVerify.length; i++) {
      List<Block> row = matrixVerify[i];
      for (int j = 0; j < row.length; j++) {
        Block blk = row[j];
        if (blk.left as bool ||
            blk.right as bool ||
            blk.top as bool ||
            blk.bottom as bool) {
          if (matrixVerify[i][j].islandNumber == null) {
            matrixVerify[i][j].islandNumber = counter;
            counter++;
          }

          // matrixVerify[i][j].islandNumber = counter;

          if (blk.left as bool) {
            if (matrixVerify[i][j - 1].islandNumber == null) {
              matrixVerify[i][j - 1].islandNumber =
                  matrixVerify[i][j].islandNumber;
            } else {
              matrixVerify[i][j].islandNumber =
                  matrixVerify[i][j - 1].islandNumber;
            }
          }
          if (blk.right as bool) {
            if (matrixVerify[i][j + 1].islandNumber == null) {
              matrixVerify[i][j + 1].islandNumber =
                  matrixVerify[i][j].islandNumber;
            } else {
              matrixVerify[i][j].islandNumber =
                  matrixVerify[i][j + 1].islandNumber;
            }
          }
          if (blk.top as bool) {
            if (matrixVerify[i - 1][j].islandNumber == null) {
              matrixVerify[i - 1][j].islandNumber =
                  matrixVerify[i][j].islandNumber;
            } else {
              matrixVerify[i][j].islandNumber =
                  matrixVerify[i - 1][j].islandNumber;
            }
          }
          if (blk.bottom as bool) {
            if (matrixVerify[i + 1][j].islandNumber == null) {
              matrixVerify[i + 1][j].islandNumber =
                  matrixVerify[i][j].islandNumber;
            } else {
              matrixVerify[i][j].islandNumber =
                  matrixVerify[i + 1][j].islandNumber;
            }
          }
        } else {
          counter++;
          matrixVerify[i][j].islandNumber = counter;
          counter++;
        }
      }
    }

    // print('----------------');

    // print(transpuesta(matrixVerify));

    List<List<Block>> t1 = transpuesta(matrixVerify);
    t1 = verify(verifySidesTrans(t1));

    List<List<Block>> t2 = transpuesta(t1);
    t2 = verify(verifySidesTrans(t2));

    List<List<Block>> t3 = transpuesta(t2);
    t3 = verify(verifySidesTrans(t3));

    List<List<Block>> t4 = transpuesta(t3);
    t4 = verify(verifySidesTrans(t4));

    // barrer de derecha a izquierda casos en los que los 1 estan en las primeras columnas y los 1 de la anterior fila estan en las ultimas columnas
    /*for (int i = 0; i < matrixVerify.length; i++) {
      List<Block> row = matrixVerify[i];
      for (int j = row.length - 1; 0 <= j; j--) {
        print(row[j].islandNumber);
        Block blk = row[j];
        if (blk.bottom as bool) {
          matrixVerify[i + 1][j].islandNumber = matrixVerify[i][j].islandNumber;
        }
        if (blk.left as bool) {
          matrixVerify[i][j - 1].islandNumber = matrixVerify[i][j].islandNumber;
        }
        if (blk.right as bool) {
          matrixVerify[i][j + 1].islandNumber = matrixVerify[i][j].islandNumber;
        }
        if (blk.top as bool) {
          matrixVerify[i - 1][j].islandNumber = matrixVerify[i][j].islandNumber;
        }
      }
    }*/
    // incrementar el contador y luego sumar los que tengan mas de 1 bloque y sacar el numero de islas
    List<int> finalList = [];
    for (int i = 0; i < t4.length; i++) {
      for (var j = 0; j < t4[i].length; j++) {
        finalList.add(t4[i][j].islandNumber as int);
      }
    }
    // print(finalList);

    int counterIslands = 0;
    List<int> distincts = finalList.toSet().toList();
    for (int i = 0; i < distincts.length; i++) {
      if (countOccurrences(finalList, distincts[i]) > 1) {
        counterIslands++;
      }
    }
    // print('NUMERO DE ISLAS: $counterIslands');

    setState(() {
      numberIslands = counterIslands;
    });
  }

  int countOccurrences(List<int> list, int element) {
    if (list.isEmpty) {
      return 0;
    }

    var foundElements = list.where((e) => e == element);
    return foundElements.length;
  }

  List<List<Block>> transpuesta(List<List<Block>> base) {
    if (base.isNotEmpty) {
      // generar matriz vacia;
      int numberColumns = base[0].length;
      int numberRows = base.length;

      List<List<Block>> ret = [];

      for (int i = 0; i < numberColumns; i++) {
        List<Block> _row = [];
        for (int j = 0; j < numberRows; j++) {
          _row.add(Block());
        }
        ret.add(_row);
      }

      for (int i = 0; i < base.length; i++) {
        for (int j = 0; j < base[i].length; j++) {
          ret[j][i] = base[i][j];
        }
      }

      return ret;
    } else {
      return [];
    }
  }

  List<List<Block>> verify(List<List<Block>> list) {
    for (int i = 0; i < list.length; i++) {
      List<Block> row = list[i];
      for (int j = row.length - 1; 0 <= j; j--) {
        Block blk = row[j];
        if (blk.bottom as bool) {
          list[i + 1][j].islandNumber = list[i][j].islandNumber;
        }
        if (blk.left as bool) {
          list[i][j - 1].islandNumber = list[i][j].islandNumber;
        }
        if (blk.right as bool) {
          list[i][j + 1].islandNumber = list[i][j].islandNumber;
        }
        if (blk.top as bool) {
          list[i - 1][j].islandNumber = list[i][j].islandNumber;
        }
      }
    }
    return list;
  }

  verifySidesTrans(List<List<Block>> matrix) {
    for (int i = 0; i < matrix.length; i++) {
      List<Block> row = matrix[i];
      for (int j = 0; j < row.length; j++) {
        int currentNumber = int.parse(matrix[i][j].label as String);
        //evaluar los 1->tierra
        if (currentNumber == 1) {
          if (i == 0) {
            //primera fila
            if (j == 0) {
              //primera columna
              matrix[i][j].reinit();
              //obtener el de la derecha
              int r = int.parse(matrix[i][j + 1].label as String);
              if (r == 1) {
                matrix[i][j].right = true;
              }
              //obtener el de abajo
              int b = int.parse(matrix[i + 1][j].label as String);
              if (b == 1) {
                matrix[i][j].bottom = true;
              }
            } else if (j == row.length - 1) {
              //ultima columna
              matrix[i][j].reinit();
              //obtener el de la izquierda
              int l = int.parse(matrix[i][j - 1].label as String);
              if (l == 1) {
                matrix[i][j].left = true;
              }
              //obtener el de abajo
              int b = int.parse(matrix[i + 1][j].label as String);
              if (b == 1) {
                matrix[i][j].bottom = true;
              }
            } else {
              //otras columnas
              matrix[i][j].reinit();
              //obtener el de la izquierda
              int l = int.parse(matrix[i][j - 1].label as String);
              int r = int.parse(matrix[i][j + 1].label as String);
              int b = int.parse(matrix[i + 1][j].label as String);

              if (l == 1) {
                matrix[i][j].left = true;
              }
              if (b == 1) {
                matrix[i][j].bottom = true;
              }
              if (r == 1) {
                matrix[i][j].right = true;
              }
            }
          } else if (i == matrix.length - 1) {
            //ultima fila
            if (j == 0) {
              //primera columna
              matrix[i][j].reinit();
              //obtener el de la derecha
              int r = int.parse(matrix[i][j + 1].label as String);
              if (r == 1) {
                matrix[i][j].right = true;
              }
              //obtener el de arriba
              int t = int.parse(matrix[i - 1][j].label as String);
              if (t == 1) {
                matrix[i][j].top = true;
              }
            } else if (j == row.length - 1) {
              //ultima columna
              matrix[i][j].reinit();
              //obtener el de la izquierda
              int l = int.parse(matrix[i][j - 1].label as String);
              if (l == 1) {
                matrix[i][j].left = true;
              }
              //obtener el de arriba
              int t = int.parse(matrix[i - 1][j].label as String);
              if (t == 1) {
                matrix[i][j].top = true;
              }
            } else {
              //otras columnas
              matrix[i][j].reinit();
              //obtener el de la izquierda
              int l = int.parse(matrix[i][j - 1].label as String);
              int r = int.parse(matrix[i][j + 1].label as String);
              int t = int.parse(matrix[i - 1][j].label as String);

              if (l == 1) {
                matrix[i][j].left = true;
              }
              if (t == 1) {
                matrix[i][j].top = true;
              }
              if (r == 1) {
                matrix[i][j].right = true;
              }
            }
          } else {
            //otras filas
            if (j == 0) {
              //primera columna
              matrix[i][j].reinit();
              //obtener el de la arriba
              int t = int.parse(matrix[i - 1][j].label as String);
              //derecha
              int r = int.parse(matrix[i][j + 1].label as String);
              //abajo
              int b = int.parse(matrix[i + 1][j].label as String);

              if (t == 1) {
                matrix[i][j].top = true;
              }

              if (r == 1) {
                matrix[i][j].right = true;
              }

              if (b == 1) {
                matrix[i][j].bottom = true;
              }
            } else if (j == row.length - 1) {
              //ultima columna
              matrix[i][j].reinit();
              //obtener el de la arriba
              int t = int.parse(matrix[i - 1][j].label as String);
              //izquierda
              int l = int.parse(matrix[i][j - 1].label as String);
              //abajo
              int b = int.parse(matrix[i + 1][j].label as String);

              if (t == 1) {
                matrix[i][j].top = true;
              }

              if (l == 1) {
                matrix[i][j].left = true;
              }

              if (b == 1) {
                matrix[i][j].bottom = true;
              }
            } else {
              //otras columnas
              matrix[i][j].reinit();
              //obtener el de la arriba
              int t = int.parse(matrix[i - 1][j].label as String);
              //izquierda
              int l = int.parse(matrix[i][j - 1].label as String);
              //derecha
              int r = int.parse(matrix[i][j + 1].label as String);
              //abajo
              int b = int.parse(matrix[i + 1][j].label as String);

              if (t == 1) {
                matrix[i][j].top = true;
              }

              if (l == 1) {
                matrix[i][j].left = true;
              }

              if (b == 1) {
                matrix[i][j].bottom = true;
              }

              if (r == 1) {
                matrix[i][j].right = true;
              }
            }
          }
        }
      }
    }
    return matrix;
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onPress(
                  PairData(
                    valid: _rowsController.text.isNotEmpty &&
                        _columnsController.text.isNotEmpty &&
                        int.parse(_rowsController.text) > 0 &&
                        int.parse(_columnsController.text) > 0,
                    rows: _rowsController.text.isEmpty
                        ? 0
                        : int.parse(_rowsController.text),
                    columns: _columnsController.text.isEmpty
                        ? 0
                        : int.parse(_columnsController.text),
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
  final bool valid;

  PairData({required this.rows, required this.columns, required this.valid});

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
