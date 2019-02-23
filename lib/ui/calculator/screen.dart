import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_news/bloc/bloc.dart';
import 'package:space_news/models/calculator/weight.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../bloc/calculator/bloc.dart';
import '../general/string_picker_tile.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  CalculatorScreenState createState() {
    return new CalculatorScreenState();
  }
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorBloc _bloc = CalculatorBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculatorBloc>(
      bloc: _bloc,
      child: new _Content(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class _Content extends StatefulWidget {
  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content> {
  @override
  Widget build(BuildContext context) {
    final CalculatorBloc _calcBloc = BlocProvider.of<CalculatorBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder(
          bloc: _calcBloc,
          builder: (BuildContext context, Calculator state) {
            return Stack(
              children: <Widget>[
                Positioned(
                  bottom: 0.0,
                  top: 20.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    child: FlareActor(
                      "assets/animations/planets.flr",
                      alignment: Alignment.topCenter,
                      fit: BoxFit.contain,
                      animation: state.planet,
                      callback: (string) {
                        debugPrint(string);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 150.0,
                  left: 10.0,
                  right: 10.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.remove, size: 40.0),
                              onPressed: () {
                                _calcBloc.dispatch(
                                  ChangeWeight(state.weight - 5),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                state.weight.round().toString() + " lbs",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.display1,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 40.0),
                              onPressed: () {
                                _calcBloc.dispatch(
                                  ChangeWeight(state.weight + 5),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 100.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _calcBloc.planets.length,
                          itemBuilder: (BuildContext context, int index) {
                            final p = _calcBloc.planets[index];
                            return InkWell(
                              onTap: () {
                                _calcBloc.dispatch(ChangePlanet(p));
                              },
                              child: SizedBox(
                                height: 100.0,
                                width: 100.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: FlareActor(
                                        "assets/animations/planets.flr",
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.contain,
                                        animation: p,
                                        callback: (string) {
                                          debugPrint(string);
                                        },
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(3.0),
                                        child: Text(p)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 75.0,
                    left: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              _calcBloc.currentState.planetWeightFormat,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display1,
                            ),
                            Text("Your Weight on ${state.planet}"),
                          ],
                        ),
                      ],
                    )),
              ],
            );
          }),
    );
  }
}
