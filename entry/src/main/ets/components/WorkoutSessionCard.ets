import { WorkoutSession } from '../model/WorkoutSession';
import { AppColor, AppSize } from '../theme/AppTheme';

@Component
export struct WorkoutSessionCard {
  @Prop session: WorkoutSession;

  build() {
    Column({ space: 10 }) {
      Text(this.session.type)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColor.TEXT_PRIMARY)

      Row() {
        this.metric(`${this.session.durationMinutes}`, 'min')
        this.metric(`${this.session.distanceKm}`, 'km')
      }.width('100%').justifyContent(FlexAlign.SpaceEvenly)

      Row() {
        this.metric(`${this.session.calories}`, 'kcal')
        this.metric(`${this.session.heartRate}`, 'bpm')
      }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14, left: 12, right: 12 })
    .borderRadius(AppSize.RADIUS_CARD)
    .backgroundColor(AppColor.SURFACE)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  metric(value: string, unit: string) {
    Column({ space: 2 }) {
      Text(value).fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColor.ACCENT)
      Text(unit).fontSize(10).fontColor(AppColor.TEXT_SECONDARY)
    }
  }
}