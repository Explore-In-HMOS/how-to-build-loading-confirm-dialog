import { ConfirmDialog, LoadingDialog, TipsDialog } from '@kit.ArkUI';
import { WorkoutSessionCard } from '../components/WorkoutSessionCard';
import { MockWorkoutProvider } from '../provider/MockWorkoutProvider';
import { WorkoutSession } from '../model/WorkoutSession';
import { AppColor, AppSize, AppSpacing } from '../theme/AppTheme';

@Component
export struct StandardDialogsPage {
  @State session: WorkoutSession = MockWorkoutProvider.getCurrentSession();
  @State confirmChecked: boolean = false;

  private confirmController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      title: $r('app.string.dialog_end_workout_title'),
      content: $r('app.string.dialog_end_session_simple'),
      checkTips: $r('app.string.dialog_do_not_ask_me_again'),
      isChecked: this.confirmChecked,
      onCheckedChange: (checked: boolean) => {
        this.confirmChecked = checked;
      },
      primaryButton: {
        value: $r('app.string.action_cancel'), action: () => {
        }
      },
      secondaryButton: {
        value: $r('app.string.action_end'), role: ButtonRole.ERROR, action: () => {
        }
      }
    }),
    width: AppSize.DIALOG_WIDTH as Dimension,
    height: AppSize.DIALOG_HEIGHT as Dimension
  });

  private loadingController: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ content: $r('app.string.dialog_syncing_simple') })
  });

  private tipsController: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.startIcon'),
      title: $r('app.string.dialog_tip_title'),
      content: $r('app.string.dialog_tip_content_short'),
      primaryButton: {
        value: $r('app.string.action_got_it'), action: () => {
        }
      }
    }),
    width: AppSize.DIALOG_WIDTH as Dimension,
    height: AppSize.DIALOG_HEIGHT as Dimension
  });

  build() {
    Scroll() {
      Column({ space: AppSpacing.COMPONENT_GAP }) {
        Column({ space: AppSpacing.TEXT_GAP }) {
          Text($r('app.string.label_standard'))
            .fontSize(11).fontWeight(FontWeight.Medium)
            .fontColor(AppColor.ACCENT).letterSpacing(2)
          Text($r('app.string.label_standard_caption'))
            .fontSize(11).fontColor(AppColor.TEXT_SECONDARY)
        }

        WorkoutSessionCard({ session: this.session })

        Column({ space: AppSpacing.COMPONENT_GAP }) {
          this.actionButton($r('app.string.btn_end_session'), () => {
            this.confirmController.open();
          })
          this.actionButton($r('app.string.btn_sync_data'), () => {
            this.loadingController.open();
            setTimeout(() => {
              this.loadingController.close();
            }, 1500);
          })
          this.actionButton($r('app.string.btn_show_tip'), () => {
            this.tipsController.open();
          })
        }
        .width('100%')
      }
      .width('100%')
      .padding({
        left: AppSpacing.EDGE_HORIZONTAL,
        right: AppSpacing.EDGE_HORIZONTAL,
        top: AppSpacing.EDGE_TOP,
        bottom: AppSpacing.EDGE_BOTTOM_SCROLL
      })
      .alignItems(HorizontalAlign.Center)
    }
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
    .backgroundColor(AppColor.BACKGROUND)
  }

  @Builder
  actionButton(label: ResourceStr, onTap: () => void) {
    Button(label)
      .type(ButtonType.Capsule)
      .width('100%')
      .height(AppSize.BUTTON_HEIGHT)
      .fontSize(14)
      .fontColor(AppColor.TEXT_PRIMARY)
      .backgroundColor(AppColor.SURFACE_ELEVATED)
      .onClick(onTap)
  }
}