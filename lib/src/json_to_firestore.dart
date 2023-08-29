part of firestore_api_parser;

@visibleForTesting
Map<String, dynamic> toFirestoreDocumentFormat({required Map<String, dynamic> jsonMap}) {
  final data = {};

  for (var key in jsonMap.keys) {
    data[key] = getFirestoreRepresentation(jsonMap[key]);
  }

  final parsedFirestore = {'fields': data};

  return parsedFirestore;
}

@visibleForTesting
Map<String, dynamic> getFirestoreRepresentation(dynamic value) {
  if (value is String) {
    return stringDataRepresentation(value);
  } else if (value is DateTime) {
    return timestampDataRepresentation(value.toIso8601String());
  } else if (value is bool) {
    return boolDataRepresentation(value);
  } else if (value is int) {
    return intDataRepresentation(value);
  } else if (value is double) {
    return doubleDataRepresentation(value);
  } else if (value is Map) {
    if (value['latitude'] != null && value['longitude'] != null && value.keys.length == 2) {
      return geoPointDataRepresentation(value);
    } else {
      return mapDataRepresentation(value);
    }
  } else if (value is List) {
    return listDataRepresentation(value);
  } else if (value == null) {
    return nullDataRepresentation();
  } else {
    throw Exception("Type ${value.runtimeType} is not (for now) supported by our plugin.");
  }
}

@visibleForTesting
Map<String, dynamic> nullDataRepresentation() => {'nullValue': null};

@visibleForTesting
Map<String, dynamic> boolDataRepresentation(bool booleanValue) => {'booleanValue': booleanValue};

@visibleForTesting
Map<String, dynamic> geoPointDataRepresentation(Map geoPointValue) => {'geoPointValue': geoPointValue};

@visibleForTesting
Map<String, dynamic> timestampDataRepresentation(String timestampValue) => {'timestampValue': timestampValue};

@visibleForTesting
Map<String, dynamic> referenceDataRepresentation(String stringValue) => {'referenceValue': stringValue};

@visibleForTesting
Map<String, dynamic> mapDataRepresentation(Map mapValue) {
  var mapData = {};

  for (var entry in mapValue.entries) {
    final parsedEntryValue = getFirestoreRepresentation(entry.value);
    mapData[entry.key] = parsedEntryValue;
  }

  return {
    'mapValue': {'fields': mapData}
  };
}

@visibleForTesting
Map<String, dynamic> listDataRepresentation(List arrayValue) {
  var arrayData = [];

  for (var value in arrayValue) {
    final parsedValue = getFirestoreRepresentation(value);
    arrayData.add(parsedValue);
  }
  return {
    'arrayValue': {'values': arrayData}
  };
}

@visibleForTesting
Map<String, dynamic> stringDataRepresentation(String stringValue) => {'stringValue': stringValue};

@visibleForTesting
Map<String, dynamic> intDataRepresentation(int integerValue) => {'integerValue': '$integerValue'};

@visibleForTesting
Map<String, dynamic> doubleDataRepresentation(double doubleValue) => {'doubleValue': doubleValue};
