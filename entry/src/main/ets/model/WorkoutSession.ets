export interface WorkoutSession {
  id: string;
  type: string;
  durationMinutes: number;
  calories: number;
  heartRate: number;
  distanceKm: number;
}