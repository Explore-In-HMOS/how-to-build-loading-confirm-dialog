import {
  ConfirmDialogV2,
  LoadingDialogV2,
  TipsDialogV2,
  CustomContentDialogV2,
  AdvancedDialogV2Button,
  ColorMetrics,
  LengthMetrics
} from '@kit.ArkUI';
import { WorkoutSessionCard } from '../components/WorkoutSessionCard';
import { MockWorkoutProvider } from '../provider/MockWorkoutProvider';
import { WorkoutSession } from '../model/WorkoutSession';
import { DialogController } from '../controller/DialogController';
import { AppColor, AppSize, AppSpacing } from '../theme/AppTheme';
import { BusinessError } from '@kit.BasicServicesKit';


@ComponentV2
export struct EnhancedDialogsPage {
  @Local session: WorkoutSession = MockWorkoutProvider.getCurrentSession();
  @Local confirmChecked: boolean = false;
  @Local tipsChecked: boolean = false;
  @Local loadingDialogId: number = 0;
  @Local syncProgress: number = 0;
  private dialogController: DialogController | null = null;

  aboutToAppear(): void {
    this.dialogController = new DialogController(this.getUIContext());
  }

  @Builder
  confirmDialogBuilder(): void {
    ConfirmDialogV2({
      title: $r('app.string.dialog_end_workout_title'),
      content: $r('app.string.dialog_end_workout_content',
        this.session.type, this.session.durationMinutes, this.session.calories),
      checkTips: $r('app.string.dialog_do_not_ask_again'),
      checked: this.confirmChecked,
      onCheckedChange: (checked: boolean) => {
        this.confirmChecked = checked;
      },
      primaryButton: new AdvancedDialogV2Button({
        content: $r('app.string.action_cancel'), action: () => {
        }
      }),
      secondaryButton: new AdvancedDialogV2Button({
        content: $r('app.string.action_end'), role: ButtonRole.ERROR, action: () => {
        }
      })
    });
  }

  @Builder
  loadingDialogBuilder(): void {
    LoadingDialogV2({ content: $r('app.string.dialog_syncing_progress', this.syncProgress) });
  }

  @Builder
  tipsDialogBuilder(): void {
    TipsDialogV2({
      imageRes: $r('app.media.startIcon'),
      imageSize: { width: 40, height: 40 },
      imageBorderColor: ColorMetrics.resourceColor(AppColor.ACCENT),
      imageBorderWidth: LengthMetrics.vp(2),
      title: $r('app.string.dialog_tip_title'),
      content: $r('app.string.dialog_tip_content_long'),
      checkTips: $r('app.string.dialog_do_not_ask_again'),
      checked: this.tipsChecked,
      onCheckedChange: (checked: boolean) => {
        this.tipsChecked = checked;
      },
      primaryButton: new AdvancedDialogV2Button({
        content: $r('app.string.action_got_it'), action: () => {
        }
      })
    });
  }

  @Builder
  customDialogBuilder(): void {
    CustomContentDialogV2({
      primaryTitle: $r('app.string.dialog_summary_title'),
      contentBuilder: () => {
        this.summaryContent();
      },
      buttons: [
        new AdvancedDialogV2Button({
          content: $r('app.string.action_close'), buttonStyle: ButtonStyleMode.TEXTUAL, action: () => {
          }
        }),
        new AdvancedDialogV2Button({
          content: $r('app.string.action_share'), buttonStyle: ButtonStyleMode.TEXTUAL, action: () => {
          }
        })
      ]
    });
  }

  @Builder
  summaryContent(): void {
    Column({ space: AppSpacing.COMPONENT_GAP }) {
      Text(this.session.type)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColor.TEXT_PRIMARY)
        .textAlign(TextAlign.Center)
        .width('100%')

      Row({ space: AppSpacing.COMPONENT_GAP }) {
        this.metric(`${this.session.durationMinutes}`, $r('app.string.unit_min'))
        this.metric(`${this.session.distanceKm}`, $r('app.string.unit_km'))
        this.metric(`${this.session.calories}`, $r('app.string.unit_kcal'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .padding(AppSpacing.COMPONENT_GAP)
    .borderRadius(AppSize.RADIUS_CARD)
    .backgroundColor(AppColor.SURFACE)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  metric(value: string, unit: ResourceStr) {
    Column({ space: 2 }) {
      Text(value).fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppColor.ACCENT)
      Text(unit).fontSize(9).fontColor(AppColor.TEXT_SECONDARY)
    }
  }

  openConfirm(): void {
    this.dialogController?.open(() => {
      this.confirmDialogBuilder();
    });
  }

  openLoading(): void {
    this.syncProgress = 0;
    this.dialogController?.openAuto(() => {
      this.loadingDialogBuilder();
    }).then((dialogId: number) => {
      this.loadingDialogId = dialogId;
      this.runMockSync();
    });
  }

  openTips(): void {
    this.dialogController?.open(() => {
      try {
        this.tipsDialogBuilder();
      } catch (e){
        const err = e as BusinessError;
        console.error(`Failed to open tips dialog: ${err.message}`);
      }
    });
  }

  openCustom(): void {
    this.dialogController?.open(() => {
      this.customDialogBuilder();
    });
  }

  runMockSync(): void {
    const timer = setInterval(() => {
      this.syncProgress += 20;
      if (this.syncProgress >= 100) {
        this.syncProgress = 100;
        clearInterval(timer);
        setTimeout(() => {
          this.dialogController?.close(this.loadingDialogId);
        }, 400);
      }
    }, 500);
  }

  build() {
    Scroll() {
      Column({ space: AppSpacing.SECTION_GAP }) {
        Column({ space: AppSpacing.TEXT_GAP }) {
          Text($r('app.string.label_enhanced'))
            .fontSize(11).fontWeight(FontWeight.Medium)
            .fontColor(AppColor.ACCENT).letterSpacing(2)
          Text($r('app.string.label_dialogv2_caption'))
            .fontSize(11).fontColor(AppColor.TEXT_SECONDARY)
        }

        WorkoutSessionCard({ session: this.session })

        Column({ space: AppSpacing.COMPONENT_GAP }) {
          this.actionButton($r('app.string.btn_end_session'), () => {
            this.openConfirm();
          })
          this.actionButton($r('app.string.btn_sync_data'), () => {
            this.openLoading();
          })
          this.actionButton($r('app.string.btn_show_tip'), () => {
            this.openTips();
          })
          this.actionButton($r('app.string.btn_summary'), () => {
            this.openCustom();
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