import 'package:flutter/material.dart';
import 'package:template/src/models/event.dart';

class EventService {
  // Mock data for events
  static final List<Event> _events = [
    Event(
      id: '1',
      title: 'Networking Event',
      description: 'Network with other female founders',
      date: DateTime.now().add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      color: Colors.pink,
    ),
    Event(
      id: '2',
      title: 'Investor Meeting',
      description: 'Pitch to potential investors',
      date: DateTime.now().add(const Duration(days: 7)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      color: Colors.purple,
    ),
    Event(
      id: '3',
      title: 'Workshop',
      description: 'Business strategy workshop',
      date: DateTime.now().add(const Duration(days: 10)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 0),
      color: Colors.blue,
    ),
  ];

  // Get all events
  List<Event> getAllEvents() {
    return _events;
  }

  // Get events for a specific day
  List<Event> getEventsForDay(DateTime day) {
    return _events.where((event) => 
      event.date.year == day.year && 
      event.date.month == day.month && 
      event.date.day == day.day
    ).toList();
  }

  // Get events for a specific month
  Map<DateTime, List<Event>> getEventsForMonth(DateTime month) {
    final Map<DateTime, List<Event>> eventMap = {};

    for (final event in _events) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      if (eventDate.month == month.month && eventDate.year == month.year) {
        if (eventMap[eventDate] == null) {
          eventMap[eventDate] = [];
        }
        eventMap[eventDate]!.add(event);
      }
    }

    return eventMap;
  }

  // Add an event
  void addEvent(Event event) {
    _events.add(event);
  }

  // Update an event
  void updateEvent(Event updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
    }
  }

  // Delete an event
  void deleteEvent(String id) {
    _events.removeWhere((event) => event.id == id);
  }
}