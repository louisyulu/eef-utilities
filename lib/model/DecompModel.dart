import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';
import '../spline/Spline.dart';
import '../analysis/Decomposition.dart';

class DecompModel extends ChangeNotifier {
  SplineType _splineType = SplineType.quinticSpline;
  late List<double> xs;
  late List<double> ys;
  List<double> y0d0 = [];
  List<double> yNdN = [];
  int _maxComponents = 3; // max number of components
  bool _useInflexion = true; // use inflection points or extrama
  bool _adjustEnds = true; // adjust end points

  bool _showData = true;
  bool _showControlPoints = false;
  bool _showTrend = true;
  bool _showIMF = true;

  List<Decomposition> decompList = [];

  SplineType get splineType => _splineType;
  set splineType(SplineType value) {
    _splineType = value;
    notifyListeners();
  }

  int get maxComponents => _maxComponents;
  set maxComponents(int value) {
    _maxComponents = value;
    notifyListeners();
  }

  bool get useInflexion => _useInflexion;
  set useInflexion(bool value) {
    _useInflexion = value;
    notifyListeners();
  }

  bool get adjustEnds => _adjustEnds;
  set adjustEnds(bool value) {
    _adjustEnds = value;
    notifyListeners();
  }

  bool get showData => _showData;
  set showData(bool value) {
    _showData = value;
    notifyListeners();
  }

  bool get showControlPoints => _showControlPoints;
  set showControlPoints(bool value) {
    _showControlPoints = value;
    notifyListeners();
  }

  bool get showTrend => _showTrend;
  set showTrend(bool value) {
    _showTrend = value;
    notifyListeners();
  }

  bool get showIMF => _showIMF;
  set showIMF(bool value) {
    _showIMF = value;
    notifyListeners();
  }

  void setDefaults() {
    _splineType = SplineType.quinticSpline;
    _maxComponents = 5;
    _useInflexion = true;
    _adjustEnds = true;
    _showData = true;
    _showControlPoints = false;
    _showTrend = true;
    _showIMF = true;
    notifyListeners();
  }

  void decompose() async {
    decompList = await compute(
        _buildDecompList,
        Tuple7<List<double>, List<double>, int, List<double>, List<double>,
                bool, SplineType>(
            xs, ys, maxComponents, y0d0, yNdN, adjustEnds, splineType));
    notifyListeners();
  }
}

List<Decomposition> _buildDecompList(
    Tuple7<List<double>, List<double>, int, List<double>, List<double>, bool,
            SplineType>
        model) {
  List<Decomposition> decompList = [];
  List<double> ys = model.item2;
  for (int i = 0; i < model.item3; i++) {
    final decomp = Decomposition(model.item1, ys, model.item4, model.item5);
    decomp.adjustEnds = model.item6;
    decomp.separate(model.item7);
    decompList.add(decomp);
    ys = decomp.trend;
  }
  return decompList;
}
