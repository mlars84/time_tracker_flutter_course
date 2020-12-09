import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

void main() {
  group('fromMap', () {
    test('Returns null if data is null', () {
      final job = Job.fromMap(null, 'abc');

      expect(job, null);
    });

    test('Returns Job with id set from documentId when data is not null', () {
      Map<String, dynamic> data = {'name': 'test'};

      final job = Job.fromMap(data, 'abc');

      expect(job.id, 'abc');
    });

    test('Returns Job with all properties', () {
      Map<String, dynamic> data = {'name': 'Test', 'ratePerHour': 15};

      final job = Job.fromMap(data, 'abc');

      expect(job.name, data['name']);
      expect(job, Job(name: 'Test', ratePerHour: 15, id: 'abc'));
    });

    test('Null name check', () {
      final job = Job.fromMap({'ratePerHour': 15}, 'abc');

      expect(job, null);
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(id: 'abc', name: 'Test', ratePerHour: 15);

      expect(job.toMap(), {'name': 'Test', 'ratePerHour': 15});
    });
  });
}
