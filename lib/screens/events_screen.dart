import 'package:flutter/material.dart';
import 'package:hackathons_lk_app/sections/all_events_section.dart';
import 'package:hackathons_lk_app/sections/ended_events_section.dart';
import 'package:hackathons_lk_app/sections/upcoming_events_section.dart';
import 'package:hackathons_lk_app/services/api_data.dart';
import 'package:hackathons_lk_app/services/scroll_glow_disabler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Future<List<Data>> eventData;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    // eventData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Hackathon.lk logo -------------------------------------------------------------------------------
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Image.asset(
                'lib/assets/Hackathons.lk-logo-black.png',
                width: 220,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Flexible(
              child: ScrollGlowDisabler(
                  //* Top Tab Bar ------------------------------------------------------------------------------
                  child: DefaultTabController(
                length: 3, // length of tabs
                initialIndex: 0,
                child: Container(
                  height: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        //* Tab bar customize
                        child: TabBar(
                          isScrollable: false,
                          indicatorColor: Colors.transparent,
                          labelColor: Colors.black,
                          unselectedLabelColor: Color(0xffA4A4A4),
                          labelStyle: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          unselectedLabelStyle: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          tabs: [
                            Tab(text: 'All'),
                            Tab(text: 'Upcoming'),
                            Tab(text: 'Ended'),
                          ],
                          onTap: (index) {
                            setState(() {
                              _tabIndex = index;
                            });
                            //* All events scroll to top
                            if (allEventsScrollController.hasClients)
                              allEventsScrollController.animateTo(
                                allEventsScrollController
                                    .position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );

                            //* Ended events scroll to top
                            if (endedEventsScrollController.hasClients)
                              endedEventsScrollController.animateTo(
                                endedEventsScrollController
                                    .position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );

                            //* Upcoming events scroll to top
                            if (upcomingEventsScrollController.hasClients)
                              upcomingEventsScrollController.animateTo(
                                upcomingEventsScrollController
                                    .position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        //* Tab Content
                        child: Container(
                          height: 500,
                          child: IndexedStack(
                            index: _tabIndex,
                            children: <Widget>[
                              AllEventsSection(
                                eventData: eventData,
                              ), //* All Events Section
                              UpcomingEventsSection(
                                eventData: eventData,
                              ), //* Upcoming Events Section
                              EndedEventsSection(
                                eventData: eventData,
                              ), //* Ended Events Section
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
