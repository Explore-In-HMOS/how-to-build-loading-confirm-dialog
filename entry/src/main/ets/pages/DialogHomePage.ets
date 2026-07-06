import { NavigationService, Page } from '../services/NavigationService';
import { AppColor, AppSize, AppSpacing } from '../theme/AppTheme';

@Component
export struct DialogHomePage {
  navigationService: NavigationService = NavigationService.getInstance();

  private navigate(name: string): void {
    this.navigationService.navigateTo(name)
  }

  build() {
    Stack() {
      Column({ space: AppSpacing.SECTION_GAP }) {
        Column({ space: AppSpacing.TEXT_GAP }) {
          Text($r('app.string.label_dialogs'))
            .fontSize(11).fontWeight(FontWeight.Medium)
            .fontColor(AppColor.ACCENT).letterSpacing(2)
          Text($r('app.string.label_workout_patterns'))
            .fontSize(16).fontWeight(FontWeight.Bold)
            .fontColor(AppColor.TEXT_PRIMARY).textAlign(TextAlign.Center)
        }

        Column({ space: AppSpacing.COMPONENT_GAP }) {
          this.navButton($r('app.string.action_standard'), $r('app.string.caption_classic_dialogs'),
            AppColor.SURFACE_ELEVATED, AppColor.TEXT_PRIMARY,
            () => {
              this.navigationService.navigateTo(Page.STANDARD_PAGE)
            })
          this.navButton($r('app.string.action_enhanced'), $r('app.string.caption_dialogv2'),
            AppColor.ACCENT, AppColor.BACKGROUND,
            () => {
              this.navigationService.navigateTo(Page.ENHANCED_PAGE)
            })
        }
        .width('90%')
      }
      .padding({
        left: AppSpacing.EDGE_HORIZONTAL,
        right: AppSpacing.EDGE_HORIZONTAL,
        top: AppSpacing.EDGE_TOP,
        bottom: AppSpacing.EDGE_BOTTOM
      })
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%').height('100%')
    .backgroundColor(AppColor.BACKGROUND)
    .align(Alignment.Center)
  }

  @Builder
  navButton(label: ResourceStr, caption: ResourceStr, bg: ResourceColor, fg: ResourceColor, onTap: () => void) {
    Column({ space: AppSpacing.TEXT_GAP }) {
      Button(label)
        .type(ButtonType.Capsule)
        .width('100%')
        .height(AppSize.BUTTON_HEIGHT)
        .fontSize(15)
        .fontColor(fg)
        .backgroundColor(bg)
        .onClick(onTap)
      Text(caption).fontSize(11).fontColor(AppColor.TEXT_SECONDARY)
    }
  }
}