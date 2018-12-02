import 'dart:convert';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;

import '../../util/url.dart';
import '../querry_model.dart';
import 'vehicle_details.dart';

/// CORE DETAILS MODEL
/// Details about a specific core or booster used in a specific mission
class CoreModel extends QuerryModel {
  // Core serial: B000
  final String id;

  CoreModel(this.id);

  @override
  Future loadData() async {
    // Get item by http call
    response = await http.get(Url.coreDialog + id);

    // Clear old data
    clearItems();

    // Added parsed item
    items.add(CoreDetails.fromJson(json.decode(response.body)));

    // Adds photos & shuffle them
    photos.addAll(Url.spacexCoreDialog);
    photos.shuffle();

    // Finished with loading data
    loadingState(false);
  }

  CoreDetails get core => items[0];
}

class CoreDetails extends VehicleDetails {
  final int block, rtlsLandings, rtlsAttempts, asdsLandings, asdsAttempts;

  CoreDetails({
    serial,
    status,
    details,
    firstLaunched,
    missions,
    this.block,
    this.rtlsLandings,
    this.rtlsAttempts,
    this.asdsLandings,
    this.asdsAttempts,
  }) : super(
          serial: serial,
          status: status,
          details: details,
          firstLaunched: firstLaunched,
          missions: missions,
        );

  factory CoreDetails.fromJson(Map<String, dynamic> json) {
    return CoreDetails(
      serial: json['core_serial'],
      status: json['status'],
      details: json['details'],
      firstLaunched: DateTime.parse(json['original_launch']).toLocal(),
      missions: json['missions']
          .map((mission) => DetailsMission.fromJson(mission))
          .toList(),
      block: json['block'],
      rtlsLandings: json['rtls_landings'],
      rtlsAttempts: json['rtls_attempts'],
      asdsLandings: json['asds_landings'],
      asdsAttempts: json['asds_attempts'],
    );
  }

  String getDetails(context) =>
      details ??
      FlutterI18n.translate(
        context,
        'spacex.dialog.vehicle.no_description_core',
      );

  String getBlock(context) => block == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : FlutterI18n.translate(
          context,
          'spacex.other.block',
          {'block': block.toString()},
        );

  String get getRtlsLandings => '$rtlsLandings/$rtlsAttempts';

  String get getAsdsLandings => '$asdsLandings/$asdsAttempts';
}
