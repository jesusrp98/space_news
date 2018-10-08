import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:space_news/models/rockets/launch.dart';
import 'package:space_news/scoped_model/launches_latest.dart';
import 'package:space_news/screens/tabs/space_x/launch_page.dart';
import 'package:space_news/widgets/hero_image.dart';
import 'package:space_news/widgets/list_cell.dart';

class LaunchesLatestTab extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<Null> _onRefresh(LaunchesLatestModel model) {
    Completer<Null> completer = Completer<Null>();
    model.refresh().then((_) => completer.complete());
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LaunchesLatestModel>(
      builder: (context, child, model) =>
          ScopedModelDescendant<LaunchesLatestModel>(
            builder: (context, child, model) => SafeArea(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () => _onRefresh(model),
                    child: model.isLoading
                        ? NativeLoadingIndicator(
                            center: true,
                            text: const Text('Loading'),
                          )
                        : ListView.builder(
                            key: PageStorageKey('latest'),
                            itemCount: model.getSize,
                            itemBuilder: _buildItem,
                          ),
                  ),
                ),
          ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        ScopedModelDescendant<LaunchesLatestModel>(
          builder: (context, child, model) {
            final Launch launch = model.list[index];
            return Column(
              children: <Widget>[
                ListCell(
                  leading: HeroImage().buildHero(
                    context: context,
                    size: HeroImage.smallSize,
                    url: launch.getImageUrl,
                    tag: launch.getNumber,
                    title: launch.name,
                  ),
                  title: launch.name,
                  subtitle: launch.getLaunchDate,
                  trailing: MissionNumber(launch.getNumber),
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LaunchPage(launch)),
                      ),
                ),
                const Divider(height: 0.0, indent: 104.0)
              ],
            );
          },
        )
      ],
    );
  }
}
