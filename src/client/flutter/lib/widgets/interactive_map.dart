import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class InteractiveMap extends StatelessWidget {
  final List<ModelInterativeMap> datas;
  final String modelPath;
  late final MapShapeSource _mapSource;

  InteractiveMap({
    Key? key,
    required this.modelPath,
    required this.datas,
  }) : super(key: key) {
    _mapSource = MapShapeSource.asset(
      modelPath,
      shapeDataField: 'nom',
      dataCount: datas.length,
      primaryValueMapper: (int index) => datas[index].name,
      dataLabelMapper: (int index) => datas[index].code,
      shapeColorValueMapper: (int index) => datas[index].color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfMaps(
      layers: <MapShapeLayer>[
        MapShapeLayer(
          source: _mapSource,
          showDataLabels: true,
          legend: const MapLegend(MapElement.shape),
          tooltipSettings: MapTooltipSettings(
            color: Colors.grey[700],
            strokeColor: Colors.white,
            strokeWidth: 2,
          ),
          strokeColor: Colors.white,
          strokeWidth: 0.5,
          shapeTooltipBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                datas[index].name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          dataLabelSettings: MapDataLabelSettings(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.caption!.fontSize,
            ),
          ),
        ),
      ],
    );
  }

}

class ModelInterativeMap {
  final String name;
  final Color color;
  final String code;

  const ModelInterativeMap({
    required this.name,
    required this.color,
    required this.code,
  });
}
