import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:template/src/models/event.dart';
import 'package:template/src/services/event_service.dart';
import 'package:template/src/design_system/responsive_wrapper.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final EventService _eventService;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _events = _eventService.getEventsForMonth(_focusedDay);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Calendar'),
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _events = _eventService.getEventsForMonth(focusedDay);
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: TextStyle(
                  color: theme.colorScheme.primary,
                ),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: _buildEventList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              GoRouter.of(context).go('/dashboard');
              break;
            case 1:
              GoRouter.of(context).go('/resources');
              break;
            case 2:
              GoRouter.of(context).go('/calendar');
              break;
            case 3:
              GoRouter.of(context).go('/investors');
              break;
            case 4:
              GoRouter.of(context).go('/founders');
              break;
            case 5:
              GoRouter.of(context).go('/contact');
              break;
          }
        },
        selectedIndex: 2, // Calendar is selected
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            selectedIcon: Icon(Icons.attach_money),
            label: 'Investors',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Founders',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_support_outlined),
            selectedIcon: Icon(Icons.contact_support),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay);
    final formattedDate = DateFormat.yMMMMd().format(_selectedDay);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No events for $formattedDate',
              style: const TextStyle(fontSize: 18),
            ),
            const Gap(8),
            const Text(
              'Tap + to add a new event',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Events for $formattedDate',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Container(
                      width: 12,
                      height: double.infinity,
                      color: event.color,
                    ),
                    title: Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.description),
                        const Gap(4),
                        Text(
                          '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditEventDialog(event),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteEvent(event),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now().replacing(
      hour: (TimeOfDay.now().hour + 1) % 24,
    );
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                ),
                const Gap(16),
                Row(
                  children: [
                    const Text('Start Time: '),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setState(() {
                            startTime = time;
                          });
                        }
                      },
                      child: Text(startTime.format(context)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('End Time: '),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setState(() {
                            endTime = time;
                          });
                        }
                      },
                      child: Text(endTime.format(context)),
                    ),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    const Text('Event Color: '),
                    GestureDetector(
                      onTap: () {
                        _showColorPicker(selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  const uuid = Uuid();
                  final newEvent = Event(
                    id: uuid.v4(),
                    title: titleController.text,
                    description: descriptionController.text,
                    date: _selectedDay,
                    startTime: startTime,
                    endTime: endTime,
                    color: selectedColor,
                  );
                  _eventService.addEvent(newEvent);
                  _loadEvents();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEventDialog(Event event) {
    final titleController = TextEditingController(text: event.title);
    final descriptionController = TextEditingController(text: event.description);
    TimeOfDay startTime = event.startTime;
    TimeOfDay endTime = event.endTime;
    Color selectedColor = event.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                ),
                const Gap(16),
                Row(
                  children: [
                    const Text('Start Time: '),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (time != null) {
                          setState(() {
                            startTime = time;
                          });
                        }
                      },
                      child: Text(startTime.format(context)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('End Time: '),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (time != null) {
                          setState(() {
                            endTime = time;
                          });
                        }
                      },
                      child: Text(endTime.format(context)),
                    ),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    const Text('Event Color: '),
                    GestureDetector(
                      onTap: () {
                        _showColorPicker(selectedColor, (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final updatedEvent = Event(
                    id: event.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    date: _selectedDay,
                    startTime: startTime,
                    endTime: endTime,
                    color: selectedColor,
                  );
                  _eventService.updateEvent(updatedEvent);
                  _loadEvents();
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(Color initialColor, Function(Color) onColorSelected) {
    final List<Color> colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: Container(
          width: double.maxFinite,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  onColorSelected(color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color == initialColor 
                          ? Colors.white 
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _eventService.deleteEvent(event.id);
              _loadEvents();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}