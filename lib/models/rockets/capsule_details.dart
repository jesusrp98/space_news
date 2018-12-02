import 'dart:convert';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;

import '../../util/url.dart';
import '../querry_model.dart';
import 'vehicle_details.dart';

/// CAPSULE DETAILS MODEL
/// Details about a specific Dragon used in a NASA mission
class CapsuleModel extends QuerryModel {
  // Capsule serial: C000
  final String id;

  CapsuleModel(this.id);

  @override
  Future loadData() async {
    // Get item by http call
    response = await http.get(Url.capsuleDialog + id);

    // Clear old data
    clearItems();

    // Added parsed item
    items.add(CapsuleDetails.fromJson(json.decode(response.body)));

    // Adds photos & shuffle them
    photos.addAll(Url.spacexCapsuleDialog);
    photos.shuffle();

    // Finished with loading data
    loadingState(false);
  }

  CapsuleDetails get capsule => items[0];
}

class CapsuleDetails extends VehicleDetails {
  final String name;
  final int landings;

  CapsuleDetails({
    serial,
    status,
    details,
    firstLaunched,
    missions,
    this.name,
    this.landings,
  }) : super(
          serial: serial,
          status: status,
          details: details,
          firstLaunched: firstLaunched,
          missions: missions,
        );

  factory CapsuleDetails.fromJson(Map<String, dynamic> json) {
    return CapsuleDetails(
      serial: json['capsule_serial'],
      status: json['status'],
      details: json['details'],
      firstLaunched: DateTime.parse(json['original_launch']).toLocal(),
      missions: json['missions']
          .map((mission) => DetailsMission.fromJson(mission))
          .toList(),
      name: json['type'],
      landings: json['landings'],
    );
  }

  String getDetails(context) =>
      details ??
      FlutterI18n.translate(
        context,
        'spacex.dialog.vehicle.no_description_capsule',
      );

  String get getLandings => landings.toString();
}
