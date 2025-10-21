import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/src/events/event.dart';
import 'package:infinite_calendar_view/src/utils/extension.dart';

/// find event must be showed, and place multi day event in same row
List<List<Event?>> getShowedWeekEvents(
  List<List<Event>?> weekEvents,
  int maxEventsShowed,
) {
  var sortedMultiDayEvents = getWeekMultiDaysEventsSortedMap(weekEvents);

  // place no multi days events to show
  List<List<Event?>> daysEventsList = List.generate(7, (index) {
    var events = (weekEvents[index] ?? []).where((e) => !e.isMultiDay);
    return List.generate(maxEventsShowed, (i) => events.getOrNull(i));
  });

  for (var multiDayEvents in sortedMultiDayEvents.values) {
    var dayPlacedEvents = daysEventsList[multiDayEvents.keys.first];
    var eventToPlace = multiDayEvents.values.first;
    var index = 0;
    // compute index to place line
    while (index < dayPlacedEvents.length && dayPlacedEvents[index] != null) {
      var placedEvent = dayPlacedEvents[index]!;
      if (eventToPlace.startTime.millisecondsSinceEpoch >
          placedEvent.startTime.millisecondsSinceEpoch) {
        index++;
      } else {
        break;
      }
    }


// place all line
if (index < maxEventsShowed) {
  for (var eventToPlace in multiDayEvents.entries) {
    var dayEvents = daysEventsList[eventToPlace.key];
    
    // insert 대신 기존 null 항목을 교체
    if (index < dayEvents.length && dayEvents[index] == null) {
      dayEvents[index] = eventToPlace.value;
    } else if (index < maxEventsShowed - 1) {
      // 중간 삽입이 필요한 경우에만 insert 사용
      // 단, 배열 길이가 maxEventsShowed를 초과하지 않도록 제한
      if (dayEvents.length >= maxEventsShowed) {
        dayEvents.removeLast();
      }
      dayEvents.insert(index, eventToPlace.value);
    }
  }
}
  }
  return daysEventsList;
}

// generate sorted map of all multi days events on week
SplayTreeMap<UniqueKey, Map<int, Event>> getWeekMultiDaysEventsSortedMap(
    List<List<Event>?> weekEvents) {
  // generate map of all multi days events
  Map<UniqueKey, Map<int, Event>> multiDaysEventsMap = {};
  for (var day = 0; day < 7; day++) {
    var multiDaysEvents = weekEvents[day]?.where((e) => e.isMultiDay);
    for (Event event in multiDaysEvents ?? []) {
      multiDaysEventsMap[event.uniqueId] = {
        ...multiDaysEventsMap[event.uniqueId] ?? {},
        day: event
      };
    }
  }

  // sort multi days events
  final sortedMultiDayEvents = SplayTreeMap<UniqueKey, Map<int, Event>>.from(
    multiDaysEventsMap,
    (a, b) {
      var eventA = multiDaysEventsMap[a]!.values.first;
      var eventB = multiDaysEventsMap[b]!.values.first;
      return eventA.startTime.compareTo(
        eventB.startTime,
      );
    },
  );

  return sortedMultiDayEvents;
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.addCalendarDays(i));
  }
  return days;
}
