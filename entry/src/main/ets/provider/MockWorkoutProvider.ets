import { WorkoutSession } from '../model/WorkoutSession';

export class MockWorkoutProvider {
  static getCurrentSession(): WorkoutSession {
    return {
      id: 'WS-001',
      type: 'Outdoor Run',
      durationMinutes: 32,
      calories: 287,
      heartRate: 142,
      distanceKm: 4.2
    };
  }
}