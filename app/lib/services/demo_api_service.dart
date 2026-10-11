import 'api_service.dart';

/// Presentation-only data. No network requests and no persistent storage.
class DemoApiService extends ApiService {
  DemoApiService() : super(() => null);
  final _sessions = <String, List<String>>{};
  final _turns = <String, Map<String, dynamic>>{};
  @override
  bool get isDemo => true;
  @override
  Future<List<Map<String, dynamic>>> getOpportunities() async => [
        for (final (title, host, category, time, location, description) in [
          (
            'Lend a hand at a community garden',
            'Neighborhood garden team',
            'Volunteer',
            'Weekend mornings',
            'In person',
            'Help plant, water, and care for a shared green space.'
          ),
          (
            'Pack meals for neighbors',
            'Community pantry',
            'Volunteer',
            '2-hour shifts',
            'In person',
            'Sort donations and prepare food packages with other volunteers.'
          ),
          (
            'Be a friendly check-in buddy',
            'Neighbor connection group',
            'Volunteer',
            'Flexible schedule',
            'Remote',
            'Make time for someone who could use company.'
          ),
          (
            'Help with a small yard project',
            'Community member',
            'Odd jobs',
            'One-time task',
            'In person',
            'Offer a helping hand with light yard work.'
          ),
          (
            'Share your knowledge with a learner',
            'Community member',
            'Tutoring',
            'Flexible schedule',
            'Remote or in person',
            'Help someone practice a subject you know.'
          ),
          (
            'Take a neighbor’s dog for a walk',
            'Community member',
            'Pet care',
            'Short visits',
            'In person',
            'Offer local dog walks or pet check-ins.'
          )
        ])
          {
            'title': title,
            'host': host,
            'category': category,
            'time': time,
            'location': location,
            'description': description,
            'isDemo': true
          }
      ];
  @override
  Future<Map<String, dynamic>> chat(
      {required String conversationId,
      required String turnId,
      required String message}) async {
    final key = '$conversationId:$turnId';
    if (_turns.containsKey(key)) return _turns[key]!;
    final messages = _sessions.putIfAbsent(conversationId, () => []);
    messages.add(message);
    final step = messages.length;
    final response = <String, dynamic>{
      'revision': step,
      'assistantMessage': step == 1
          ? 'Let’s make that easier. When would you like help? For this demo, try “Saturday morning”.'
          : step == 2
              ? 'Where should the help happen? Tell me your general area, or say “Remote”.'
              : 'Here’s your demo request. Review the details below. You can confirm to preview the next step; nothing will be published or sent to volunteers.',
      'draft': {
        'title': 'Community help request',
        'description': messages.first,
        'category': 'Community support',
        'timing': step >= 2 ? messages[1] : null,
        'location': step >= 3 ? messages[2] : null,
        'supportMode': 'To be agreed',
        'skillsNeeded': <String>[],
        'evidence': <dynamic>[]
      },
      'missingFields': [
        if (step < 2) 'timing',
        if (step < 3) 'location or remote preference'
      ]
    };
    if (step > 3) {
      (response['draft'] as Map<String, dynamic>)['description'] =
          '${messages.first}\nAdditional details: ${messages.skip(3).join('; ')}';
    }
    _turns[key] = response;
    return response;
  }

  @override
  Future<Map<String, dynamic>> confirmRequest(String id, int revision) async =>
      {
        'request': {'id': id, 'isDemo': true}
      };
}
