import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:row_collection/row_collection.dart';

import '../../../data/models/spacex/landpad.dart';
import '../../general/expand_widget.dart';
import '../../general/row_item.dart';
import '../../general/scroll_page.dart';

/// LANDPAD PAGE VIEW
/// This view displays information about a specific landpad,
/// where rockets now land.
class LandpadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LandpadModel>(
      builder: (context, model, child) => Scaffold(
            body: ScrollPage<LandpadModel>.map(
              title: model.id,
              coordinates: model.landpad.coordinates,
              children: <Widget>[
                SliverToBoxAdapter(child: _buildBody()),
              ],
            ),
          ),
    );
  }

  Widget _buildBody() {
    return Consumer<LandpadModel>(
      builder: (context, model, child) => RowLayout.body(children: <Widget>[
            Text(
              model.landpad.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            RowText(
              FlutterI18n.translate(
                context,
                'spacex.dialog.pad.status',
              ),
              model.landpad.getStatus,
            ),
            RowText(
              FlutterI18n.translate(
                context,
                'spacex.dialog.pad.location',
              ),
              model.landpad.location,
            ),
            RowText(
              FlutterI18n.translate(
                context,
                'spacex.dialog.pad.state',
              ),
              model.landpad.state,
            ),
            RowText(
              FlutterI18n.translate(
                context,
                'spacex.dialog.pad.coordinates',
              ),
              model.landpad.getCoordinates,
            ),
            RowText(
              FlutterI18n.translate(
                context,
                'spacex.dialog.pad.landing_type',
              ),
              model.landpad.type,
            ),
            RowText(
              FlutterI18n.translate(
                context,
                'spacex.dialog.pad.landings_successful',
              ),
              model.landpad.getSuccessfulLandings,
            ),
            Separator.divider(),
            TextExpand(model.landpad.details)
          ]),
    );
  }
}
