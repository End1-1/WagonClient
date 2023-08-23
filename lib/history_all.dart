import 'package:flutter/material.dart';
import 'package:wagon_client/model/tr.dart';
import 'package:wagon_client/preorders.dart';
import 'package:wagon_client/web/web_history.dart';
import 'package:wagon_client/web/web_parent.dart';
import 'package:wagon_client/web/web_preorders.dart';

import 'consts.dart';
import "dlg.dart";
import 'history_list.dart';
import 'history_order.dart';

class HistoryAll extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HistoryAllState();
  }
}

class HistoryAllState extends State<HistoryAll> with TickerProviderStateMixin {
  int _skipHistory = 0;
  int _takeHistory = 10;
  int _skipPreorders = 0;
  int _takePreorders = 10;
  bool _isLoading = false;
  HistoryList _historyList = HistoryList([]);
  PreordersList _preordersList = PreordersList([]);
  bool _btnEnabled = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _historyList.mode = 0;
    _skipHistory = 0;
    _historyList.list.clear();
    loadHistory();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_isLoading) {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      switch (_tabController.index) {
        case 0:
          loadHistory();
          break;
        case 1:
          loadPreorders();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Column(children: [
                  Column(children: [
                    Divider(
                      color: Colors.transparent,
                      height: 5,
                    ),
                    Row(children: [
                      IconButton(
                          icon: Image.asset(
                            "images/back.png",
                            height: 20,
                            width: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Text(tr(trORDERSHISTORY).toUpperCase())
                    ]),
                    Container(
                        height: 5,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xffcccccc), Colors.white]))),
                  ]),
                  AbsorbPointer(
                      absorbing: _isLoading,
                      child: Container(
                          child: DefaultTabController(
                              length: 2,
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: Consts.colorFiolet,
                                tabs: [
                                  Tab(
                                      child: Text(tr(trOrders),
                                          style: TextStyle(
                                              color: Consts.colorFiolet))),
                                  Tab(
                                      child: Text(tr(trPreorders),
                                          style: TextStyle(
                                              color: Consts.colorFiolet)))
                                ],
                              )))),
                  _isLoading ? Expanded(child: Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()))) : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _historyList.list.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            Widget w;
                            if (index < _historyList.list.length) {
                              w = GestureDetector(
                                  onTap: () {
                                    _callHistoryDetails(
                                        _historyList.list[index].order_id);
                                  },
                                  child: Wrap(
                                    children: [
                                      Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, top: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                child: Image.asset(
                                                  "images/calendar.png",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              Text(_historyList
                                                  .list[index].started),
                                              Expanded(child: Container()),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                              ),
                                              Text(
                                                  _historyList.list[index].cost
                                                      .toString(),
                                                  style: Consts.textStyle22)
                                            ],
                                          )),
                                      Divider(color: Colors.black26),
                                      Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "images/od_black.png",
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  Divider(
                                                      height: 2,
                                                      color:
                                                          Colors.transparent),
                                                  Image.asset(
                                                    "images/line.png",
                                                    width: 10,
                                                    height: 30,
                                                  ),
                                                  Divider(
                                                      height: 2,
                                                      color:
                                                          Colors.transparent),
                                                  Image.asset(
                                                    "images/od_red.png",
                                                    width: 15,
                                                    height: 15,
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          left: 2),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _historyList
                                                                  .list[index]
                                                                  .ordered_from,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Divider(
                                                              color: Colors
                                                                  .black26,
                                                              height: 30,
                                                            ),
                                                            Text(
                                                              _historyList
                                                                  .list[index]
                                                                  .ordered_to,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          ]))),
                                            ],
                                          )),
                                      Divider(
                                        color: Colors.black26,
                                        thickness: 1,
                                      )
                                    ],
                                  ));
                            } else {
                              w = Visibility(
                                  visible: _btnEnabled,
                                  child: TextButton(
                                      onPressed: () {
                                        loadHistory();
                                      },
                                      child: Text(tr(trLoadMore),
                                          style: TextStyle(
                                              color: Consts.colorFiolet))));
                            }
                            return w;
                          })),
                ]))));
  }

  void loadHistory() {
    WebHistory webHistory = WebHistory(_skipHistory, _takeHistory);
    webHistory.request((mp) {
      setState(() {
        _isLoading = false;
        _btnEnabled = false;
        Map<String, dynamic> d = Map();
        d["list"] = mp;
        HistoryList l = HistoryList.fromJson(d);
        _preordersList.list.clear();
        //if (_historyList.mode == 1) {
        _historyList.list.clear();
        //}
        _historyList.list.addAll(l.list);
        _historyList.mode = 0;
        _skipHistory += l.list.length;
        _btnEnabled = _historyList.list.length % 10 == 0;
      });
    }, (c, s) {
      _isLoading = false;
      Dlg.show(context, s);
      _btnEnabled = true;
    });
  }

  void loadPreorders() {
    WebPreorders.get(_skipPreorders, _takePreorders, (mp) {
      setState(() {
        _isLoading = false;
        Map<String, dynamic> d = Map();
        d["list"] = mp;
        PreordersList preordersList = PreordersList.fromJson(d);
        _historyList.list.clear();
        _preordersList.list.clear();
        _preordersList.list.addAll(preordersList.list);
        for (Preorder p in preordersList.list) {
          History h = History(
              p.order_id, p.addresses.from, p.addresses.to, 0, p.time.start);
          h.cost = p.price;
          _historyList.list.add(h);
        }
        _historyList.mode = 1;
        _skipHistory = 0;
        _btnEnabled = false;
      });
    }, () {
      _isLoading = false;
    });
  }

  void _callHistoryDetails(int id) {
    if (_historyList.mode == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HistoryOrder(orderId: id)));
    } else {
      Dlg.question(context, tr(trConfirmToRemovePreorder))
          .then((value) {
        if (value) {
          WebParent wp = WebParent(
              "/app/mobile/preorder/" + id.toString(), HttpMethod.DELE);
          wp.request((mp) {
            loadPreorders();
          }, (c, s) {
            Dlg.show(context, s);
          });
        }
      });
    }
  }
}
